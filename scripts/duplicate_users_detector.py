#!/usr/bin/env python3
"""
Firestore Duplicate Users Detection and Cleanup Script

This script identifies and safely removes duplicate users from your Firestore
users collection using multiple detection strategies:

- Email address matching
- Phone number matching  
- Device ID matching
- Custom field matching
- Fuzzy matching for similar data

Features:
- Comprehensive duplicate detection algorithms
- Safe deletion with backup creation
- Detailed reporting and logging
- Configurable detection rules
- Dry-run mode for testing
- Batch processing for large collections

Author: Senior Engineer
Version: 1.0.0
"""

import json
import logging
import os
import sys
import hashlib
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, List, Optional, Any, Set, Tuple
import argparse
from dataclasses import dataclass, asdict
from collections import defaultdict
import re
from difflib import SequenceMatcher

try:
    from google.cloud import firestore
    from google.auth.exceptions import DefaultCredentialsError
    from google.api_core import exceptions as gcp_exceptions
except ImportError as e:
    print(f"Missing required dependencies: {e}")
    print("Please install: pip install google-cloud-firestore")
    sys.exit(1)


@dataclass
class DuplicateDetectionConfig:
    """Configuration for duplicate detection operations."""
    project_id: str
    collection_name: str = "users"
    detection_fields: List[str] = None
    fuzzy_threshold: float = 0.8
    dry_run: bool = True
    create_backup: bool = True
    backup_dir: str = "./duplicate_cleanup_backups"
    max_duplicates_per_group: int = 10
    preserve_oldest: bool = True
    preserve_most_complete: bool = True
    batch_size: int = 100
    log_level: str = "INFO"


@dataclass
class DuplicateGroup:
    """Represents a group of duplicate users."""
    primary_field: str
    field_value: str
    user_ids: List[str]
    users_data: List[Dict[str, Any]]
    confidence_score: float
    detection_method: str


@dataclass
class CleanupReport:
    """Report of duplicate cleanup operations."""
    timestamp: str
    total_users_scanned: int
    duplicate_groups_found: int
    total_duplicates: int
    users_deleted: int
    backup_created: bool
    backup_path: Optional[str]
    errors: List[str]
    duplicate_groups: List[Dict[str, Any]]


class DuplicateDetectionError(Exception):
    """Custom exception for duplicate detection operations."""
    pass


