#!/bin/bash
#
# Example 1: Logging Functions Demo
# Demonstrates: Structured logging, log levels, debug mode
#

set -euo pipefail

echo "======================================="
echo "  LOGGING FUNCTIONS DEMO"
echo "======================================="
echo ""

#==========================================
# LOGGING FUNCTIONS
#==========================================

readonly LOG_FILE="/tmp/logging_demo_$(date +%Y%m%d).log"

log_message() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

log_info() {
    log_message "INFO" "$@"
}

log_warn() {
    log_message "WARN" "$@"
}

log_error() {
    log_message "ERROR" "$@" >&2
}

log_success() {
    log_message "SUCCESS" "$@"
}

log_debug() {
    if [ "${DEBUG:-false}" = "true" ]; then
        log_message "DEBUG" "$@"
    fi
}

#==========================================
# DEMO
#==========================================

log_info "Application starting..."
log_info "Initializing configuration..."
log_debug "Loading configuration from /etc/app/config.yml"

log_warn "Cache miss detected, rebuilding..."
log_success "Configuration loaded successfully"

log_info "Starting main process..."
log_debug "Process ID: $$"

# Simulate an error
log_error "Failed to connect to external API"
log_info "Retrying with backoff..."
log_success "Connection established on retry"

log_info "Application ready"
echo ""
log_info "Log file location: $LOG_FILE"
echo ""

# Enable debug mode and show the difference
DEBUG=true
log_debug "This debug message is now visible!"
