#!/bin/bash

# Practical Example 7: Comprehensive Error Handling Framework
# Complete error handling system for production scripts

set -euo pipefail

# Script metadata
SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PID=$$

# Configuration
LOG_DIR="/var/log/scripts"
LOG_FILE="$LOG_DIR/${SCRIPT_NAME%.sh}.log"
ERROR_LOG="$LOG_DIR/${SCRIPT_NAME%.sh}_errors.log"
LOCK_FILE="/var/run/${SCRIPT_NAME%.sh}.lock"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Error codes
readonly E_SUCCESS=0
readonly E_GENERAL=1
readonly E_USAGE=2
readonly E_PERMISSIONS=3
readonly E_NOTFOUND=4
readonly E_TIMEOUT=5
readonly E_NETWORK=6
readonly E_DEPENDENCY=7

# Logging levels
readonly LOG_DEBUG=0
readonly LOG_INFO=1
readonly LOG_WARN=2
readonly LOG_ERROR=3
readonly LOG_FATAL=4

# Current log level (set to INFO by default)
LOG_LEVEL=$LOG_INFO

# Initialize logging
init_logging() {
    mkdir -p "$LOG_DIR" 2>/dev/null || true
    touch "$LOG_FILE" "$ERROR_LOG" 2>/dev/null || true
}

# Logging function with levels
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local caller_info="${BASH_SOURCE[2]##*/}:${BASH_LINENO[1]}"
    
    # Check if we should log this level
    local level_value
    case $level in
        DEBUG) level_value=$LOG_DEBUG ;;
        INFO)  level_value=$LOG_INFO ;;
        WARN)  level_value=$LOG_WARN ;;
        ERROR) level_value=$LOG_ERROR ;;
        FATAL) level_value=$LOG_FATAL ;;
        *) level_value=$LOG_INFO ;;
    esac
    
    [ $level_value -lt $LOG_LEVEL ] && return 0
    
    # Format log message
    local log_msg="[$timestamp] [$level] [$caller_info] [PID:$PID] $message"
    
    # Write to log file
    echo "$log_msg" >> "$LOG_FILE"
    
    # Write errors to separate error log
    if [ "$level" = "ERROR" ] || [ "$level" = "FATAL" ]; then
        echo "$log_msg" >> "$ERROR_LOG"
    fi
    
    # Console output with colors
    case $level in
        DEBUG) echo -e "${BLUE}[DEBUG]${NC} $message" ;;
        INFO)  echo -e "${GREEN}[INFO]${NC} $message" ;;
        WARN)  echo -e "${YELLOW}[WARN]${NC} $message" ;;
        ERROR) echo -e "${RED}[ERROR]${NC} $message" >&2 ;;
        FATAL) echo -e "${RED}[FATAL]${NC} $message" >&2 ;;
    esac
}

# Error handler with stack trace
error_handler() {
    local line_no=$1
    local bash_lineno=$2
    local last_command=$3
    local error_code=$4
    
    log ERROR "Command failed with exit code $error_code: $last_command"
    log ERROR "Failed at line $line_no"
    
    # Stack trace
    log ERROR "Stack trace:"
    local frame=0
    while caller $frame; do
        ((frame++))
    done | while read line func file; do
        log ERROR "  at $func ($file:$line)"
    done
    
    cleanup
    exit $error_code
}

# Set up error handling
trap 'error_handler ${LINENO} ${BASH_LINENO} "$BASH_COMMAND" $?' ERR

