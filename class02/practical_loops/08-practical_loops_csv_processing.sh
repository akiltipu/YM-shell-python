#!/bin/bash
#
# Example 8: CSV Processing Loop
# Demonstrates: CSV parsing, IFS manipulation, structured data processing
#

set -euo pipefail

echo "======================================="
echo "  CSV PROCESSING"
echo "======================================="
echo ""

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Create sample CSV
cat > /tmp/servers.csv << EOF
hostname,ip,port,status
web01,192.168.1.10,80,active
web02,192.168.1.11,80,active
db01,192.168.1.20,5432,maintenance
api01,192.168.1.30,3000,active
EOF

log "Processing server inventory..."
echo ""

# Skip header, process data
tail -n +2 /tmp/servers.csv | while IFS=',' read -r hostname ip port status; do
    log "Server: $hostname"
    echo "  IP: $ip"
    echo "  Port: $port"
    echo "  Status: $status"
    
    if [ "$status" = "active" ]; then
        echo "  Action: Include in load balancer"
    else
        echo "  Action: Skip (maintenance mode)"
    fi
    echo ""
done

# Cleanup
rm /tmp/servers.csv

log "✓ CSV processing completed"
