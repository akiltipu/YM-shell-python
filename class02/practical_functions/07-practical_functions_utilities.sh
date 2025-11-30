#!/bin/bash
#
# Example 7: Utility Functions Demo
# Demonstrates: Command retry, execution time measurement, error handling
#

set -euo pipefail

echo "======================================="
echo "  UTILITY FUNCTIONS DEMO"
echo "======================================="
echo ""

log_info() {
    echo "[INFO] $*"
}

log_success() {
    echo "[SUCCESS] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
}

log_warn() {
    echo "[WARN] $*"
}

#==========================================
# UTILITY FUNCTIONS
#==========================================

retry_command() {
    local max_attempts=$1
    shift
    local command="$@"
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        log_info "Executing (attempt $attempt/$max_attempts): $command"
        
        if eval "$command"; then
            log_success "Command succeeded"
            return 0
        fi
        
        log_warn "Command failed"
        
        if [ $attempt -lt $max_attempts ]; then
            local wait_time=$((attempt * 2))
            log_info "Waiting ${wait_time}s before retry..."
            sleep $wait_time
        fi
        
        ((attempt++))
    done
    
    log_error "Command failed after $max_attempts attempts"
    return 1
}

measure_execution_time() {
    local command="$@"
    local start_time=$(date +%s)
    
    log_info "Starting: $command"
    
    eval "$command"
    local exit_code=$?
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    log_info "Completed in ${duration}s (exit code: $exit_code)"
    
    return $exit_code
}

#==========================================
# DEMO
#==========================================

echo "Test 1: Retry command (simulating failures)"
echo ""

# Simulate a command that fails twice then succeeds
counter=0
flaky_command() {
    ((counter++))
    if [ $counter -lt 3 ]; then
        log_warn "Simulated failure ($counter)"
        return 1
    else
        log_success "Simulated success"
        return 0
    fi
}

retry_command 3 "flaky_command"
echo ""

echo "Test 2: Measure execution time"
echo ""

measure_execution_time "sleep 2"
echo ""

measure_execution_time "echo 'Quick command'"
echo ""

echo "Test 3: Retry with real command"
echo ""

# Test with a command that should succeed
retry_command 2 "ls /tmp > /dev/null"
echo ""

log_success "Utility functions demo completed!"