# Cleanup function
cleanup() {
    log INFO "Performing cleanup..."
    
    # Remove lock file
    if [ -f "$LOCK_FILE" ]; then
        rm -f "$LOCK_FILE"
        log INFO "Removed lock file"
    fi
    
    # Clean up temp files
    if [ -n "${TEMP_DIR:-}" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
        log INFO "Removed temporary directory"
    fi
    
    log INFO "Cleanup complete"
}

# Exit handler
exit_handler() {
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        log INFO "Script completed successfully"
    else
        log ERROR "Script failed with exit code: $exit_code"
    fi
    
    cleanup
}

trap exit_handler EXIT

# Acquire lock to prevent concurrent execution
acquire_lock() {
    if [ -f "$LOCK_FILE" ]; then
        local lock_pid=$(cat "$LOCK_FILE")
        if ps -p "$lock_pid" > /dev/null 2>&1; then
            log ERROR "Script is already running (PID: $lock_pid)"
            exit $E_GENERAL
        else
            log WARN "Stale lock file found, removing..."
            rm -f "$LOCK_FILE"
        fi
    fi
    
    echo $PID > "$LOCK_FILE"
    log INFO "Acquired lock (PID: $PID)"
}

# Check dependencies
check_dependencies() {
    local missing_deps=()
    local deps=("curl" "jq" "awk")
    
    log INFO "Checking dependencies..."
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log ERROR "Missing dependencies: ${missing_deps[*]}"
        exit $E_DEPENDENCY
    fi
    
    log INFO "All dependencies satisfied"
}

# Validate input
validate_input() {
    local input=$1
    local pattern=$2
    
    if [[ ! $input =~ $pattern ]]; then
        log ERROR "Invalid input: $input (expected pattern: $pattern)"
        return 1
    fi
    
    return 0
}

# Retry function with exponential backoff
retry_with_backoff() {
    local max_attempts=$1
    shift
    local delay=$1
    shift
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        log INFO "Attempt $attempt/$max_attempts: $*"
        
        if "$@"; then
            log INFO "Command succeeded on attempt $attempt"
            return 0
        fi
        
        if [ $attempt -lt $max_attempts ]; then
            log WARN "Command failed, retrying in ${delay}s..."
            sleep $delay
            delay=$((delay * 2))  # Exponential backoff
        fi
        
        ((attempt++))
    done
    
    log ERROR "Command failed after $max_attempts attempts"
    return 1
}

# Demonstrate comprehensive error handling
demo_operations() {
    log INFO "Starting demo operations..."
    
    # Operation 1: Successful operation
    log INFO "Operation 1: Successful task"
    echo "Processing data..." > /dev/null
    log INFO "✓ Operation 1 completed"
    
    # Operation 2: Operation with retry
    log INFO "Operation 2: Task with retry logic"
    retry_with_backoff 3 2 echo "Simulated API call"
    log INFO "✓ Operation 2 completed"
    
    # Operation 3: Input validation
    log INFO "Operation 3: Input validation"
    if validate_input "user123" "^[a-z]+[0-9]+$"; then
        log INFO "✓ Input validation passed"
    fi
    
    log INFO "All operations completed successfully"
}

# Main function
main() {
    log INFO "=== $SCRIPT_NAME Started ==="
    log INFO "PID: $PID"
    log INFO "Log file: $LOG_FILE"
    
    # Initialize
    init_logging
    acquire_lock
    check_dependencies
    
    # Run operations
    demo_operations
    
    log INFO "=== $SCRIPT_NAME Completed ==="
    exit $E_SUCCESS
}

# Demo mode
demo() {
    echo "=== Comprehensive Error Handling Framework Demo ==="
    echo ""
    echo "Features demonstrated:"
    echo "✓ Multi-level logging (DEBUG, INFO, WARN, ERROR, FATAL)"
    echo "✓ Structured log format with timestamps and context"
    echo "✓ Separate error log file"
    echo "✓ Stack trace on errors"
    echo "✓ Lock file to prevent concurrent execution"
    echo "✓ Automatic cleanup on exit"
    echo "✓ Dependency checking"
    echo "✓ Retry logic with exponential backoff"
    echo "✓ Input validation"
    echo "✓ Comprehensive error codes"
    echo ""
    
    # Run main function in demo mode
    LOG_DIR="/tmp/demo_logs"
    LOG_FILE="$LOG_DIR/demo.log"
    ERROR_LOG="$LOG_DIR/demo_errors.log"
    LOCK_FILE="/tmp/demo.lock"
    
    main
}

# Run demo
demo

echo ""
echo "💡 Production Error Handling Best Practices:"
echo "   - Structured logging with levels"
echo "   - Stack traces for debugging"
echo "   - Lock files for singleton execution"
echo "   - Automatic cleanup on exit"
echo "   - Dependency validation"
echo "   - Retry logic with backoff"
echo "   - Comprehensive error codes"
echo "   - Separate error logging"
