#!/bin/bash
#
# Example 4: Log File Processing Pipeline
# Demonstrates: File iteration, pattern matching, data extraction
#

set -euo pipefail

echo "======================================="
echo "  LOG FILE PROCESSING PIPELINE"
echo "======================================="
echo ""

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Create sample log files
mkdir -p /tmp/logs
for i in {1..3}; do
    cat > "/tmp/logs/app-$i.log" << EOF
2025-11-30 10:00:00 INFO Application started
2025-11-30 10:05:00 ERROR Connection timeout
2025-11-30 10:10:00 WARN High memory usage
2025-11-30 10:15:00 ERROR Database unreachable
2025-11-30 10:20:00 INFO Request processed
EOF
done

log "Processing log files..."
echo ""

# Process each log file
while IFS= read -r -d '' log_file; do
    log "Processing: $(basename "$log_file")"
    
    # Count errors
    local error_count=$(grep -c "ERROR" "$log_file")
    log "  Errors: $error_count"
    
    # Count warnings
    local warn_count=$(grep -c "WARN" "$log_file")
    log "  Warnings: $warn_count"
    
    # Extract errors
    if [ $error_count -gt 0 ]; then
        log "  Error details:"
        while IFS= read -r error_line; do
            log "    $error_line"
        done < <(grep "ERROR" "$log_file")
    fi
    
    echo ""
done < <(find /tmp/logs -name "*.log" -type f -print0)

# Cleanup
rm -rf /tmp/logs

log "✓ Log processing completed"
