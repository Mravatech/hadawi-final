# Firestore Backup System

A production-grade backup solution for your Hadawi app's Firestore database with comprehensive error handling, scheduling, and monitoring capabilities.

## 🚀 Features

- **Complete Collection Backup**: Exports all documents and subcollections
- **Compression & Encryption**: Optional gzip compression and encryption
- **Automated Scheduling**: Cron-like scheduling with multiple backup strategies
- **Cloud Storage Integration**: Automatic upload to Google Cloud Storage
- **Retention Policies**: Automated cleanup of old backups
- **Email Notifications**: Success/failure notifications with detailed reports
- **Comprehensive Logging**: Structured logging with file and console output
- **Error Recovery**: Robust error handling with retry mechanisms
- **Checksum Verification**: File integrity verification with SHA-256

## 📁 Project Structure

```
scripts/
├── firestore_backup.py      # Main backup script
├── scheduler.py             # Automated scheduling system
├── backup.sh               # Shell wrapper for easy execution
├── backup_config.json      # Backup configuration
├── requirements.txt        # Python dependencies
└── README.md              # This documentation
```

## 🛠️ Installation

### Prerequisites

1. **Python 3.8+** installed on your system
2. **Firebase Project** with Firestore enabled
3. **Authentication** set up (see Authentication section)

### Setup

1. **Clone and navigate to scripts directory**:
   ```bash
   cd /path/to/hadawi-final/scripts
   ```

2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Set up authentication** (see Authentication section below)

## 🔐 Authentication

The backup system requires Firebase authentication. Choose one of the following methods:

### Method 1: Service Account Key (Recommended for Production)

1. **Create a service account**:
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project (`transport-app-d662f`)
   - Go to Project Settings → Service Accounts
   - Click "Generate new private key"
   - Save the JSON file securely

2. **Set environment variable**:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/service-account-key.json"
   ```

### Method 2: gcloud CLI (Development)

```bash
# Install gcloud CLI
# https://cloud.google.com/sdk/docs/install

# Authenticate
gcloud auth application-default login

# Set project
gcloud config set project transport-app-d662f
```

## 🚀 Quick Start

### Basic Backup

```bash
# Run backup with default settings
./backup.sh

# Or using Python directly
python3 firestore_backup.py --project-id transport-app-d662f
```

### Custom Backup

```bash
# Backup specific collections
./backup.sh --collections users occasions friends

# Backup with custom directory
./backup.sh --backup-dir /path/to/backups

# Backup with GCS upload
./backup.sh --gcs-bucket your-backup-bucket
```

## ⚙️ Configuration

### Backup Configuration (`backup_config.json`)

```json
{
  "project_id": "transport-app-d662f",
  "backup_dir": "./backups",
  "collections": [
    "users",
    "occasions", 
    "friends",
    "visitors",
    "payments",
    "notifications",
    "settings",
    "wallets"
  ],
  "compression": true,
  "encryption": false,
  "retention_days": 30,
  "gcs_bucket": null,
  "gcs_prefix": "firestore-backups",
  "max_retries": 3,
  "batch_size": 100
}
```

### Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `project_id` | string | Required | Firebase project ID |
| `backup_dir` | string | `./backups` | Local backup directory |
| `collections` | array | `[]` | Collections to backup (empty = all) |
| `compression` | boolean | `true` | Enable gzip compression |
| `encryption` | boolean | `false` | Enable file encryption |
| `retention_days` | integer | `30` | Days to retain backups |
| `gcs_bucket` | string | `null` | GCS bucket for remote backup |
| `gcs_prefix` | string | `firestore-backups` | GCS path prefix |
| `max_retries` | integer | `3` | Maximum retry attempts |
| `batch_size` | integer | `100` | Documents per batch |

## 📅 Automated Scheduling

### Setup Scheduler

1. **Create scheduler configuration**:
   ```bash
   python3 scheduler.py --create-config
   ```

2. **Edit `scheduler_config.json`**:
   ```json
   {
     "log_file": "./logs/scheduler.log",
     "email": {
       "enabled": true,
       "smtp_server": "smtp.gmail.com",
       "smtp_port": 587,
       "username": "your-email@gmail.com",
       "password": "your-app-password",
       "from_email": "your-email@gmail.com",
       "to_emails": ["admin@yourcompany.com"]
     },
     "backup_jobs": [
       {
         "name": "daily_backup",
         "project_id": "transport-app-d662f",
         "backup_dir": "./backups/daily",
         "collections": [],
         "compression": true,
         "retention_days": 7,
         "gcs_bucket": "your-backup-bucket",
         "schedule": "daily 02:00"
       }
     ]
   }
   ```

3. **Run scheduler**:
   ```bash
   python3 scheduler.py --config scheduler_config.json
   ```

### Schedule Formats

- `daily 02:00` - Daily at 2:00 AM
- `weekly sunday 03:00` - Weekly on Sunday at 3:00 AM
- `hourly 4` - Every 4 hours

## 📊 Monitoring & Logging

### Log Files

- **Backup logs**: `./backups/logs/backup_YYYYMMDD_HHMMSS.log`
- **Scheduler logs**: `./logs/scheduler.log`

### Log Levels

- **INFO**: General operation information
- **WARNING**: Non-critical issues
- **ERROR**: Backup failures and errors
- **DEBUG**: Detailed debugging information

### Email Notifications

Configure email notifications for:
- ✅ Successful backups with statistics
- ❌ Failed backups with error details
- 🔄 Scheduler start/stop events

## 🔧 Advanced Usage

### Command Line Options

```bash
# Python script options
python3 firestore_backup.py [OPTIONS]

