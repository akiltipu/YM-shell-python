#!/bin/bash
#
# Practical Looping Constructs
# Advanced loop examples for DevOps automation
#

set -euo pipefail

echo "======================================="
echo "    PRACTICAL LOOPING CONSTRUCTS"
echo "======================================="
echo ""

# ===== EXAMPLE 1: MULTI-SERVER DEPLOYMENT =====
echo "=== Example 1: Multi-Server Sequential Deployment ==="

# Server list
declare -a SERVERS=(
    "web01.example.com"
    "web02.example.com"
    "api01.example.com"
    "api02.example.com"
    "cache01.example.com"
)

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

deploy_to_server() {
    local server=$1
    log "Deploying to $server..."
    
    # Simulate deployment steps
    sleep 1
    
    # Simulate random success/failure (90% success rate)
    if [ $((RANDOM % 10)) -lt 9 ]; then
        log "  ✓ Successfully deployed to $server"
        return 0
    else
        log "  ✗ Failed to deploy to $server"
        return 1
    fi
}

# Sequential deployment
success_count=0
failure_count=0

for i in "${!SERVERS[@]}"; do
    server="${SERVERS[$i]}"
    progress=$((i + 1))
    total=${#SERVERS[@]}
    
    echo ""
    log "[$progress/$total] Processing: $server"
    
    if deploy_to_server "$server"; then
        ((success_count++))
    else
        ((failure_count++))
        
        # Optionally stop on first failure
        # break
    fi
done

echo ""
log "========================================="
log "Deployment Summary:"
log "  Total Servers: ${#SERVERS[@]}"
log "  Successful: $success_count"
log "  Failed: $failure_count"
log "========================================="
echo ""

# ===== EXAMPLE 2: RETRY MECHANISM WITH BACKOFF =====
echo "=== Example 2: Retry with Exponential Backoff ==="

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

connect_with_retry "database-server" 4
echo ""

# ===== EXAMPLE 3: PARALLEL PROCESSING SIMULATION =====
echo "=== Example 3: Parallel Task Execution ==="

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
echo ""

# ===== EXAMPLE 4: FILE PROCESSING PIPELINE =====
echo "=== Example 4: Log File Processing Pipeline ==="

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
echo ""

# ===== EXAMPLE 5: UNTIL LOOP - WAIT FOR SERVICE =====
echo "=== Example 5: Wait for Service to be Ready ==="

wait_for_service() {
    local service=$1
    local max_wait=${2:-60}
    local elapsed=0
    
    log "Waiting for $service to be ready..."
    
    until [ $elapsed -ge $max_wait ]; do
        # Simulate service check
        if [ $((RANDOM % 10)) -lt 3 ]; then
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

wait_for_service "web-server" 10
echo ""

# ===== EXAMPLE 6: NESTED LOOPS - HEALTH CHECK MATRIX =====
echo "=== Example 6: Multi-Server Multi-Service Health Check ==="

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

# ===== EXAMPLE 7: LOOP WITH BREAK AND CONTINUE =====
echo "=== Example 7: Smart Processing with Break/Continue ==="

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
echo ""

# ===== EXAMPLE 8: READING AND PROCESSING CSV =====
echo "=== Example 8: CSV Processing Loop ==="

# Create sample CSV
cat > /tmp/servers.csv << EOF
hostname,ip,port,status
web01,192.168.1.10,80,active
web02,192.168.1.11,80,active
db01,192.168.1.20,5432,maintenance
api01,192.168.1.30,3000,active
EOF

log "Processing server inventory..."

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

rm /tmp/servers.csv
echo ""

# ===== EXAMPLE 9: MONITORING LOOP =====
echo "=== Example 9: Continuous Monitoring Loop ==="

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

monitor_service "webapp" 8
echo ""

# ===== EXAMPLE 10: ARRAY ITERATION WITH INDEX =====
echo "=== Example 10: Indexed Array Processing ==="

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
echo ""

# ===== EXAMPLE 11: CONFIGURATION LOOP =====
echo "=== Example 11: Dynamic Configuration Generation ==="

# Generate config for multiple environments
declare -a environments=("dev" "staging" "production")

for env in "${environments[@]}"; do
    config_file="/tmp/config_${env}.conf"
    
    log "Generating config for: $env"
    
    case $env in
        dev)
            cat > "$config_file" << EOF
# Development Configuration
debug=true
log_level=DEBUG
cache_enabled=false
EOF
            ;;
        staging)
            cat > "$config_file" << EOF
# Staging Configuration
debug=true
log_level=INFO
cache_enabled=true
EOF
            ;;
        production)
            cat > "$config_file" << EOF
# Production Configuration
debug=false
log_level=ERROR
cache_enabled=true
EOF
            ;;
    esac
    
    log "  ✓ Created: $config_file"
    cat "$config_file" | sed 's/^/    /'
    echo ""
    
    rm "$config_file"
done

# ===== EXAMPLE 12: BATCH PROCESSING WITH THROTTLING =====
echo "=== Example 12: Batch Processing with Rate Limiting ==="

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
echo ""

# ===== EXAMPLE 13: MENU SYSTEM WITH LOOP =====
echo "=== Example 13: Interactive Menu System ==="

show_menu() {
    cat << EOF
========================================
          DEPLOYMENT MENU
========================================
1. Deploy to Development
2. Deploy to Staging
3. Deploy to Production
4. Rollback
5. View Status
6. Exit
========================================
EOF
}

# Simulate menu (non-interactive for demo)
log "Menu system example (simulated)"
choices=(1 5 6)

for choice in "${choices[@]}"; do
    case $choice in
        1)
            log "Selected: Deploy to Development"
            ;;
        2)
            log "Selected: Deploy to Staging"
            ;;
        3)
            log "Selected: Deploy to Production"
            ;;
        4)
            log "Selected: Rollback"
            ;;
        5)
            log "Selected: View Status"
            ;;
        6)
            log "Selected: Exit"
            break
            ;;
        *)
            log "Invalid option"
            ;;
    esac
    echo ""
done

echo ""
echo "======================================="
echo "      EXAMPLES COMPLETED"
echo "======================================="
