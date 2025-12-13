#!/bin/bash
set -euo pipefail

# Practical Error Handling Example 6: Error Logging
# Demonstrates proper error logging with different severity levels

echo "=== Error Logging ==="

# Log file
readonly LOG_FILE="/tmp/script_errors.log"

# Logging functions
log_info() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $message" | tee -a "$LOG_FILE"
}

log_warn() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] $message" | tee -a "$LOG_FILE"
}

log_error() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $message" | tee -a "$LOG_FILE" >&2
}

log_debug() {
    local message="$1"
    if [[ "${DEBUG:-0}" == "1" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [DEBUG] $message" | tee -a "$LOG_FILE"
    fi
}

# Error handler with logging
error_exit() {
    local line_number="$1"
    local message="${2:-Unknown error}"
    log_error "Script failed at line $line_number: $message"
    log_error "Stack trace: $BASH_COMMAND"
    exit 1
}

# Set up error trap
trap 'error_exit ${LINENO} "Command failed"' ERR

# Initialize log
echo "" > "$LOG_FILE"
log_info "Script started"

# Simulate operations with logging
log_info "Starting deployment process"
log_debug "Checking prerequisites"

log_info "Validating configuration"
sleep 0.5

log_warn "Deprecated configuration option detected"
sleep 0.5

log_info "Deploying application"
sleep 0.5

# Simulate a handled error
if [[ ! -f "/tmp/nonexistent_config.yaml" ]]; then
    log_warn "Configuration file not found, using defaults"
fi

log_info "Deployment completed successfully"
log_info "Script finished"

echo ""
echo "Log file contents:"
cat "$LOG_FILE"
