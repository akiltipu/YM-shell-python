#!/bin/bash
#
# Practical Function Usage for DevOps
# Real-world function library for automation tasks
#

set -euo pipefail

#==========================================
# GLOBAL CONFIGURATION
#==========================================

readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="/tmp/devops_functions_$(date +%Y%m%d).log"

#==========================================
# LOGGING FUNCTIONS
#==========================================

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
# VALIDATION FUNCTIONS
#==========================================

validate_not_empty() {
    local value=$1
    local field_name=$2
    
    if [ -z "$value" ]; then
        log_error "$field_name cannot be empty"
        return 1
    fi
    
    log_debug "Validation passed: $field_name is not empty"
    return 0
}

validate_number() {
    local value=$1
    local field_name=${2:-"Value"}
    
    if ! [[ $value =~ ^[0-9]+$ ]]; then
        log_error "$field_name must be a number (got: $value)"
        return 1
    fi
    
    log_debug "Validation passed: $field_name is a number"
    return 0
}

validate_ip_address() {
    local ip=$1
    
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        # Validate each octet
        IFS='.' read -ra OCTETS <<< "$ip"
        for octet in "${OCTETS[@]}"; do
            if [ "$octet" -gt 255 ]; then
                log_error "Invalid IP address: $ip (octet > 255)"
                return 1
            fi
        done
        log_debug "Validation passed: $ip is a valid IP address"
        return 0
    else
        log_error "Invalid IP address format: $ip"
        return 1
    fi
}

validate_email() {
    local email=$1
    
    if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        log_debug "Validation passed: $email is a valid email"
        return 0
    else
        log_error "Invalid email format: $email"
        return 1
    fi
}

validate_port() {
    local port=$1
    
    if ! validate_number "$port" "Port"; then
        return 1
    fi
    
    if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        log_error "Port must be between 1-65535 (got: $port)"
        return 1
    fi
    
    log_debug "Validation passed: Port $port is valid"
    return 0
}

#==========================================
# SYSTEM INFORMATION FUNCTIONS
#==========================================

get_os_type() {
    uname -s
}

get_hostname() {
    hostname
}

get_cpu_count() {
    if command -v nproc &> /dev/null; then
        nproc
    elif [ -f /proc/cpuinfo ]; then
        grep -c ^processor /proc/cpuinfo
    else
        echo "1"
    fi
}

get_memory_total() {
    if command -v free &> /dev/null; then
        free -h | awk '/^Mem:/ {print $2}'
    else
        echo "N/A"
    fi
}

get_memory_usage_percent() {
    if command -v free &> /dev/null; then
        free | awk '/^Mem:/ {printf("%.0f", $3/$2 * 100)}'
    else
        echo "0"
    fi
}

get_disk_usage() {
    local path=${1:-/}
    df -h "$path" | awk 'NR==2 {print $5}' | sed 's/%//'
}

get_uptime() {
    if command -v uptime &> /dev/null; then
        uptime -p 2>/dev/null || uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}'
    else
        echo "N/A"
    fi
}

display_system_info() {
    log_info "System Information:"
    echo "  OS: $(get_os_type)"
    echo "  Hostname: $(get_hostname)"
    echo "  CPU Cores: $(get_cpu_count)"
    echo "  Total Memory: $(get_memory_total)"
    echo "  Memory Usage: $(get_memory_usage_percent)%"
    echo "  Disk Usage (/): $(get_disk_usage)%"
    echo "  Uptime: $(get_uptime)"
}

#==========================================
# FILE OPERATION FUNCTIONS
#==========================================

backup_file() {
    local source_file=$1
    local backup_dir=${2:-./backups}
    
    if [ ! -f "$source_file" ]; then
        log_error "Source file not found: $source_file"
        return 1
    fi
    
    # Create backup directory
    mkdir -p "$backup_dir" || {
        log_error "Failed to create backup directory: $backup_dir"
        return 1
    }
    
    # Generate backup filename
    local filename=$(basename "$source_file")
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="${backup_dir}/${filename}.${timestamp}.bak"
    
    # Perform backup
    if cp "$source_file" "$backup_file"; then
        log_success "Backed up: $source_file -> $backup_file"
        echo "$backup_file"
        return 0
    else
        log_error "Failed to backup: $source_file"
        return 1
    fi
}

