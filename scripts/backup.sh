#!/bin/bash

# Firestore Backup Shell Script
# Provides easy execution of the Python backup script with proper setup

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BACKUP_SCRIPT="$SCRIPT_DIR/firestore_backup.py"
CONFIG_FILE="$SCRIPT_DIR/backup_config.json"
VENV_DIR="$SCRIPT_DIR/venv"
LOG_DIR="$SCRIPT_DIR/logs"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Python 3 is available
check_python() {
    if ! command -v python3 &> /dev/null; then
        log_error "Python 3 is required but not installed"
        exit 1
    fi
    
    local python_version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
    log_info "Using Python $python_version"
}

# Setup virtual environment
setup_venv() {
    if [ ! -d "$VENV_DIR" ]; then
        log_info "Creating virtual environment..."
        python3 -m venv "$VENV_DIR"
    fi
    
    log_info "Activating virtual environment..."
    source "$VENV_DIR/bin/activate"
    
    # Upgrade pip
    pip install --upgrade pip > /dev/null 2>&1
    
    # Install requirements
    if [ -f "$SCRIPT_DIR/requirements.txt" ]; then
        log_info "Installing Python dependencies..."
        pip install -r "$SCRIPT_DIR/requirements.txt" > /dev/null 2>&1
    else
        log_warning "requirements.txt not found, installing minimal dependencies..."
        pip install google-cloud-firestore google-cloud-storage > /dev/null 2>&1
    fi
}

# Check Firebase authentication
check_auth() {
    log_info "Checking Firebase authentication..."
    
    # Check for service account key
    if [ -n "${GOOGLE_APPLICATION_CREDENTIALS:-}" ]; then
        if [ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
            log_success "Service account key found: $GOOGLE_APPLICATION_CREDENTIALS"
            return 0
        else
            log_error "Service account key file not found: $GOOGLE_APPLICATION_CREDENTIALS"
            return 1
        fi
    fi
    
    # Check for gcloud auth
    if command -v gcloud &> /dev/null; then
        if gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
            log_success "gcloud authentication found"
            return 0
        fi
    fi
    
    log_error "No Firebase authentication found!"
    log_info "Please either:"
    log_info "1. Set GOOGLE_APPLICATION_CREDENTIALS environment variable"
    log_info "2. Run: gcloud auth application-default login"
    log_info "3. Use a service account key file"
    return 1
}

# Create necessary directories
setup_directories() {
    log_info "Setting up directories..."
    mkdir -p "$LOG_DIR"
    mkdir -p "$(dirname "$CONFIG_FILE")/backups"
}

# Run backup with error handling
run_backup() {
    local config_arg=""
    local project_arg=""
    local collections_arg=""
    local backup_dir_arg=""
    local gcs_bucket_arg=""
    local compression_arg=""
    local retention_arg=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --config)
                config_arg="--config $2"
                shift 2
                ;;
            --project-id)
                project_arg="--project-id $2"
                shift 2
                ;;
            --collections)
                shift
                collections_arg="--collections"
                while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
                    collections_arg="$collections_arg $1"
                    shift
                done
                ;;
            --backup-dir)
                backup_dir_arg="--backup-dir $2"
                shift 2
                ;;
            --gcs-bucket)
                gcs_bucket_arg="--gcs-bucket $2"
                shift 2
                ;;
            --no-compression)
                compression_arg="--no-compression"
                shift
                ;;
            --retention-days)
                retention_arg="--retention-days $2"
                shift 2
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Use config file if no specific arguments provided
    if [ -z "$config_arg" ] && [ -f "$CONFIG_FILE" ]; then
        config_arg="--config $CONFIG_FILE"
    fi
    
    log_info "Starting Firestore backup..."
    log_info "Command: python3 $BACKUP_SCRIPT $config_arg $project_arg $collections_arg $backup_dir_arg $gcs_bucket_arg $compression_arg $retention_arg"
    
    # Run the backup script
    if python3 "$BACKUP_SCRIPT" $config_arg $project_arg $collections_arg $backup_dir_arg $gcs_bucket_arg $compression_arg $retention_arg; then
        log_success "Backup completed successfully!"
    else
        log_error "Backup failed!"
        exit 1
    fi
}

# Show help information
show_help() {
    cat << EOF
Firestore Backup Script

Usage: $0 [OPTIONS]

Options:
    --config FILE           Configuration file path (default: backup_config.json)
    --project-id ID         Firebase project ID (default: transport-app-d662f)
    --collections LIST      Space-separated list of collections to backup
    --backup-dir DIR        Backup directory (default: ./backups)
    --gcs-bucket BUCKET     Google Cloud Storage bucket for remote backup
    --no-compression        Disable compression
    --retention-days DAYS   Days to retain backups (default: 30)
    --help, -h              Show this help message

Examples:
    # Basic backup with default settings
    $0

    # Backup specific collections
    $0 --collections users occasions friends

    # Backup with custom project and GCS upload
    $0 --project-id my-project --gcs-bucket my-backup-bucket

    # Backup with custom config file
    $0 --config /path/to/custom_config.json

Environment Variables:
    GOOGLE_APPLICATION_CREDENTIALS    Path to service account key file
    GOOGLE_CLOUD_PROJECT              Default project ID

Authentication:
    The script requires Firebase authentication. Set up one of:
    1. GOOGLE_APPLICATION_CREDENTIALS environment variable
    2. Run: gcloud auth application-default login
    3. Use a service account key file

EOF
}

# Main execution
main() {
    log_info "Firestore Backup Script Starting..."
    log_info "Script directory: $SCRIPT_DIR"
    log_info "Project root: $PROJECT_ROOT"
    
    # Pre-flight checks
    check_python
    setup_directories
    setup_venv
    
    if ! check_auth; then
        exit 1
    fi
    
    # Run backup
    run_backup "$@"
    
    log_success "Script completed successfully!"
}

# Handle script interruption
trap 'log_warning "Script interrupted by user"; exit 130' INT TERM

# Run main function with all arguments
main "$@"

