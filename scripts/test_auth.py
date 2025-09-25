#!/usr/bin/env python3
"""
Quick authentication test for Firebase Firestore
"""

import os
import sys

try:
    from google.cloud import firestore
    from google.auth.exceptions import DefaultCredentialsError
except ImportError as e:
    print(f"Missing dependencies: {e}")
    print("Please install: pip install google-cloud-firestore")
    sys.exit(1)

def test_auth():
    """Test Firebase authentication and connection."""
    print("Testing Firebase authentication...")
    
    try:
        # Try to initialize Firestore client
        db = firestore.Client(project='transport-app-d662f')
        print("✅ Successfully connected to Firestore!")
        
        # Try to read a collection to test permissions
        print("Testing collection access...")
        collections = list(db.collections())
        print(f"✅ Found {len(collections)} collections")
        
        # Try to access users collection specifically
        users_ref = db.collection('users')
        users_count = len(list(users_ref.limit(1).stream()))
        print(f"✅ Successfully accessed 'users' collection")
        
        return True
        
    except DefaultCredentialsError:
        print("❌ Authentication failed!")
        print("\nPlease set up authentication using one of these methods:")
        print("\n1. Service Account Key:")
        print("   export GOOGLE_APPLICATION_CREDENTIALS='/path/to/service-account.json'")
        print("\n2. gcloud CLI:")
        print("   gcloud auth application-default login")
        print("   gcloud config set project transport-app-d662f")
        return False
        
    except Exception as e:
        print(f"❌ Connection failed: {e}")
        return False

if __name__ == "__main__":
    success = test_auth()
    sys.exit(0 if success else 1)
