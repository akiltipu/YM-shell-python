#!/bin/bash
#
# Example 12: Batch Processing with Rate Limiting
# Demonstrates: Throttling, batch processing, rate limiting patterns
#

set -euo pipefail

echo "======================================="
echo "  BATCH PROCESSING WITH THROTTLING"
echo "======================================="
echo ""

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

process_batch() {
    local batch_size=3
    local delay=2
    local total_items=10
    local processed=0
    
    log "Processing $total_items items in batches of $batch_size"
    
    for ((i=1; i<=total_items; i++)); do
        echo "  Processing item $i..."
        ((processed++))
        
        # Check if batch complete
        if [ $((i % batch_size)) -eq 0 ]; then
            log "  Batch completed ($processed/$total_items)"
            
            if [ $i -lt $total_items ]; then
                log "  Waiting ${delay}s before next batch..."
                sleep $delay
            fi
        fi
    done
    
    log "✓ All items processed"
}

process_batch
