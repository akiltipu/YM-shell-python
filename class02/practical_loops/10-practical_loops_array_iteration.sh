#!/bin/bash
#
# Example 10: Indexed Array Processing
# Demonstrates: Array iteration with indices, progress calculation
#

set -euo pipefail

echo "======================================="
echo "  INDEXED ARRAY PROCESSING"
echo "======================================="
echo ""

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

declare -a tasks=(
    "Backup database"
    "Clear cache"
    "Restart services"
    "Update DNS"
    "Send notifications"
)

log "Task execution plan:"
echo ""

for index in "${!tasks[@]}"; do
    task_number=$((index + 1))
    task="${tasks[$index]}"
    
    log "Step $task_number: $task"
    
    # Simulate task execution
    sleep 1
    
    # Calculate progress
    progress=$(( (task_number * 100) / ${#tasks[@]} ))
    echo "  Progress: $progress%"
    echo ""
done

log "✓ All tasks completed"
