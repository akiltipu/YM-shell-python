#!/bin/bash
# Production Deployment Script with Error Handling

set -euo pipefail  # Strict error handling

# Configuration
SCRIPT_NAME=$(basename "$0")
LOG_FILE="deploy_$(date +%Y%m%d_%H%M%S).log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

# Error handling
error_exit() {
    log_error "$1"
    log_error "Deployment failed. Check $LOG_FILE for details."
    cleanup
    exit 1
}

# Cleanup function
cleanup() {
    log_info "Performing cleanup..."
    # Add cleanup tasks here
}

trap cleanup EXIT
trap 'error_exit "Script interrupted by user"' INT TERM

# Usage
usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS]

Deploy application to specified environment.

OPTIONS:
    -e, --env ENV          Environment (dev/staging/prod) [required]
    -v, --version VERSION  Application version [required]
    -b, --branch BRANCH    Git branch (default: main)
    -d, --dry-run          Perform dry run only
    -h, --help             Show this help message

EXAMPLES:
    $SCRIPT_NAME -e prod -v 1.2.3
    $SCRIPT_NAME -e staging -v 1.2.3 -b develop
    $SCRIPT_NAME -e prod -v 1.2.3 -d

EOF
    exit 0
}

# Default values
environment=""
version=""
branch="main"
dry_run=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--env)
            environment="$2"
            shift 2
            ;;
        -v|--version)
            version="$2"
            shift 2
            ;;
        -b|--branch)
            branch="$2"
            shift 2
            ;;
        -d|--dry-run)
            dry_run=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            error_exit "Unknown option: $1"
            ;;
    esac
done

# Validate required arguments
[ -z "$environment" ] && error_exit "Environment is required. Use -e or --env"
[ -z "$version" ] && error_exit "Version is required. Use -v or --version"

# Validate environment
if [[ ! "$environment" =~ ^(dev|staging|prod)$ ]]; then
    error_exit "Invalid environment: $environment. Must be dev, staging, or prod"
fi

# Validate version format
version_pattern="^[0-9]+\.[0-9]+\.[0-9]+$"
if [[ ! "$version" =~ $version_pattern ]]; then
    error_exit "Invalid version format: $version. Expected: X.Y.Z"
fi

# Start deployment
echo "======================================="
echo "    APPLICATION DEPLOYMENT"
echo "======================================="
log_info "Environment: $environment"
log_info "Version: $version"
log_info "Branch: $branch"
log_info "Dry Run: $dry_run"
echo "======================================="
echo ""

# Pre-deployment checks
log_info "Running pre-deployment checks..."

# Check 1: Git available
if ! command -v git &> /dev/null; then
    error_exit "Git is not installed"
fi
log_info "✓ Git is available"

# Check 2: Required directories
required_dirs=("config" "scripts")
for dir in "${required_dirs[@]}"; do
    if [ ! -d "$dir" ]; then
        log_warn "Creating missing directory: $dir"
        mkdir -p "$dir" || error_exit "Failed to create directory: $dir"
    fi
done
log_info "✓ Required directories exist"

# Check 3: Disk space
available_space=$(df . | tail -1 | awk '{print $4}')
if [ "$available_space" -lt 1000000 ]; then
    log_warn "Low disk space: ${available_space}KB available"
fi

# Deployment steps
if [ "$dry_run" = true ]; then
    log_warn "DRY RUN MODE - No actual changes will be made"
    echo ""
fi

steps=(
    "Backup current version"
    "Pull latest code from $branch"
    "Install dependencies"
    "Run database migrations"
    "Build application"
    "Run tests"
    "Deploy to $environment"
    "Verify deployment"
)

for i in "${!steps[@]}"; do
    step_num=$((i + 1))
    step="${steps[$i]}"
    
    log_info "Step $step_num/${#steps[@]}: $step"
    
    if [ "$dry_run" = false ]; then
        # Simulate step execution
        sleep 1
        
        # Random failure for demo (remove in production)
        if [ $((RANDOM % 10)) -eq 0 ]; then
            error_exit "Failed at step: $step"
        fi
    fi
    
    log_info "✓ Completed: $step"
    echo ""
done

# Success
echo "======================================="
log_info "Deployment completed successfully!"
log_info "Version $version deployed to $environment"
log_info "Logs saved to: $LOG_FILE"
echo "======================================="

exit 0
