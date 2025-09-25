#!/usr/bin/env python3
"""
Test script to verify the Apple Private Relay email fix
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from duplicate_users_detector import DuplicateUsersDetector, DuplicateDetectionConfig

def test_apple_relay_emails():
    """Test that Apple Private Relay emails are not incorrectly grouped together."""
    
    # Create test configuration
    config = DuplicateDetectionConfig(
        project_id="test",
        collection_name="users",
        detection_fields=["email"],
        fuzzy_threshold=0.8,
        dry_run=True
    )
    
    # Create detector instance
    detector = DuplicateUsersDetector(config)
    
    # Test data with Apple Private Relay emails
    test_users = [
        {
            "_document_id": "user1",
            "email": "kgtz26tv46@privaterelay.appleid.com",
            "name": "Apple John"
        },
        {
            "_document_id": "user2", 
            "email": "j2pjhftvtk@privaterelay.appleid.com",
            "name": "Justin Mendoza"
        },
        {
            "_document_id": "user3",
            "email": "mknt26qyr8@privaterelay.appleid.com", 
            "name": "Richard Hill"
        },
        {
            "_document_id": "user4",
            "email": "mahmoudreda1811@gmail.com",
            "name": "Mahmoud Reda"
        },
        {
            "_document_id": "user5",
            "email": "mahmoudreda1811@gmail.com",  # Exact duplicate
            "name": "Mahmoud Reda"
        }
    ]
    
    print("Testing Apple Private Relay email handling...")
    print("=" * 50)
    
    # Test exact duplicate detection
    print("1. Testing exact duplicate detection:")
    exact_duplicates = detector._detect_exact_duplicates(test_users)
    
    for group in exact_duplicates:
        print(f"   Found exact duplicates by {group.primary_field}: {len(group.user_ids)} users")
        print(f"   Value: {group.field_value}")
        print(f"   User IDs: {group.user_ids}")
        print()
    
    # Test fuzzy duplicate detection
    print("2. Testing fuzzy duplicate detection:")
    fuzzy_duplicates = detector._detect_fuzzy_duplicates(test_users)
    
    for group in fuzzy_duplicates:
        print(f"   Found fuzzy duplicates by {group.primary_field}: {len(group.user_ids)} users")
        print(f"   Value: {group.field_value}")
        print(f"   Confidence: {group.confidence_score:.2f}")
        print(f"   User IDs: {group.user_ids}")
        print()
    
    # Test merging
    print("3. Testing group merging:")
    merged_groups = detector._merge_duplicate_groups(exact_duplicates, fuzzy_duplicates)
    
    for group in merged_groups:
        print(f"   Merged group by {group.primary_field}: {len(group.user_ids)} users")
        print(f"   Value: {group.field_value}")
        print(f"   Confidence: {group.confidence_score:.2f}")
        print(f"   User IDs: {group.user_ids}")
        print()
    
    # Verify results
    print("4. Verification:")
    apple_relay_groups = [g for g in merged_groups if '@privaterelay.appleid.com' in g.field_value]
    gmail_groups = [g for g in merged_groups if '@gmail.com' in g.field_value]
    
    print(f"   Apple Private Relay groups: {len(apple_relay_groups)}")
    print(f"   Gmail groups: {len(gmail_groups)}")
    
    # Check if Apple Private Relay emails are incorrectly grouped
    large_apple_groups = [g for g in apple_relay_groups if len(g.user_ids) > 1]
    
    if large_apple_groups:
        print("   ❌ PROBLEM: Apple Private Relay emails are being grouped together!")
        for group in large_apple_groups:
            print(f"      Group with {len(group.user_ids)} users: {group.field_value}")
    else:
        print("   ✅ SUCCESS: Apple Private Relay emails are treated as unique!")
    
    # Check if Gmail duplicates are correctly detected
    if gmail_groups and any(len(g.user_ids) > 1 for g in gmail_groups):
        print("   ✅ SUCCESS: Gmail duplicates are correctly detected!")
    else:
        print("   ❌ PROBLEM: Gmail duplicates are not being detected!")

if __name__ == "__main__":
    test_apple_relay_emails()
