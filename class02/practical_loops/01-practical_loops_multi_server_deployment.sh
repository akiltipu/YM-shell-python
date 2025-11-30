#!/bin/bash
#
# Example 1: Multi-Server Sequential Deployment
# Demonstrates: Array iteration, progress tracking, error handling
#

set -euo pipefail

echo "======================================="
echo "  MULTI-SERVER DEPLOYMENT"
echo "======================================="
echo ""

# Server list
declare -a SERVERS=(
    "web01.example.com"
    "web02.example.com"
    "api01.example.com"
    "api02.example.com"
    "cache01.example.com"
)

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

deploy_to_server() {
    local server=$1
    log "Deploying to $server..."
    
    # Simulate deployment steps
    sleep 1
    
    # Simulate random success/failure (90% success rate)
    if [ $((RANDOM % 10)) -lt 9 ]; then
        log "  ✓ Successfully deployed to $server"
        return 0
    else
        log "  ✗ Failed to deploy to $server"
        return 1
    fi
}

# Sequential deployment
success_count=0
failure_count=0

for i in "${!SERVERS[@]}"; do
    server="${SERVERS[$i]}"
    progress=$((i + 1))
    total=${#SERVERS[@]}
    
    echo ""
    log "[$progress/$total] Processing: $server"
    
    if deploy_to_server "$server"; then
        ((success_count++))
    else
        ((failure_count++))
        
        # Optionally stop on first failure
        # break
    fi
done

echo ""
log "========================================="
log "Deployment Summary:"
log "  Total Servers: ${#SERVERS[@]}"
log "  Successful: $success_count"
log "  Failed: $failure_count"
log "========================================="
