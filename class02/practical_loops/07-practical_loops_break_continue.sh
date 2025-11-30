#!/bin/bash
#
# Example 7: Smart Processing with Break and Continue
# Demonstrates: Loop control, conditional skipping, early termination
#

set -euo pipefail

echo "======================================="
echo "  BREAK & CONTINUE PATTERNS"
echo "======================================="
echo ""

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

log "Processing batch of files..."

for i in {1..10}; do
    # Skip even numbers
    if [ $((i % 2)) -eq 0 ]; then
        log "  Skipping file $i (even number)"
        continue
    fi
    
    # Stop at 7
    if [ $i -eq 7 ]; then
        log "  Critical error at file $i - stopping processing"
        break
    fi
    
    log "  ✓ Processed file $i"
done

log "Processing ended"
