#!/bin/bash
#
# Example 3: Parallel Task Execution
# Demonstrates: Background processes, job control, parallel processing
#

set -euo pipefail

echo "======================================="
echo "  PARALLEL TASK EXECUTION"
echo "======================================="
echo ""

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

process_task() {
    local task_id=$1
    local duration=$((RANDOM % 3 + 1))
    
    log "Task $task_id: Started (duration: ${duration}s)"
    sleep $duration
    log "Task $task_id: Completed"
}

# Start parallel tasks
log "Starting parallel task execution..."
pids=()

for task_id in {1..5}; do
    process_task "$task_id" &
    pids+=($!)
done

# Wait for all tasks
log "Waiting for all tasks to complete..."
failed=0

for pid in "${pids[@]}"; do
    if wait "$pid"; then
        : # Success
    else
        ((failed++))
    fi
done

if [ $failed -eq 0 ]; then
    log "✓ All tasks completed successfully"
else
    log "✗ $failed task(s) failed"
fi
