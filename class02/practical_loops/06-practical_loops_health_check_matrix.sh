#!/bin/bash
#
# Example 6: Multi-Server Multi-Service Health Check
# Demonstrates: Nested loops, health monitoring matrix
#

set -euo pipefail

echo "======================================="
echo "  HEALTH CHECK MATRIX"
echo "======================================="
echo ""

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

declare -a check_servers=("web01" "web02" "db01")
declare -a check_services=("nginx" "app" "monitoring")

log "Running health check matrix..."
echo ""

for server in "${check_servers[@]}"; do
    log "Server: $server"
    
    for service in "${check_services[@]}"; do
        # Simulate health check
        if [ $((RANDOM % 10)) -lt 8 ]; then
            echo "  ✓ $service: Running"
        else
            echo "  ✗ $service: Down"
        fi
    done
    
    echo ""
done

log "✓ Health check completed"
