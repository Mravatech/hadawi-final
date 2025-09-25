#!/bin/bash

# Duplicate Users Cleanup Script
# Wrapper script for the Python duplicate detection utility

set -e  # Exit on any error

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/duplicate_users_detector.py"
CONFIG_FILE="$SCRIPT_DIR/duplicate_config.json"
VENV_DIR="$SCRIPT_DIR/venv"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if virtual environment exists
check_venv() {
    if [ ! -d "$VENV_DIR" ]; then
        print_warning "Virtual environment not found. Creating one..."
        python3 -m venv "$VENV_DIR"
        print_success "Virtual environment created"
    fi
}

# Function to activate virtual environment and install dependencies
setup_environment() {
    print_status "Setting up environment..."
    
    # Activate virtual environment
    source "$VENV_DIR/bin/activate"
    
    # Install/upgrade dependencies
    print_status "Installing dependencies..."
    pip install --upgrade pip
    pip install -r "$SCRIPT_DIR/requirements.txt"
    
    print_success "Environment setup complete"
}

# Function to check authentication
check_auth() {
    print_status "Checking Firebase authentication..."
    
    if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
        print_warning "GOOGLE_APPLICATION_CREDENTIALS not set"
        print_status "Checking for gcloud authentication..."
        
        if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
            print_error "No active gcloud authentication found"
            print_status "Please run one of the following:"
            echo "  1. Set GOOGLE_APPLICATION_CREDENTIALS environment variable"
            echo "  2. Run: gcloud auth application-default login"
            exit 1
        fi
        
        print_success "gcloud authentication found"
    else
        if [ ! -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
            print_error "Service account file not found: $GOOGLE_APPLICATION_CREDENTIALS"
            exit 1
        fi
        print_success "Service account authentication configured"
    fi
}

# Function to show help
show_help() {
    echo "Duplicate Users Cleanup Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --dry-run              Detect duplicates without deleting (default)"
    echo "  --no-dry-run           Actually delete duplicates"
    echo "  --project-id ID        Firebase project ID (default: transport-app-d662f)"
    echo "  --collection NAME      Collection name (default: users)"
    echo "  --fields FIELD1,FIELD2 Comma-separated detection fields (default: email)"
    echo "  --fuzzy-threshold NUM  Fuzzy matching threshold 0.0-1.0 (default: 0.8)"
    echo "  --no-backup            Skip creating backup before deletion"
    echo "  --config FILE          Use custom configuration file"
    echo "  --help                 Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --dry-run                    # Detect duplicates (safe)"
    echo "  $0 --no-dry-run                 # Delete duplicates with backup"
    echo "  $0 --fields email,phone         # Multiple detection fields"
    echo "  $0 --fuzzy-threshold 0.9        # Stricter fuzzy matching"
    echo ""
}

# Function to run the duplicate detection
run_detection() {
    local python_args=()
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                python_args+=("--dry-run")
                shift
                ;;
            --no-dry-run)
                python_args+=("--no-dry-run")
                shift
                ;;
            --project-id)
                python_args+=("--project-id" "$2")
                shift 2
                ;;
            --collection)
                python_args+=("--collection" "$2")
                shift 2
                ;;
            --fields)
                # Convert comma-separated to space-separated
                fields=$(echo "$2" | tr ',' ' ')
                python_args+=("--fields" $fields)
                shift 2
                ;;
            --fuzzy-threshold)
                python_args+=("--fuzzy-threshold" "$2")
                shift 2
                ;;
            --no-backup)
                python_args+=("--no-backup")
                shift
                ;;
            --config)
                python_args+=("--config" "$2")
                shift 2
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Add default config if no config specified
    if [[ ! " ${python_args[@]} " =~ " --config " ]]; then
        python_args+=("--config" "$CONFIG_FILE")
    fi
    
    print_status "Running duplicate detection..."
    print_status "Command: python3 $PYTHON_SCRIPT ${python_args[*]}"
    echo ""
    
    # Run the Python script
    python3 "$PYTHON_SCRIPT" "${python_args[@]}"
    
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        print_success "Duplicate detection completed successfully"
    else
        print_error "Duplicate detection failed with exit code: $exit_code"
        exit $exit_code
    fi
}

# Main execution
main() {
    print_status "Starting Duplicate Users Cleanup"
    print_status "Script directory: $SCRIPT_DIR"
    echo ""
    
    # Check if help was requested
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        show_help
        exit 0
    fi
    
    # Setup environment
    check_venv
    setup_environment
    
    # Check authentication
    check_auth
    
    echo ""
    print_status "All checks passed. Starting duplicate detection..."
    echo ""
    
    # Run the detection
    run_detection "$@"
}

# Run main function with all arguments
main "$@"
