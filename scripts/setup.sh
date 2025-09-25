#!/bin/bash

# Firestore Backup Setup Script
# Automates the setup process for the backup system

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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
        log_info "Please install Python 3.8+ from https://python.org"
        exit 1
    fi
    
    local python_version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
    log_success "Found Python $python_version"
}

# Check if pip is available
check_pip() {
    if ! command -v pip3 &> /dev/null && ! python3 -m pip --version &> /dev/null; then
        log_error "pip is required but not installed"
        log_info "Please install pip: https://pip.pypa.io/en/stable/installation/"
        exit 1
    fi
    
    log_success "Found pip"
}

# Setup virtual environment
setup_venv() {
    local venv_dir="venv"
    
    if [ -d "$venv_dir" ]; then
        log_warning "Virtual environment already exists"
        read -p "Do you want to recreate it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Removing existing virtual environment..."
            rm -rf "$venv_dir"
        else
            log_info "Using existing virtual environment"
            return 0
        fi
    fi
    
    log_info "Creating virtual environment..."
    python3 -m venv "$venv_dir"
    
    log_info "Activating virtual environment..."
    source "$venv_dir/bin/activate"
    
    log_info "Upgrading pip..."
    pip install --upgrade pip > /dev/null 2>&1
    
    log_success "Virtual environment created and activated"
}

# Install dependencies
install_dependencies() {
    log_info "Installing Python dependencies..."
    
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt > /dev/null 2>&1
        log_success "Dependencies installed from requirements.txt"
    else
        log_warning "requirements.txt not found, installing minimal dependencies..."
        pip install google-cloud-firestore google-cloud-storage > /dev/null 2>&1
        log_success "Minimal dependencies installed"
    fi
}

# Create necessary directories
create_directories() {
    log_info "Creating necessary directories..."
    
    mkdir -p backups
    mkdir -p backups/logs
    mkdir -p logs
    
    log_success "Directories created"
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
        fi
    fi
    
    # Check for gcloud auth
    if command -v gcloud &> /dev/null; then
        if gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
            log_success "gcloud authentication found"
            return 0
        fi
    fi
    
    log_warning "No Firebase authentication found!"
    log_info "Please set up authentication:"
    log_info "1. Set GOOGLE_APPLICATION_CREDENTIALS environment variable"
    log_info "2. Run: gcloud auth application-default login"
    log_info "3. Or use a service account key file"
    
    return 1
}

# Test backup script
test_backup() {
    log_info "Testing backup script..."
    
    # Test with help command
    if python3 firestore_backup.py --help > /dev/null 2>&1; then
        log_success "Backup script is working"
    else
        log_error "Backup script test failed"
        return 1
    fi
}

# Create sample configuration
create_sample_config() {
    if [ ! -f "backup_config.json" ]; then
        log_info "Creating sample configuration..."
        cat > backup_config.json << EOF
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
EOF
        log_success "Sample configuration created: backup_config.json"
    else
        log_info "Configuration file already exists: backup_config.json"
    fi
}

# Main setup function
main() {
    log_info "Setting up Firestore Backup System..."
    echo
    
    # Pre-flight checks
    check_python
    check_pip
    
    # Setup
    setup_venv
    install_dependencies
    create_directories
    create_sample_config
    
    echo
    log_info "Setup completed successfully!"
    echo
    
    # Authentication check
    if check_auth; then
        log_success "Authentication is configured"
    else
        log_warning "Authentication not configured - please set it up before running backups"
    fi
    
    # Test backup script
    if test_backup; then
        log_success "Backup script is ready to use"
    else
        log_error "Backup script test failed"
        exit 1
    fi
    
    echo
    log_info "Next steps:"
    log_info "1. Activate virtual environment: source venv/bin/activate"
    log_info "2. Configure authentication (if not already done)"
    log_info "3. Edit backup_config.json if needed"
    log_info "4. Run backup: ./backup.sh"
    log_info "5. Or run Python script directly: python3 firestore_backup.py"
    echo
    log_success "Setup complete! 🎉"
}

# Handle script interruption
trap 'log_warning "Setup interrupted by user"; exit 130' INT TERM

# Run main function
main "$@"

