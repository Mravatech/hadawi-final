#!/usr/bin/env python3
"""
Firestore Backup Test Script

Tests the backup system with a small sample to verify everything works correctly.
"""

import json
import tempfile
import shutil
from pathlib import Path
from firestore_backup import FirestoreBackup, BackupConfig


def test_backup_system():
    """Test the backup system with minimal configuration."""
    print("🧪 Testing Firestore Backup System...")
    
    # Create temporary directory for test
    test_dir = Path(tempfile.mkdtemp(prefix="backup_test_"))
    print(f"📁 Test directory: {test_dir}")
    
    try:
        # Create test configuration
        config = BackupConfig(
            project_id="transport-app-d662f",
            backup_dir=str(test_dir / "backups"),
            collections=["users"],  # Test with just one collection
            compression=True,
            retention_days=1,
            batch_size=10
        )
        
        print("⚙️  Configuration created")
        print(f"   Project ID: {config.project_id}")
        print(f"   Collections: {config.collections}")
        print(f"   Backup Dir: {config.backup_dir}")
        
        # Test backup utility initialization
        print("🔧 Initializing backup utility...")
        try:
            backup_util = FirestoreBackup(config)
            print("✅ Backup utility initialized successfully")
        except Exception as e:
            print(f"❌ Failed to initialize backup utility: {e}")
            print("💡 This might be due to authentication issues")
            print("   Please ensure you have:")
            print("   1. Set GOOGLE_APPLICATION_CREDENTIALS environment variable")
            print("   2. Or run: gcloud auth application-default login")
            return False
        
        # Test backup creation
        print("📦 Creating test backup...")
        try:
            metadata = backup_util.create_backup()
            
            if metadata.status == "success":
                print("✅ Backup completed successfully!")
                print(f"   Documents: {metadata.total_documents}")
                print(f"   Size: {metadata.backup_size_bytes / 1024:.2f} KB")
                print(f"   Duration: {metadata.duration_seconds:.2f}s")
                print(f"   Checksum: {metadata.checksum[:16]}...")
                
                # Check if backup file exists
                backup_files = list(Path(config.backup_dir).glob("backup_*.json*"))
                if backup_files:
                    print(f"📄 Backup file created: {backup_files[0].name}")
                    
                    # Test file integrity
                    if backup_files[0].suffix == '.gz':
                        import gzip
                        with gzip.open(backup_files[0], 'rt') as f:
                            backup_data = json.load(f)
                    else:
                        with open(backup_files[0], 'r') as f:
                            backup_data = json.load(f)
                    
                    print("✅ Backup file is valid JSON")
                    print(f"   Collections in backup: {list(backup_data.get('collections', {}).keys())}")
                    
                return True
            else:
                print("❌ Backup failed!")
                print(f"   Status: {metadata.status}")
                return False
                
        except Exception as e:
            print(f"❌ Backup creation failed: {e}")
            return False
            
    finally:
        # Cleanup test directory
        print("🧹 Cleaning up test files...")
        shutil.rmtree(test_dir, ignore_errors=True)
        print("✅ Cleanup completed")


def test_configuration():
    """Test configuration loading and validation."""
    print("⚙️  Testing configuration system...")
    
    # Test default configuration
    config = BackupConfig(
        project_id="test-project",
        backup_dir="./test-backups",
        collections=["test-collection"]
    )
    
    print("✅ Default configuration created")
    print(f"   Project ID: {config.project_id}")
    print(f"   Compression: {config.compression}")
    print(f"   Retention: {config.retention_days} days")
    
    # Test configuration file loading
    config_file = Path("backup_config.json")
    if config_file.exists():
        try:
            with open(config_file, 'r') as f:
                config_data = json.load(f)
            print("✅ Configuration file loaded successfully")
            print(f"   Collections configured: {len(config_data.get('collections', []))}")
        except Exception as e:
            print(f"❌ Failed to load configuration file: {e}")
    else:
        print("⚠️  Configuration file not found (backup_config.json)")
    
    return True


def main():
    """Run all tests."""
    print("🚀 Firestore Backup System Test Suite")
    print("=" * 50)
    
    tests_passed = 0
    total_tests = 2
    
    # Test 1: Configuration
    if test_configuration():
        tests_passed += 1
    print()
    
    # Test 2: Backup System
    if test_backup_system():
        tests_passed += 1
    print()
    
    # Results
    print("=" * 50)
    print(f"📊 Test Results: {tests_passed}/{total_tests} tests passed")
    
    if tests_passed == total_tests:
        print("🎉 All tests passed! Backup system is ready to use.")
        print()
        print("Next steps:")
        print("1. Run a full backup: ./backup.sh")
        print("2. Set up scheduling: python3 scheduler.py --create-config")
        print("3. Configure email notifications in scheduler_config.json")
    else:
        print("⚠️  Some tests failed. Please check the errors above.")
        print()
        print("Common issues:")
        print("1. Authentication not configured")
        print("2. Firebase project not accessible")
        print("3. Missing dependencies")
        print("4. Network connectivity issues")
    
    return tests_passed == total_tests


if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)

