#!/bin/bash
#
# Example 9: Continuous Monitoring Loop
# Demonstrates: Monitoring patterns, metric collection, alerting
#

set -euo pipefail

echo "======================================="
echo "  CONTINUOUS MONITORING"
echo "======================================="
echo ""

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

monitor_service() {
    local service=$1
    local duration=${2:-10}
    local interval=2
    local elapsed=0
    
    log "Monitoring $service for ${duration}s..."
    
    while [ $elapsed -lt $duration ]; do
        # Simulate metric collection
        local cpu=$((RANDOM % 100))
        local memory=$((RANDOM % 100))
        
        echo -n "  [${elapsed}s] CPU: ${cpu}% | Memory: ${memory}%"
        
        if [ $cpu -gt 90 ] || [ $memory -gt 90 ]; then
            echo " ⚠ ALERT"
        else
            echo " ✓"
        fi
        
        sleep $interval
        ((elapsed+=interval))
    done
    
    log "Monitoring completed"
}

monitor_service "webapp" 10
