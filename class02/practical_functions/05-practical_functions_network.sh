#!/bin/bash
#
# Example 5: Network Functions Demo
# Demonstrates: Port checking, service availability, network validation
#

set -euo pipefail

echo "======================================="
echo "  NETWORK FUNCTIONS DEMO"
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

log_debug() {
    echo "[DEBUG] $*"
}

log_warn() {
    echo "[WARN] $*"
}

#==========================================
# NETWORK FUNCTIONS
#==========================================

check_port_open() {
    local host=$1
    local port=$2
    local timeout=${3:-5}
    
    log_debug "Checking if $host:$port is open (timeout: ${timeout}s)"
    
    if command -v nc &> /dev/null; then
        if nc -z -w "$timeout" "$host" "$port" 2>/dev/null; then
            log_debug "Port $port is open on $host"
            return 0
        else
            log_debug "Port $port is closed on $host"
            return 1
        fi
    elif command -v timeout &> /dev/null; then
        if timeout "$timeout" bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null; then
            log_debug "Port $port is open on $host"
            return 0
        else
            log_debug "Port $port is closed on $host"
            return 1
        fi
    else
        log_warn "Cannot check port (nc or timeout not available)"
        return 1
    fi
}

wait_for_port() {
    local host=$1
    local port=$2
    local max_wait=${3:-60}
    local interval=2
    local elapsed=0
    
    log_info "Waiting for $host:$port to be available (max: ${max_wait}s)..."
    
    while [ $elapsed -lt $max_wait ]; do
        if check_port_open "$host" "$port" 2; then
            echo ""
            log_success "Port $host:$port is available"
            return 0
        fi
        
        echo -n "."
        sleep $interval
        ((elapsed+=interval))
    done
    
    echo ""
    log_error "Timeout: $host:$port did not become available"
    return 1
}

#==========================================
# DEMO
#==========================================

echo "Test 1: Check if common ports are open"
echo ""

# Check localhost ports
log_info "Checking localhost common ports..."
for port in 22 80 443 3000 8080; do
    if check_port_open "localhost" "$port" 1; then
        echo "  ✓ Port $port: Open"
    else
        echo "  ✗ Port $port: Closed"
    fi
done
echo ""

echo "Test 2: Check external host (google.com:80)"
if check_port_open "google.com" "80" 3; then
    log_success "Successfully reached google.com:80"
else
    log_warn "Could not reach google.com:80"
fi
echo ""

echo "Test 3: Wait for port (simulated)"
log_info "Simulating wait for unavailable port..."
wait_for_port "localhost" "9999" 5 || log_info "Expected timeout occurred"
echo ""

log_success "Network functions demo completed!"