rotate_file() {
    local file=$1
    local max_rotations=${2:-5}
    
    if [ ! -f "$file" ]; then
        log_warn "File not found for rotation: $file"
        return 1
    fi
    
    log_info "Rotating file: $file (keeping $max_rotations versions)"
    
    # Remove oldest rotation if max reached
    local oldest="${file}.${max_rotations}"
    if [ -f "$oldest" ]; then
        rm "$oldest"
        log_debug "Removed oldest rotation: $oldest"
    fi
    
    # Shift existing rotations
    for ((i=max_rotations-1; i>=1; i--)); do
        local current="${file}.${i}"
        local next="${file}.$((i+1))"
        
        if [ -f "$current" ]; then
            mv "$current" "$next"
            log_debug "Rotated: $current -> $next"
        fi
    done
    
    # Rotate current file
    mv "$file" "${file}.1"
    touch "$file"
    
    log_success "File rotation completed"
    return 0
}

cleanup_old_files() {
    local directory=$1
    local pattern=$2
    local days_old=${3:-7}
    
    if [ ! -d "$directory" ]; then
        log_error "Directory not found: $directory"
        return 1
    fi
    
    log_info "Cleaning up files older than $days_old days in: $directory"
    log_info "Pattern: $pattern"
    
    local count=0
    while IFS= read -r -d '' file; do
        log_debug "Removing: $file"
        rm "$file"
        ((count++))
    done < <(find "$directory" -name "$pattern" -type f -mtime "+$days_old" -print0)
    
    log_success "Removed $count old file(s)"
    return 0
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
# DEPLOYMENT FUNCTIONS
#==========================================

check_prerequisites() {
    local -a required_commands=("$@")
    local missing=()
    
    log_info "Checking prerequisites..."
    
    for cmd in "${required_commands[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            log_debug "  ✓ $cmd: found"
        else
            log_warn "  ✗ $cmd: not found"
            missing+=("$cmd")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing required commands: ${missing[*]}"
        return 1
    fi
    
    log_success "All prerequisites satisfied"
    return 0
}

download_file() {
    local url=$1
    local destination=$2
    local max_retries=${3:-3}
    local attempt=1
    
    while [ $attempt -le $max_retries ]; do
        log_info "Downloading (attempt $attempt/$max_retries)..."
        log_debug "  URL: $url"
        log_debug "  Destination: $destination"
        
        if command -v curl &> /dev/null; then
            if curl -fsSL -o "$destination" "$url"; then
                log_success "Download completed"
                return 0
            fi
        elif command -v wget &> /dev/null; then
            if wget -q -O "$destination" "$url"; then
                log_success "Download completed"
                return 0
            fi
        else
            log_error "Neither curl nor wget available"
            return 1
        fi
        
        log_warn "Download failed"
        
        if [ $attempt -lt $max_retries ]; then
            local wait_time=$((attempt * 2))
            log_info "Waiting ${wait_time}s before retry..."
            sleep $wait_time
        fi
        
        ((attempt++))
    done
    
    log_error "Download failed after $max_retries attempts"
    return 1
}

verify_checksum() {
    local file=$1
    local expected_checksum=$2
    local algorithm=${3:-sha256}
    
    if [ ! -f "$file" ]; then
        log_error "File not found: $file"
        return 1
    fi
    
    log_info "Verifying checksum ($algorithm)..."
    
    local actual_checksum
    case $algorithm in
        md5)
            actual_checksum=$(md5sum "$file" 2>/dev/null | awk '{print $1}')
            ;;
        sha256)
            actual_checksum=$(sha256sum "$file" 2>/dev/null | awk '{print $1}')
            ;;
        sha512)
            actual_checksum=$(sha512sum "$file" 2>/dev/null | awk '{print $1}')
            ;;
        *)
            log_error "Unsupported algorithm: $algorithm"
            return 1
            ;;
    esac
    
    if [ "$actual_checksum" = "$expected_checksum" ]; then
        log_success "Checksum verified"
        return 0
    else
        log_error "Checksum mismatch!"
        log_error "  Expected: $expected_checksum"
        log_error "  Actual:   $actual_checksum"
        return 1
    fi
}