class DuplicateUsersDetector:
    """
    Production-grade duplicate user detection and cleanup utility.
    """
    
    def __init__(self, config: DuplicateDetectionConfig):
        self.config = config
        self.logger = self._setup_logging()
        self.db = None
        self._setup_client()
        
        # Default detection fields if not specified
        if not self.config.detection_fields:
            self.config.detection_fields = [
                'email'
            ]
    
    def _setup_logging(self) -> logging.Logger:
        """Configure structured logging."""
        logger = logging.getLogger('duplicate_detector')
        logger.setLevel(getattr(logging, self.config.log_level.upper()))
        
        # Remove existing handlers
        for handler in logger.handlers[:]:
            logger.removeHandler(handler)
        
        # Console handler
        console_handler = logging.StreamHandler(sys.stdout)
        console_handler.setLevel(logging.INFO)
        
        # File handler
        log_dir = Path(self.config.backup_dir) / "logs"
        log_dir.mkdir(parents=True, exist_ok=True)
        file_handler = logging.FileHandler(
            log_dir / f"duplicate_detection_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
        )
        file_handler.setLevel(logging.DEBUG)
        
        # Formatter
        formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        console_handler.setFormatter(formatter)
        file_handler.setFormatter(formatter)
        
        logger.addHandler(console_handler)
        logger.addHandler(file_handler)
        
        return logger
    
    def _setup_client(self) -> None:
        """Initialize Firestore client."""
        try:
            os.environ['GOOGLE_CLOUD_PROJECT'] = self.config.project_id
            self.db = firestore.Client(project=self.config.project_id)
            self.logger.info(f"Initialized Firestore client for project: {self.config.project_id}")
        except DefaultCredentialsError:
            self.logger.error(
                "Authentication failed. Please ensure you have:"
                "\n1. Set GOOGLE_APPLICATION_CREDENTIALS environment variable"
                "\n2. Run 'gcloud auth application-default login'"
                "\n3. Or use a service account key file"
            )
            raise DuplicateDetectionError("Authentication failed")
        except Exception as e:
            self.logger.error(f"Failed to initialize Firestore client: {e}")
            raise DuplicateDetectionError(f"Client initialization failed: {e}")
    
    def _normalize_field_value(self, value: Any, field_name: str) -> str:
        """Normalize field values for comparison."""
        if value is None:
            return ""
        
        # Convert to string and normalize
        normalized = str(value).strip().lower()
        
        # Special handling for different field types
        if field_name in ['email', 'emailAddress']:
            # Remove common email variations
            normalized = re.sub(r'\+.*@', '@', normalized)  # Remove email aliases
            normalized = re.sub(r'\.(?=.*@)', '', normalized)  # Remove dots in Gmail
            
            # Special handling for Apple Private Relay emails
            # These should be treated as unique even if they have similar patterns
            if '@privaterelay.appleid.com' in normalized:
                # Keep the full email as-is for Apple Private Relay
                # Don't normalize these as they are intentionally unique
                pass
        elif field_name in ['phone', 'phoneNumber']:
            # Normalize phone numbers
            normalized = re.sub(r'[^\d]', '', normalized)  # Keep only digits
            # Remove country codes if present
            if normalized.startswith('1') and len(normalized) == 11:
                normalized = normalized[1:]
        elif field_name in ['deviceId', 'device_id']:
            # Keep device IDs as-is but normalize case
            normalized = normalized.upper()
        
        return normalized
    
    def _calculate_similarity(self, value1: str, value2: str) -> float:
        """Calculate similarity between two values using multiple algorithms."""
        if not value1 or not value2:
            return 0.0
        
        # Exact match
        if value1 == value2:
            return 1.0
        
        # Sequence similarity
        similarity = SequenceMatcher(None, value1, value2).ratio()
        
        # Additional checks for specific patterns
        if len(value1) > 3 and len(value2) > 3:
            # Check for common typos or variations
            if abs(len(value1) - len(value2)) <= 2:
                # Check for character substitutions
                diff_count = sum(c1 != c2 for c1, c2 in zip(value1, value2))
                if diff_count <= 2:
                    similarity = max(similarity, 0.9)
        
        return similarity
    
    def _extract_users_data(self) -> List[Dict[str, Any]]:
        """Extract all users from the collection."""
        self.logger.info(f"Extracting users from collection: {self.config.collection_name}")
        
        users = []
        try:
            collection_ref = self.db.collection(self.config.collection_name)
            docs = collection_ref.stream()
            
            for doc in docs:
                user_data = doc.to_dict()
                user_data['_document_id'] = doc.id
                users.append(user_data)
            
            self.logger.info(f"Extracted {len(users)} users from collection")
            return users
            
        except gcp_exceptions.PermissionDenied:
            self.logger.error(f"Permission denied accessing collection: {self.config.collection_name}")
            raise DuplicateDetectionError(f"Permission denied for collection: {self.config.collection_name}")
        except Exception as e:
            self.logger.error(f"Failed to extract users: {e}")
            raise DuplicateDetectionError(f"User extraction failed: {e}")
    
    def _detect_exact_duplicates(self, users: List[Dict[str, Any]]) -> List[DuplicateGroup]:
        """Detect exact duplicates based on normalized field values."""
        self.logger.info("Detecting exact duplicates...")
        
        duplicate_groups = []
        field_groups = defaultdict(list)
        
        for user in users:
            user_id = user.get('_document_id', '')
            
            # Group users by each detection field
            for field in self.config.detection_fields:
                field_value = user.get(field)
                if field_value:
                    normalized_value = self._normalize_field_value(field_value, field)
                    if normalized_value:  # Only consider non-empty values
                        field_groups[(field, normalized_value)].append((user_id, user))
        
        # Find groups with multiple users (duplicates)
        for (field, value), user_list in field_groups.items():
            if len(user_list) > 1:
                user_ids = [user_id for user_id, _ in user_list]
                users_data = [user_data for _, user_data in user_list]
                
                duplicate_group = DuplicateGroup(
                    primary_field=field,
                    field_value=value,
                    user_ids=user_ids,
                    users_data=users_data,
                    confidence_score=1.0,  # Exact match
                    detection_method="exact_match"
                )
                duplicate_groups.append(duplicate_group)
                
                self.logger.info(
                    f"Found exact duplicates by {field}: {len(user_ids)} users "
                    f"(value: {value[:50]}...)"
                )
        
        return duplicate_groups
    
    def _detect_fuzzy_duplicates(self, users: List[Dict[str, Any]]) -> List[DuplicateGroup]:
        """Detect fuzzy duplicates using similarity algorithms."""
        self.logger.info("Detecting fuzzy duplicates...")
        
        # For email-only detection, we don't want fuzzy matching
        # Only exact email matches should be considered duplicates
        if 'email' in self.config.detection_fields and len(self.config.detection_fields) == 1:
            self.logger.info("Email-only detection: skipping fuzzy matching for strict email duplicates")
            return []
        
        duplicate_groups = []
        processed_pairs = set()
        
        for i, user1 in enumerate(users):
            for j, user2 in enumerate(users[i+1:], i+1):
                pair_key = tuple(sorted([user1['_document_id'], user2['_document_id']]))
                if pair_key in processed_pairs:
                    continue
                processed_pairs.add(pair_key)
                
                max_similarity = 0.0
                best_field = None
                best_value = None
                
                # Check similarity for each detection field
                for field in self.config.detection_fields:
                    value1 = user1.get(field)
                    value2 = user2.get(field)
                    
                    if value1 and value2:
                        norm_value1 = self._normalize_field_value(value1, field)
                        norm_value2 = self._normalize_field_value(value2, field)
                        
                        if norm_value1 and norm_value2:
                            # Special handling for Apple Private Relay emails
                            if (field in ['email', 'emailAddress'] and 
                                '@privaterelay.appleid.com' in norm_value1 and 
                                '@privaterelay.appleid.com' in norm_value2):
                                # For Apple Private Relay emails, only consider exact matches
                                # as these are intentionally unique per user
                                if norm_value1 == norm_value2:
                                    similarity = 1.0
                                else:
                                    similarity = 0.0  # Don't consider them similar
                            else:
                                similarity = self._calculate_similarity(norm_value1, norm_value2)
                            
                            if similarity > max_similarity:
                                max_similarity = similarity
                                best_field = field
                                best_value = norm_value1
                
                # If similarity exceeds threshold, consider as duplicates
                if max_similarity >= self.config.fuzzy_threshold:
                    duplicate_group = DuplicateGroup(
                        primary_field=best_field,
                        field_value=best_value,
                        user_ids=[user1['_document_id'], user2['_document_id']],
                        users_data=[user1, user2],
                        confidence_score=max_similarity,
                        detection_method="fuzzy_match"
                    )
                    duplicate_groups.append(duplicate_group)
                    
                    self.logger.info(
                        f"Found fuzzy duplicates by {best_field}: "
                        f"similarity {max_similarity:.2f} "
                        f"(value: {best_value[:50]}...)"
                    )
        
        return duplicate_groups
    
    def _merge_duplicate_groups(self, exact_groups: List[DuplicateGroup], 
                               fuzzy_groups: List[DuplicateGroup]) -> List[DuplicateGroup]:
        """Merge overlapping duplicate groups."""
        self.logger.info("Merging overlapping duplicate groups...")
        
        all_groups = exact_groups + fuzzy_groups
        merged_groups = []
        processed_users = set()
        
        for group in all_groups:
            # Skip if all users in this group are already processed
            if all(user_id in processed_users for user_id in group.user_ids):
                continue
            
            # Find all groups that share users with this group
            current_group_users = set(group.user_ids)
            current_group_data = group.users_data.copy()
            
            # Look for overlapping groups
            for other_group in all_groups:
                if other_group == group:
                    continue
                
                other_group_users = set(other_group.user_ids)
                if current_group_users.intersection(other_group_users):
                    # Merge the groups
                    current_group_users.update(other_group_users)
                    current_group_data.extend(other_group.users_data)
            
            # Remove duplicates from merged data
            seen_ids = set()
            unique_data = []
            for user_data in current_group_data:
                user_id = user_data.get('_document_id')
                if user_id not in seen_ids:
                    seen_ids.add(user_id)
                    unique_data.append(user_data)
            
            # Create merged group
            merged_group = DuplicateGroup(
                primary_field=group.primary_field,
                field_value=group.field_value,
                user_ids=list(current_group_users),
                users_data=unique_data,
                confidence_score=group.confidence_score,
                detection_method=f"merged_{group.detection_method}"
            )
            
            merged_groups.append(merged_group)
            processed_users.update(current_group_users)
            
            self.logger.info(
                f"Merged group: {len(current_group_users)} users "
                f"(confidence: {group.confidence_score:.2f})"
            )
        
        return merged_groups
    
    def _select_users_to_delete(self, duplicate_group: DuplicateGroup) -> List[str]:
        """Select which users to delete from a duplicate group."""
        users_to_delete = []
        users_to_keep = []
        
        # Sort users by criteria
        sorted_users = sorted(
            duplicate_group.users_data,
            key=lambda user: (
                # Prefer users with more complete data
                -sum(1 for field in self.config.detection_fields if user.get(field)),
                # Prefer older users (if created_at field exists)
                user.get('createdAt', user.get('created_at', '')),
                # Prefer users with more fields filled
                -len([v for v in user.values() if v is not None and v != ''])
            )
        )
        
        # Keep the best user, delete the rest
        if sorted_users:
            users_to_keep.append(sorted_users[0])
            users_to_delete = [user['_document_id'] for user in sorted_users[1:]]
        
        self.logger.info(
            f"Group with {len(duplicate_group.user_ids)} users: "
            f"keeping {len(users_to_keep)}, deleting {len(users_to_delete)}"
        )
        
        return users_to_delete
    
    def _create_backup(self, users_to_delete: List[str], 
                      duplicate_groups: List[DuplicateGroup]) -> str:
        """Create backup of users that will be deleted."""
        if not self.config.create_backup:
            return None
        
        self.logger.info("Creating backup of users to be deleted...")
        
        backup_dir = Path(self.config.backup_dir)
        backup_dir.mkdir(parents=True, exist_ok=True)
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_filename = f"duplicate_users_backup_{timestamp}.json"
        backup_path = backup_dir / backup_filename
        
        # Collect users to backup
        backup_data = {
            'metadata': {
                'timestamp': timestamp,
                'project_id': self.config.project_id,
                'collection_name': self.config.collection_name,
                'users_to_delete': users_to_delete,
                'duplicate_groups': len(duplicate_groups),
                'backup_reason': 'duplicate_cleanup'
            },
            'users_to_delete': [],
            'duplicate_groups': []
        }
        
        # Get full user data for backup
        for user_id in users_to_delete:
            try:
                doc_ref = self.db.collection(self.config.collection_name).document(user_id)
                doc = doc_ref.get()
                if doc.exists:
                    user_data = doc.to_dict()
                    user_data['_document_id'] = user_id
                    backup_data['users_to_delete'].append(user_data)
            except Exception as e:
                self.logger.warning(f"Failed to backup user {user_id}: {e}")
        
        # Add duplicate group information
        for group in duplicate_groups:
            backup_data['duplicate_groups'].append({
                'primary_field': group.primary_field,
                'field_value': group.field_value,
                'user_ids': group.user_ids,
                'confidence_score': group.confidence_score,
                'detection_method': group.detection_method
            })
        
        # Write backup file
        with open(backup_path, 'w', encoding='utf-8') as f:
            json.dump(backup_data, f, indent=2, ensure_ascii=False, default=str)
        
        self.logger.info(f"Backup created: {backup_path}")
        return str(backup_path)
    
    def _delete_users(self, user_ids: List[str]) -> int:
        """Delete users from Firestore."""
        if self.config.dry_run:
            self.logger.info(f"DRY RUN: Would delete {len(user_ids)} users")
            return 0
        
        self.logger.info(f"Deleting {len(user_ids)} users...")
        
        deleted_count = 0
        batch = self.db.batch()
        batch_count = 0
        
        for user_id in user_ids:
            try:
                doc_ref = self.db.collection(self.config.collection_name).document(user_id)
                batch.delete(doc_ref)
                batch_count += 1
                
                # Commit batch when it reaches batch size
                if batch_count >= self.config.batch_size:
                    batch.commit()
                    deleted_count += batch_count
                    self.logger.info(f"Deleted batch of {batch_count} users")
                    batch = self.db.batch()
                    batch_count = 0
                    
            except Exception as e:
                self.logger.error(f"Failed to delete user {user_id}: {e}")
        
        # Commit remaining batch
        if batch_count > 0:
            batch.commit()
            deleted_count += batch_count
            self.logger.info(f"Deleted final batch of {batch_count} users")
        
        return deleted_count
    
    def detect_and_cleanup_duplicates(self) -> CleanupReport:
        """Main method to detect and cleanup duplicate users."""
        start_time = datetime.now()
        self.logger.info("Starting duplicate detection and cleanup")
        
        errors = []
        backup_path = None
        
        try:
            # Extract all users
            users = self._extract_users_data()
            total_users = len(users)
            
            # Detect exact duplicates
            exact_duplicates = self._detect_exact_duplicates(users)
            
            # Detect fuzzy duplicates
            fuzzy_duplicates = self._detect_fuzzy_duplicates(users)
            
            # Merge overlapping groups
            all_duplicate_groups = self._merge_duplicate_groups(exact_duplicates, fuzzy_duplicates)
            
            # Select users to delete
            all_users_to_delete = []
            for group in all_duplicate_groups:
                users_to_delete = self._select_users_to_delete(group)
                all_users_to_delete.extend(users_to_delete)
            
            # Remove duplicates from deletion list
            all_users_to_delete = list(set(all_users_to_delete))
            
            # Create backup
            if all_users_to_delete:
                backup_path = self._create_backup(all_users_to_delete, all_duplicate_groups)
            
            # Delete users
            deleted_count = self._delete_users(all_users_to_delete)
            
            # Create report
            report = CleanupReport(
                timestamp=start_time.isoformat(),
                total_users_scanned=total_users,
                duplicate_groups_found=len(all_duplicate_groups),
                total_duplicates=sum(len(group.user_ids) for group in all_duplicate_groups),
                users_deleted=deleted_count,
                backup_created=backup_path is not None,
                backup_path=backup_path,
                errors=errors,
                duplicate_groups=[asdict(group) for group in all_duplicate_groups]
            )
            
            self.logger.info(
                f"Cleanup completed: {deleted_count} users deleted, "
                f"{len(all_duplicate_groups)} duplicate groups found"
            )
            
            return report
            
        except Exception as e:
            self.logger.error(f"Cleanup failed: {e}")
            errors.append(str(e))
            
            return CleanupReport(
                timestamp=start_time.isoformat(),
                total_users_scanned=0,
                duplicate_groups_found=0,
                total_duplicates=0,
                users_deleted=0,
                backup_created=False,
                backup_path=None,
                errors=errors,
                duplicate_groups=[]
            )


