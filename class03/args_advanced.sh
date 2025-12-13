#!/bin/bash
# Advanced Command-Line Arguments with Flags

# Default values
environment="dev"
verbose=false
dry_run=false
server=""

# Usage function
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -e, --environment ENV    Set environment (dev/staging/prod)"
    echo "  -s, --server SERVER      Set server name"
    echo "  -v, --verbose            Enable verbose output"
    echo "  -d, --dry-run            Dry run mode (no actual changes)"
    echo "  -h, --help               Show this help message"
    echo ""
    echo "Example:"
    echo "  $0 -e prod -s web01 -v"
    exit 1
}

# Parse arguments
while [ $# -gt 0 ]; do
    case $1 in
        -e|--environment)
            environment="$2"
            shift 2
            ;;
        -s|--server)
            server="$2"
            shift 2
            ;;
        -v|--verbose)
            verbose=true
            shift
            ;;
        -d|--dry-run)
            dry_run=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate required arguments
if [ -z "$server" ]; then
    echo "Error: Server name is required!"
    usage
fi

# Validate environment
if [[ ! "$environment" =~ ^(dev|staging|prod)$ ]]; then
    echo "Error: Invalid environment. Must be dev, staging, or prod"
    exit 1
fi

# Display configuration
echo "======================================="
echo "       DEPLOYMENT CONFIGURATION"
echo "======================================="
echo "Environment: $environment"
echo "Server: $server"
echo "Verbose: $verbose"
echo "Dry Run: $dry_run"
echo "======================================="
echo ""

# Simulate deployment
if [ "$dry_run" = true ]; then
    echo "[DRY RUN] Would deploy to $server in $environment"
else
    echo "Deploying to $server in $environment..."
    [ "$verbose" = true ] && echo "[VERBOSE] Connecting to $server..."
    [ "$verbose" = true ] && echo "[VERBOSE] Deploying application..."
    [ "$verbose" = true ] && echo "[VERBOSE] Restarting services..."
    echo "Deployment complete!"
fi
