#!/bin/bash
#
# Example 5: Wait for Service to be Ready
# Demonstrates: Until loops, timeout handling, service readiness checks
#

set -euo pipefail

echo "======================================="
echo "  WAIT FOR SERVICE READY"
echo "======================================="
echo ""

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

wait_for_service() {
    local service=$1
    local max_wait=${2:-60}
    local elapsed=0
    
    log "Waiting for $service to be ready..."
    
    until [ $elapsed -ge $max_wait ]; do
        # Simulate service check
        if [ $((RANDOM % 10)) -lt 3 ]; then
            echo ""
            log "  ✓ $service is ready!"
            return 0
        fi
        
        echo -n "."
        sleep 2
        ((elapsed+=2))
    done
    
    echo ""
    log "  ✗ Timeout: $service did not become ready"
    return 1
}

# Test with different timeouts
wait_for_service "web-server" 10
echo ""
wait_for_service "database-server" 20