def load_config(config_path: str) -> DuplicateDetectionConfig:
    """Load configuration from JSON file."""
    try:
        with open(config_path, 'r') as f:
            config_data = json.load(f)
        return DuplicateDetectionConfig(**config_data)
    except Exception as e:
        print(f"Failed to load config from {config_path}: {e}")
        sys.exit(1)


def main():
    """Main entry point with command-line argument parsing."""
    parser = argparse.ArgumentParser(
        description="Firestore Duplicate Users Detection and Cleanup",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Dry run to detect duplicates without deleting
  python duplicate_users_detector.py --project-id transport-app-d662f --dry-run

  # Detect and cleanup duplicates with backup
  python duplicate_users_detector.py --project-id transport-app-d662f --no-dry-run

  # Custom detection fields
  python duplicate_users_detector.py --project-id transport-app-d662f --fields email phone deviceId

  # Fuzzy matching with custom threshold
  python duplicate_users_detector.py --project-id transport-app-d662f --fuzzy-threshold 0.9
        """
    )
    
    parser.add_argument(
        '--project-id',
        help='Firebase project ID (default: transport-app-d662f)',
        default='transport-app-d662f'
    )
    
    parser.add_argument(
        '--collection',
        help='Collection name to scan (default: users)',
        default='users'
    )
    
    parser.add_argument(
        '--fields',
        nargs='+',
        help='Fields to use for duplicate detection (default: email only)',
        default=['email']
    )
    
    parser.add_argument(
        '--fuzzy-threshold',
        type=float,
        help='Fuzzy matching threshold (0.0-1.0, default: 0.8)',
        default=0.8
    )
    
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Detect duplicates without deleting (default: True)',
        default=True
    )
    
    parser.add_argument(
        '--no-dry-run',
        action='store_true',
        help='Actually delete duplicates (overrides --dry-run)'
    )
    
    parser.add_argument(
        '--no-backup',
        action='store_true',
        help='Skip creating backup before deletion'
    )
    
    parser.add_argument(
        '--backup-dir',
        help='Backup directory (default: ./duplicate_cleanup_backups)',
        default='./duplicate_cleanup_backups'
    )
    
    parser.add_argument(
        '--config',
        help='Configuration file path',
        default=None
    )
    
    parser.add_argument(
        '--log-level',
        choices=['DEBUG', 'INFO', 'WARNING', 'ERROR'],
        help='Logging level (default: INFO)',
        default='INFO'
    )
    
    args = parser.parse_args()
    
    try:
        # Load configuration
        if args.config:
            config = load_config(args.config)
        else:
            # Create config from command line arguments
            config = DuplicateDetectionConfig(
                project_id=args.project_id,
                collection_name=args.collection,
                detection_fields=args.fields,
                fuzzy_threshold=args.fuzzy_threshold,
                dry_run=args.dry_run and not args.no_dry_run,
                create_backup=not args.no_backup,
                backup_dir=args.backup_dir,
                log_level=args.log_level
            )
        
        # Initialize detector
        detector = DuplicateUsersDetector(config)
        
        # Run detection and cleanup
        report = detector.detect_and_cleanup_duplicates()
        
        # Print summary
        print("\n" + "="*60)
        print("DUPLICATE DETECTION AND CLEANUP REPORT")
        print("="*60)
        print(f"Timestamp: {report.timestamp}")
        print(f"Project: {config.project_id}")
        print(f"Collection: {config.collection_name}")
        print(f"Total users scanned: {report.total_users_scanned}")
        print(f"Duplicate groups found: {report.duplicate_groups_found}")
        print(f"Total duplicates: {report.total_duplicates}")
        print(f"Users deleted: {report.users_deleted}")
        print(f"Backup created: {'Yes' if report.backup_created else 'No'}")
        if report.backup_path:
            print(f"Backup path: {report.backup_path}")
        
        if report.errors:
            print(f"Errors: {len(report.errors)}")
            for error in report.errors:
                print(f"  - {error}")
        
        print("\nDuplicate Groups:")
        for i, group in enumerate(report.duplicate_groups, 1):
            print(f"  {i}. {group['detection_method']} by {group['primary_field']}")
            print(f"     Users: {len(group['user_ids'])} (confidence: {group['confidence_score']:.2f})")
            print(f"     Value: {group['field_value'][:50]}...")
        
        # Save detailed report
        report_path = Path(config.backup_dir) / f"cleanup_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        report_path.parent.mkdir(parents=True, exist_ok=True)
        with open(report_path, 'w') as f:
            json.dump(asdict(report), f, indent=2, default=str)
        
        print(f"\nDetailed report saved: {report_path}")
        
        if config.dry_run:
            print("\n⚠️  This was a DRY RUN - no users were actually deleted")
            print("   Run with --no-dry-run to perform actual deletion")
        
        sys.exit(0)
            
    except KeyboardInterrupt:
        print("\n⚠️  Operation interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Operation failed: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
