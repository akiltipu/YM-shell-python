#!/bin/bash

# Practical Example: Production Deployment Tool
# Demonstrates: Argument validation, environment checking, version parsing

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
VERBOSE=false
DRY_RUN=false
ROLLBACK=false
ENVIRONMENT=""
VERSION=""
SERVICE=""

# Function to display usage
usage() {
    cat << EOF
${BLUE}Production Deployment Tool${NC}

Usage: $0 [OPTIONS] -e ENVIRONMENT -s SERVICE -v VERSION

${YELLOW}Required Arguments:${NC}
    -e, --environment ENV    Target environment (dev, staging, production)
    -s, --service SERVICE    Service name to deploy
    -v, --version VERSION    Version to deploy (e.g., v1.2.3)

${YELLOW}Optional Arguments:${NC}
    -d, --dry-run           Simulate deployment without making changes
    -r, --rollback          Rollback to previous version
    --verbose               Enable verbose output
    -h, --help              Show this help message

${YELLOW}Examples:${NC}
    # Deploy to staging
    $0 -e staging -s api -v v1.2.3

    # Production deployment with dry-run
    $0 -e production -s web -v v2.0.0 --dry-run

    # Rollback in production
    $0 -e production -s api --rollback

EOF
    exit 0
}

# Function to log messages
log() {
    local level=$1
    shift
    local message="$@"
    
    case $level in
        INFO)
            echo -e "${GREEN}[INFO]${NC} $message"
            ;;
        WARN)
            echo -e "${YELLOW}[WARN]${NC} $message"
            ;;
        ERROR)
            echo -e "${RED}[ERROR]${NC} $message" >&2
            ;;
        DEBUG)
            if [ "$VERBOSE" = true ]; then
                echo -e "${BLUE}[DEBUG]${NC} $message"
            fi
            ;;
    esac
}

# Function to validate environment
validate_environment() {
    local env=$1
    case $env in
        dev|development)
            ENVIRONMENT="dev"
            ;;
        staging|stage)
            ENVIRONMENT="staging"
            ;;
        prod|production)
            ENVIRONMENT="production"
            ;;
        *)
            log ERROR "Invalid environment: $env"
            log ERROR "Valid environments: dev, staging, production"
            exit 1
            ;;
    esac
    log DEBUG "Environment validated: $ENVIRONMENT"
}

# Function to validate version format
validate_version() {
    local version=$1
    
    # Check version format (v1.2.3 or 1.2.3)
    if [[ ! $version =~ ^v?[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        log ERROR "Invalid version format: $version"
        log ERROR "Expected format: v1.2.3 or 1.2.3"
        exit 1
    fi
    
    # Ensure version starts with 'v'
    if [[ ! $version =~ ^v ]]; then
        VERSION="v$version"
    else
        VERSION="$version"
    fi
    
    log DEBUG "Version validated: $VERSION"
}

# Function to check if service exists
validate_service() {
    local service=$1
    local valid_services=("api" "web" "worker" "cache" "database")
    
    if [[ ! " ${valid_services[@]} " =~ " ${service} " ]]; then
        log ERROR "Invalid service: $service"
        log ERROR "Valid services: ${valid_services[*]}"
        exit 1
    fi
    
    SERVICE=$service
    log DEBUG "Service validated: $SERVICE"
}

# Function to perform deployment
deploy() {
    log INFO "Starting deployment..."
    log INFO "Environment: $ENVIRONMENT"
    log INFO "Service: $SERVICE"
    log INFO "Version: $VERSION"
    
    if [ "$DRY_RUN" = true ]; then
        log WARN "DRY RUN MODE - No actual changes will be made"
    fi
    
    # Simulated deployment steps
    local steps=(
        "Checking deployment prerequisites"
        "Pulling Docker image: $SERVICE:$VERSION"
        "Running database migrations"
        "Updating configuration"
        "Rolling out new version"
        "Performing health checks"
        "Switching traffic"
    )
    
    for step in "${steps[@]}"; do
        log INFO "→ $step..."
        sleep 0.5  # Simulate work
        
        if [ "$DRY_RUN" = false ]; then
            log DEBUG "Executing: $step"
        fi
    done
    
    if [ "$DRY_RUN" = true ]; then
        log INFO "Deployment simulation completed successfully!"
    else
        log INFO "Deployment completed successfully!"
    fi
}

# Function to perform rollback
rollback() {
    log WARN "Starting rollback..."
    log INFO "Environment: $ENVIRONMENT"
    log INFO "Service: $SERVICE"
    
    if [ "$ENVIRONMENT" = "production" ]; then
        log WARN "Rolling back in PRODUCTION environment!"
        log INFO "Fetching previous version..."
        local previous_version="v1.1.9"  # Simulated
        log INFO "Previous version: $previous_version"
        
        if [ "$DRY_RUN" = false ]; then
            log INFO "Reverting to $previous_version..."
            sleep 1
            log INFO "Rollback completed successfully!"
        else
            log WARN "DRY RUN: Would rollback to $previous_version"
        fi
    else
        log INFO "Rollback initiated for $ENVIRONMENT environment"
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--environment)
            validate_environment "$2"
            shift 2
            ;;
        -s|--service)
            validate_service "$2"
            shift 2
            ;;
        -v|--version)
            validate_version "$2"
            shift 2
            ;;
        -d|--dry-run)
            DRY_RUN=true
            log INFO "Dry-run mode enabled"
            shift
            ;;
        -r|--rollback)
            ROLLBACK=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            log DEBUG "Verbose mode enabled"
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            log ERROR "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Validate required arguments (except for rollback)
if [ "$ROLLBACK" = false ]; then
    if [ -z "$ENVIRONMENT" ] || [ -z "$SERVICE" ] || [ -z "$VERSION" ]; then
        log ERROR "Missing required arguments"
        echo ""
        usage
    fi
fi

# Validate required arguments for rollback
if [ "$ROLLBACK" = true ]; then
    if [ -z "$ENVIRONMENT" ] || [ -z "$SERVICE" ]; then
        log ERROR "Rollback requires environment and service"
        echo ""
        usage
    fi
fi

# Main execution
log INFO "=== Deployment Tool ===" 
echo ""

if [ "$ROLLBACK" = true ]; then
    rollback
else
    deploy
fi

echo ""
log INFO "Operation completed at $(date)"