#==========================================
# HEALTH CHECK FUNCTIONS
#==========================================

check_service_health() {
    local service_name=$1
    local health_url=$2
    local expected_status=${3:-200}
    
    log_info "Checking health: $service_name"
    
    if ! command -v curl &> /dev/null; then
        log_warn "curl not available, skipping health check"
        return 1
    fi
    
    local http_code=$(curl -s -o /dev/null -w "%{http_code}" "$health_url" 2>/dev/null)
    
    if [ "$http_code" = "$expected_status" ]; then
        log_success "$service_name is healthy (HTTP $http_code)"
        return 0
    else
        log_error "$service_name is unhealthy (HTTP $http_code, expected $expected_status)"
        return 1
    fi
}

monitor_metrics() {
    local service_name=$1
    local duration=${2:-30}
    local interval=${3:-5}
    local elapsed=0
    
    log_info "Monitoring $service_name for ${duration}s (interval: ${interval}s)"
    
    while [ $elapsed -lt $duration ]; do
        local cpu=$(get_memory_usage_percent)
        local memory=$(get_memory_usage_percent)
        local disk=$(get_disk_usage)
        
        log_info "[$elapsed s] CPU: ${cpu}% | Memory: ${memory}% | Disk: ${disk}%"
        
        # Alert on high usage
        if [ "$cpu" -gt 90 ] || [ "$memory" -gt 90 ] || [ "$disk" -gt 90 ]; then
            log_warn "High resource usage detected!"
        fi
        
        sleep $interval
        ((elapsed+=interval))
    done
    
    log_info "Monitoring completed"
}

#==========================================
# NOTIFICATION FUNCTIONS
#==========================================

send_notification() {
    local level=$1
    local title=$2
    local message=$3
    
    log_message "$level" "NOTIFICATION: $title - $message"
    
    # Here you would integrate with:
    # - Slack webhook
    # - Email
    # - PagerDuty
    # - Microsoft Teams
    # etc.
}

notify_success() {
    send_notification "SUCCESS" "$1" "${2:-}"
}

notify_failure() {
    send_notification "ERROR" "$1" "${2:-}"
}

notify_warning() {
    send_notification "WARN" "$1" "${2:-}"
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
# DEMO / TEST FUNCTIONS
#==========================================

demo_validation() {
    echo "======================================="
    echo "  Demo: Validation Functions"
    echo "======================================="
    echo ""
    
    validate_not_empty "test_value" "TestField" && echo "✓ Test 1 passed"
    validate_number "12345" "Age" && echo "✓ Test 2 passed"
    validate_ip_address "192.168.1.1" && echo "✓ Test 3 passed"
    validate_email "user@example.com" && echo "✓ Test 4 passed"
    validate_port "8080" && echo "✓ Test 5 passed"
    
    echo ""
}

demo_system_info() {
    echo "======================================="
    echo "  Demo: System Information"
    echo "======================================="
    echo ""
    
    display_system_info
    
    echo ""
}

demo_file_operations() {
    echo "======================================="
    echo "  Demo: File Operations"
    echo "======================================="
    echo ""
    
    # Create test file
    echo "Test content" > /tmp/test_file.txt
    
    # Backup
    backup_file "/tmp/test_file.txt" "/tmp/backups"
    
    # Cleanup
    rm -rf /tmp/test_file.txt /tmp/backups
    
    echo ""
}

demo_health_checks() {
    echo "======================================="
    echo "  Demo: Health Checks"
    echo "======================================="
    echo ""
    
    check_prerequisites "bash" "awk" "sed" "grep"
    
    echo ""
}

#==========================================
# MAIN FUNCTION
#==========================================

main() {
    log_info "========================================="
    log_info "  DevOps Function Library Demo"
    log_info "========================================="
    echo ""
    
    demo_validation
    demo_system_info
    demo_file_operations
    demo_health_checks
    
    log_success "All demos completed!"
    log_info "Log file: $LOG_FILE"
}

#==========================================
# SCRIPT EXECUTION
#==========================================

# If script is executed directly (not sourced)
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
else
    log_info "DevOps function library loaded and ready"
fi
