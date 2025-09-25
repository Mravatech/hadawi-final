# Duplicate Users Detection and Cleanup System

A production-grade solution for identifying and safely removing duplicate users from your Firebase Firestore collection.

## 🚀 Features

- **Strict Email Detection**: Exact email matching only (no fuzzy matching for emails)
- **Safe Deletion Workflow**: Automatic backup creation before any deletions
- **Comprehensive Reporting**: Detailed logs and reports of all operations
- **Configurable Rules**: Customizable detection fields and thresholds
- **Dry-Run Mode**: Test detection without making changes
- **Batch Processing**: Efficient handling of large user collections
- **Error Recovery**: Robust error handling with detailed logging

## 📁 Files Created

```
scripts/
├── duplicate_users_detector.py    # Main Python detection script
├── duplicate_config.json          # Configuration file
├── duplicate_cleanup.sh           # Shell wrapper script
└── DUPLICATE_CLEANUP_README.md    # This documentation
```

## 🛠️ Quick Start

### 1. Basic Usage (Safe - Dry Run)

```bash
# Navigate to scripts directory
cd /path/to/hadawi-final/scripts

# Run detection without deleting (recommended first step)
./duplicate_cleanup.sh --dry-run
```

### 2. Actual Cleanup (After Review)

```bash
# Run actual cleanup with backup
./duplicate_cleanup.sh --no-dry-run
```

### 3. Custom Configuration

```bash
# Use custom detection fields
./duplicate_cleanup.sh --fields email,phone,deviceId --dry-run

# Adjust fuzzy matching threshold
./duplicate_cleanup.sh --fuzzy-threshold 0.9 --dry-run
```

## 🔍 Detection Strategies

### 1. Strict Email Matching
- **Email addresses**: Exact matching only (no fuzzy matching)
- **Normalization**: Lowercase, removes email aliases (+alias)
- **Apple Private Relay**: Each unique email treated separately
- **Gmail variations**: Removes dots in Gmail addresses

### 3. Field-Specific Normalization

#### Email Fields
```python
# Removes email aliases and dots (Gmail)
user+alias@domain.com → user@domain.com
user.name@gmail.com → username@gmail.com
```

#### Phone Fields
```python
# Normalizes to digits only
+1 (555) 123-4567 → 5551234567
+1-555-123-4567 → 5551234567
```

#### Device ID Fields
```python
# Case normalization
abc123def → ABC123DEF
```

## ⚙️ Configuration

### Default Configuration (`duplicate_config.json`)

```json
{
  "project_id": "transport-app-d662f",
  "collection_name": "users",
  "detection_fields": [
    "email",
    "phone", 
    "phoneNumber",
    "deviceId",
    "uid",
    "firebaseUid"
  ],
  "fuzzy_threshold": 0.8,
  "dry_run": true,
  "create_backup": true,
  "backup_dir": "./duplicate_cleanup_backups",
  "max_duplicates_per_group": 10,
  "preserve_oldest": true,
  "preserve_most_complete": true,
  "batch_size": 100,
  "log_level": "INFO"
}
```

### Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `project_id` | string | Required | Firebase project ID |
| `collection_name` | string | `users` | Collection to scan |
| `detection_fields` | array | `["email", "phone", ...]` | Fields to check for duplicates |
| `fuzzy_threshold` | float | `0.8` | Similarity threshold (0.0-1.0) |
| `dry_run` | boolean | `true` | Test mode (no deletions) |
| `create_backup` | boolean | `true` | Create backup before deletion |
| `backup_dir` | string | `./duplicate_cleanup_backups` | Backup location |
| `preserve_oldest` | boolean | `true` | Keep oldest user in duplicates |
| `preserve_most_complete` | boolean | `true` | Keep user with most data |
| `batch_size` | integer | `100` | Batch size for operations |
| `log_level` | string | `INFO` | Logging level |

## 🔐 Authentication

The script uses the same authentication as your backup system:

### Method 1: Service Account (Recommended)
```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
```

### Method 2: gcloud CLI
```bash
gcloud auth application-default login
gcloud config set project transport-app-d662f
```

## 📊 Usage Examples

### 1. Safe Detection (Recommended First Step)

```bash
# Basic detection
./duplicate_cleanup.sh --dry-run

# Custom fields
./duplicate_cleanup.sh --fields email,phone,deviceId --dry-run

# Stricter matching
./duplicate_cleanup.sh --fuzzy-threshold 0.9 --dry-run
```

### 2. Actual Cleanup

```bash
# Cleanup with backup
./duplicate_cleanup.sh --no-dry-run

# Skip backup (not recommended)
./duplicate_cleanup.sh --no-dry-run --no-backup
```

### 3. Custom Project/Collection

```bash
# Different project
./duplicate_cleanup.sh --project-id your-project-id --dry-run

# Different collection
./duplicate_cleanup.sh --collection customers --dry-run
```

## 📋 Output and Reports