Options:
  --project-id ID         Firebase project ID
  --backup-dir DIR        Backup directory
  --collections LIST      Collections to backup
  --config FILE           Configuration file
  --gcs-bucket BUCKET     GCS bucket for upload
  --no-compression        Disable compression
  --retention-days DAYS   Backup retention period
  --help                  Show help message
```

### Shell Script Options

```bash
# Shell script options
./backup.sh [OPTIONS]

# Same options as Python script plus:
# Automatic virtual environment setup
# Authentication checking
# Error handling and logging
```

### Programmatic Usage

```python
from firestore_backup import FirestoreBackup, BackupConfig

# Create configuration
config = BackupConfig(
    project_id="transport-app-d662f",
    backup_dir="./backups",
    collections=["users", "occasions"],
    compression=True,
    retention_days=30
)

# Run backup
backup_util = FirestoreBackup(config)
metadata = backup_util.create_backup()

print(f"Backup completed: {metadata.total_documents} documents")
```

## 🛡️ Security Best Practices

### Production Deployment

1. **Use Service Account Keys**:
   - Store keys in secure location
   - Set proper file permissions (600)
   - Rotate keys regularly

2. **Enable Encryption**:
   ```json
   {
     "encryption": true
   }
   ```

3. **Secure GCS Buckets**:
   - Enable bucket versioning
   - Set up lifecycle policies
   - Use IAM for access control

4. **Network Security**:
   - Run on secure servers
   - Use VPN for remote access
   - Monitor access logs

### Environment Variables

```bash
# Required
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
export GOOGLE_CLOUD_PROJECT="transport-app-d662f"

# Optional
export BACKUP_ENCRYPTION_KEY="your-encryption-key"
export GCS_BACKUP_BUCKET="your-backup-bucket"
```

## 🚨 Troubleshooting

### Common Issues

1. **Authentication Errors**:
   ```
   Error: Authentication failed
   Solution: Check GOOGLE_APPLICATION_CREDENTIALS or run gcloud auth
   ```

2. **Permission Denied**:
   ```
   Error: Permission denied accessing collection
   Solution: Ensure service account has Firestore read permissions
   ```

3. **Large Collection Timeout**:
   ```
   Error: Collection export timeout
   Solution: Increase batch_size or use collection-specific backups
   ```

4. **GCS Upload Failed**:
   ```
   Error: GCS upload failed
   Solution: Check bucket permissions and network connectivity
   ```

### Debug Mode

```bash
# Enable debug logging
export PYTHONPATH=.
python3 -c "
import logging
logging.basicConfig(level=logging.DEBUG)
from firestore_backup import FirestoreBackup, BackupConfig
# ... your backup code
"
```

### Health Checks

```bash
# Test authentication
gcloud auth list

# Test Firestore access
gcloud firestore collections list --project=transport-app-d662f

# Test GCS access
gsutil ls gs://your-backup-bucket
```

## 📈 Performance Optimization

### Large Collections

For collections with >10,000 documents:

1. **Increase batch size**:
   ```json
   {
     "batch_size": 500
   }
   ```

2. **Use collection-specific backups**:
   ```bash
   ./backup.sh --collections large_collection
   ```

3. **Enable compression**:
   ```json
   {
     "compression": true
   }
   ```

### Network Optimization

1. **Use regional GCS buckets**:
   - Choose bucket region close to your server
   - Reduces upload/download latency

2. **Parallel uploads**:
   - Multiple backup jobs can run simultaneously
   - Use different GCS prefixes

## 🔄 Backup Restoration

### Manual Restoration

```python
import json
from google.cloud import firestore

# Load backup file
with open('backup_20240101_020000.json', 'r') as f:
    backup_data = json.load(f)

# Initialize Firestore client
db = firestore.Client(project='transport-app-d662f')

# Restore collections
for collection_name, collection_data in backup_data['collections'].items():
    collection_ref = db.collection(collection_name)
    
    for doc_id, doc_data in collection_data['documents'].items():
        doc_ref = collection_ref.document(doc_id)
        doc_ref.set(doc_data['data'])
        
        # Restore subcollections
        for subcollection_name, subcollection_data in doc_data['subcollections'].items():
            for subdoc in subcollection_data:
                subdoc_ref = doc_ref.collection(subcollection_name).document(subdoc['id'])
                subdoc_ref.set(subdoc['data'])
```

### Automated Restoration Script

```bash
# Create restoration script (future enhancement)
python3 restore_backup.py --backup-file backup_20240101_020000.json --project-id transport-app-d662f
```

## 📋 Maintenance

### Regular Tasks

1. **Monitor backup logs**:
   ```bash
   tail -f ./backups/logs/backup_*.log
   ```

2. **Check backup integrity**:
   ```bash
   # Verify checksums
   find ./backups -name "*.json.gz" -exec sha256sum {} \;
   ```

3. **Clean up old logs**:
   ```bash
   find ./backups/logs -name "*.log" -mtime +30 -delete
   ```

4. **Update dependencies**:
   ```bash
   pip install --upgrade -r requirements.txt
   ```

### Backup Verification

```bash
# Test backup creation
./backup.sh --collections users

# Verify backup file
ls -la ./backups/
gunzip -t ./backups/backup_*.json.gz

# Check backup metadata
cat ./backups/metadata_*.json
```

## 📞 Support

For issues and questions:

1. **Check logs** for detailed error messages
2. **Verify authentication** and permissions
3. **Test with small collections** first
4. **Review configuration** for typos

## 📄 License

This backup system is part of the Hadawi app project and follows the same licensing terms.

---

**⚠️ Important**: Always test backups in a development environment before relying on them in production. Regularly verify backup integrity and test restoration procedures.

