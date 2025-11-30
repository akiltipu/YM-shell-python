#!/bin/bash
#
# Example 2: Retry Mechanism with Exponential Backoff
# Demonstrates: While loops, exponential backoff, connection retry logic
#

set -euo pipefail

echo "======================================="
echo "  RETRY WITH EXPONENTIAL BACKOFF"
echo "======================================="
echo ""

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

connect_with_retry() {
    local service=$1
    local max_attempts=${2:-5}
    local attempt=1
    
    log "Connecting to $service..."
    
    while [ $attempt -le $max_attempts ]; do
        log "  Attempt $attempt of $max_attempts"
        
        # Simulate connection (70% success rate)
        if [ $((RANDOM % 10)) -lt 7 ]; then
            log "  ✓ Successfully connected to $service"
            return 0
        else
            log "  ✗ Connection failed"
            
            if [ $attempt -lt $max_attempts ]; then
                local backoff=$((2 ** attempt))
                log "  Waiting ${backoff}s before retry..."
                sleep $backoff
            fi
        fi
        
        ((attempt++))
    done
    
    log "  ✗ FAILED: Could not connect after $max_attempts attempts"
    return 1
}

# Test with different services
connect_with_retry "database-server" 4
echo ""
connect_with_retry "cache-server" 3