### Console Output
```
============================================================
DUPLICATE DETECTION AND CLEANUP REPORT
============================================================
Timestamp: 2024-01-15T10:30:00
Project: transport-app-d662f
Collection: users
Total users scanned: 1,250
Duplicate groups found: 15
Total duplicates: 45
Users deleted: 30
Backup created: Yes
Backup path: ./duplicate_cleanup_backups/duplicate_users_backup_20240115_103000.json

Duplicate Groups:
  1. exact_match by email
     Users: 3 (confidence: 1.00)
     Value: john.doe@example.com...
  2. fuzzy_match by phone
     Users: 2 (confidence: 0.85)
     Value: 5551234567...
```

### Generated Files

1. **Backup File**: `duplicate_users_backup_YYYYMMDD_HHMMSS.json`
   - Contains all users that were deleted
   - Includes duplicate group information
   - Can be used for restoration if needed

2. **Detailed Report**: `cleanup_report_YYYYMMDD_HHMMSS.json`
   - Complete operation summary
   - All duplicate groups with details
   - Error logs and statistics

3. **Log Files**: `duplicate_detection_YYYYMMDD_HHMMSS.log`
   - Detailed operation logs
   - Debug information
   - Error traces

## 🛡️ Safety Features

### 1. Dry-Run Mode (Default)
- **No deletions**: Only detects and reports duplicates
- **Safe testing**: Verify results before actual cleanup
- **Full reporting**: Same reports as actual cleanup

### 2. Automatic Backup
- **Pre-deletion backup**: All users to be deleted are backed up
- **Restoration ready**: Backup includes all necessary data
- **Metadata included**: Duplicate group information preserved

### 3. Smart User Selection
- **Preserve best user**: Keeps user with most complete data
- **Age preference**: Prefers older users when data is equal
- **Configurable rules**: Customizable preservation logic

### 4. Error Handling
- **Graceful failures**: Continues processing other users on errors
- **Detailed logging**: All errors are logged with context
- **Rollback capability**: Backup allows restoration

## 🔄 Restoration Process

If you need to restore deleted users:

```python
import json
from google.cloud import firestore

# Load backup file
with open('duplicate_users_backup_20240115_103000.json', 'r') as f:
    backup_data = json.load(f)

# Initialize Firestore
db = firestore.Client(project='transport-app-d662f')

# Restore users
for user_data in backup_data['users_to_delete']:
    doc_id = user_data['_document_id']
    del user_data['_document_id']  # Remove internal field
    
    doc_ref = db.collection('users').document(doc_id)
    doc_ref.set(user_data)
    print(f"Restored user: {doc_id}")
```

## 📈 Performance Considerations

### Large Collections (>10,000 users)
- **Batch processing**: Uses configurable batch sizes
- **Memory efficient**: Processes users in chunks
- **Progress logging**: Shows progress for long operations

### Optimization Tips
1. **Start with dry-run**: Always test first
2. **Use specific fields**: Limit detection fields for faster processing
3. **Adjust batch size**: Increase for better performance
4. **Monitor logs**: Watch for memory or timeout issues

## 🚨 Troubleshooting

### Common Issues

1. **Authentication Errors**
   ```
   Error: Authentication failed
   Solution: Check GOOGLE_APPLICATION_CREDENTIALS or run gcloud auth
   ```

2. **Permission Denied**
   ```
   Error: Permission denied accessing collection
   Solution: Ensure service account has Firestore read/write permissions
   ```

3. **Large Collection Timeout**
   ```
   Error: Collection processing timeout
   Solution: Increase batch_size or process in smaller chunks
   ```

4. **Memory Issues**
   ```
   Error: Out of memory
   Solution: Reduce batch_size or process fewer users at once
   ```

### Debug Mode

```bash
# Enable debug logging
./duplicate_cleanup.sh --log-level DEBUG --dry-run
```

## 📞 Best Practices

### 1. Always Start with Dry-Run
```bash
# Step 1: Detect duplicates
./duplicate_cleanup.sh --dry-run

# Step 2: Review results
cat duplicate_cleanup_backups/cleanup_report_*.json

# Step 3: Run actual cleanup
./duplicate_cleanup.sh --no-dry-run
```

### 2. Regular Maintenance
- **Schedule runs**: Monthly duplicate detection
- **Monitor growth**: Track duplicate patterns
- **Update rules**: Adjust detection fields as needed

### 3. Data Quality
- **Validate results**: Review duplicate groups before deletion
- **Keep backups**: Maintain backup files for audit trail
- **Document changes**: Record cleanup operations

## 🔧 Advanced Usage

### Custom Detection Logic

Create a custom configuration file:

```json
{
  "project_id": "transport-app-d662f",
  "collection_name": "users",
  "detection_fields": ["email", "phone", "customId"],
  "fuzzy_threshold": 0.9,
  "dry_run": true,
  "create_backup": true,
  "preserve_most_complete": true,
  "batch_size": 50
}
```

Run with custom config:
```bash
./duplicate_cleanup.sh --config custom_config.json
```

### Integration with Backup System

The duplicate cleanup system integrates with your existing backup infrastructure:

- **Same authentication**: Uses your existing Firebase setup
- **Consistent logging**: Follows same logging patterns
- **Backup compatibility**: Creates backups in same format
- **Shared dependencies**: Uses same Python environment

## 📄 License

This duplicate cleanup system is part of the Hadawi app project and follows the same licensing terms.

---

**⚠️ Important**: Always run with `--dry-run` first to review results before performing actual deletions. Keep backups of deleted users for potential restoration needs.
