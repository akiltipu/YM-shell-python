#!/bin/bash
# Logging System Demonstration

# Log file setup
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app_$(date +%Y%m%d).log"
mkdir -p "$LOG_DIR"

# Log levels
LOG_LEVEL_DEBUG=0
LOG_LEVEL_INFO=1
LOG_LEVEL_WARN=2
LOG_LEVEL_ERROR=3
LOG_LEVEL_FATAL=4

# Current log level (set to INFO by default)
CURRENT_LOG_LEVEL=${LOG_LEVEL:-$LOG_LEVEL_INFO}

# Color codes
COLOR_RESET='\033[0m'
COLOR_DEBUG='\033[0;36m'    # Cyan
COLOR_INFO='\033[0;32m'     # Green
COLOR_WARN='\033[0;33m'     # Yellow
COLOR_ERROR='\033[0;31m'    # Red
COLOR_FATAL='\033[1;31m'    # Bold Red

# Logging functions
log() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local color=$COLOR_RESET
    
    # Determine color and level name
    case $level in
        $LOG_LEVEL_DEBUG)
            level_name="DEBUG"
            color=$COLOR_DEBUG
            ;;
        $LOG_LEVEL_INFO)
            level_name="INFO "
            color=$COLOR_INFO
            ;;
        $LOG_LEVEL_WARN)
            level_name="WARN "
            color=$COLOR_WARN
            ;;
        $LOG_LEVEL_ERROR)
            level_name="ERROR"
            color=$COLOR_ERROR
            ;;
        $LOG_LEVEL_FATAL)
            level_name="FATAL"
            color=$COLOR_FATAL
            ;;
    esac
    
    # Only log if level is high enough
    if [ $level -ge $CURRENT_LOG_LEVEL ]; then
        # Console output (with color)
        echo -e "${color}[$timestamp] [$level_name] $message${COLOR_RESET}"
        
        # File output (no color)
        echo "[$timestamp] [$level_name] $message" >> "$LOG_FILE"
    fi
    
    # Exit on fatal
    if [ $level -eq $LOG_LEVEL_FATAL ]; then
        exit 1
    fi
}

# Convenience functions
log_debug() { log $LOG_LEVEL_DEBUG "$@"; }
log_info() { log $LOG_LEVEL_INFO "$@"; }
log_warn() { log $LOG_LEVEL_WARN "$@"; }
log_error() { log $LOG_LEVEL_ERROR "$@"; }
log_fatal() { log $LOG_LEVEL_FATAL "$@"; }

# Demo usage
echo "======================================="
echo "       LOGGING SYSTEM DEMO"
echo "======================================="
echo "Log file: $LOG_FILE"
echo ""

log_info "Application starting..."
log_debug "Debug mode enabled"
log_info "Loading configuration..."

# Simulate some operations
operations=("Initialize" "Connect to database" "Load modules" "Start services")
for op in "${operations[@]}"; do
    log_info "$op..."
    sleep 0.5
done

log_warn "Memory usage is high: 78%"
log_info "Performing health check..."

# Simulate an error scenario
if [ $((RANDOM % 2)) -eq 0 ]; then
    log_error "Failed to connect to external API"
    log_info "Retrying with backup server..."
else
    log_info "All systems operational"
fi

log_info "Application startup complete"

echo ""
echo "Check the log file: $LOG_FILE"
