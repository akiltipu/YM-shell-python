#!/usr/bin/env bash

################################################################################
# Script: generate_and_upload_logs.sh
# Description: Generate realistic application logs and upload to AWS S3
# Author: AkilTipu
# Date: 2026-01-11
#
# Usage:
#   ./generate_and_upload_logs.sh [OPTIONS]
#
# Examples:
#   ./generate_and_upload_logs.sh --count 1000 --service auth-api
#   ./generate_and_upload_logs.sh --bucket my-logs --profile production
#   AWS_PROFILE=dev S3_BUCKET=dev-logs ./generate_and_upload_logs.sh
#
################################################################################

set -euo pipefail

# ============================================================================
# Configuration & Defaults
# ============================================================================

AWS_PROFILE="${AWS_PROFILE:-default}"
S3_BUCKET="${S3_BUCKET:-}"
SERVICE_NAME="${SERVICE_NAME:-api-service}"
LOG_COUNT="${LOG_COUNT:-500}"
LOG_DIR="./logs"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
S3_DATE_PATH=$(date +%Y/%m/%d)

# Log levels and messages for realistic simulation
LOG_LEVELS=("INFO" "DEBUG" "WARN" "ERROR" "FATAL")
LOG_LEVEL_WEIGHTS=(60 25 10 4 1)  # Probability weights

SAMPLE_MESSAGES=(
    "Request processed successfully"
    "User authentication completed"
    "Database query executed"
    "Cache hit for key"
    "API endpoint called"
    "Session created"
    "Token validated"
    "Configuration loaded"
    "Health check passed"
    "Metrics published"
)

ERROR_MESSAGES=(
    "Database connection timeout"
    "Failed to authenticate user"
    "JWT token expired"
    "Rate limit exceeded"
    "Invalid request payload"
    "Service unavailable - 503"
    "Internal server error - 500"
    "Gateway timeout - 504"
    "Permission denied"
    "Resource not found - 404"
)

WARN_MESSAGES=(
    "High memory usage detected"
    "Slow query execution time"
    "Deprecated API endpoint used"
    "Cache miss - fallback to database"
    "Retry attempt"
    "Connection pool near capacity"
    "Response time above threshold"
)

# ============================================================================
# Functions
# ============================================================================

show_help() {
    cat << EOF
Usage: ${0##*/} [OPTIONS]

Generate realistic application logs and upload to AWS S3.

OPTIONS:
    -h, --help              Show this help message
    -c, --count NUM         Number of log entries to generate (default: 500)
    -s, --service NAME      Service name for logs (default: api-service)
    -b, --bucket NAME       S3 bucket name (required if S3_BUCKET not set)
    -p, --profile NAME      AWS profile to use (default: default)
    
ENVIRONMENT VARIABLES:
    AWS_PROFILE            AWS CLI profile name
    S3_BUCKET              S3 bucket for log storage
    SERVICE_NAME           Service name identifier
    LOG_COUNT              Number of log entries

EXAMPLES:
    ${0##*/} --count 1000 --service auth-api --bucket my-logs
    AWS_PROFILE=prod ${0##*/} --service payment-api
    ${0##*/} -c 2000 -s user-service -b production-logs -p prod

S3 UPLOAD PATH:
    s3://BUCKET/logs/SERVICE/YYYY/MM/DD/SERVICE_TIMESTAMP.log.gz

EOF
}

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" >&2
}

check_dependencies() {
    local missing_deps=()
    
    if ! command -v aws &> /dev/null; then
        missing_deps+=("aws-cli")
    fi
    
    if ! command -v gzip &> /dev/null; then
        missing_deps+=("gzip")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        error "Missing required dependencies: ${missing_deps[*]}"
        error "Please install them before running this script."
        exit 1
    fi
}

validate_inputs() {
    if [ -z "$S3_BUCKET" ]; then
        error "S3 bucket name is required. Use --bucket or set S3_BUCKET environment variable."
        show_help
        exit 1
    fi
    
    if ! [[ "$LOG_COUNT" =~ ^[0-9]+$ ]] || [ "$LOG_COUNT" -lt 1 ]; then
        error "LOG_COUNT must be a positive integer."
        exit 1
    fi
    
    if ! [[ "$SERVICE_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        error "SERVICE_NAME contains invalid characters. Use alphanumeric, dash, or underscore."
        exit 1
    fi
}

# Select a weighted random log level
get_random_log_level() {
    local total_weight=0
    local i
    
    for weight in "${LOG_LEVEL_WEIGHTS[@]}"; do
        ((total_weight += weight))
    done
    
    local random=$((RANDOM % total_weight))
    local current_weight=0
    
    for i in "${!LOG_LEVELS[@]}"; do
        ((current_weight += LOG_LEVEL_WEIGHTS[i]))
        if [ $random -lt $current_weight ]; then
            echo "${LOG_LEVELS[$i]}"
            return
        fi
    done
    
    echo "INFO"
}

# Generate a random log message based on level
get_random_message() {
    local level=$1
    local message
    
    case "$level" in
        ERROR|FATAL)
            message="${ERROR_MESSAGES[$((RANDOM % ${#ERROR_MESSAGES[@]}))]}"
            ;;
        WARN)
            message="${WARN_MESSAGES[$((RANDOM % ${#WARN_MESSAGES[@]}))]}"
            ;;
        *)
            message="${SAMPLE_MESSAGES[$((RANDOM % ${#SAMPLE_MESSAGES[@]}))]}"
            ;;
    esac
    
    # Add random request IDs and user IDs for realism
    local request_id="req_$(openssl rand -hex 8 2>/dev/null || echo "${RANDOM}${RANDOM}")"
    local user_id="user_$((RANDOM % 10000))"
    
    echo "$message | request_id=$request_id user_id=$user_id"
}

generate_logs() {
    local log_file="$LOG_DIR/${SERVICE_NAME}_${TIMESTAMP}.log"
    local count=$LOG_COUNT
    
    log "Generating $count log entries for service: $SERVICE_NAME"
    
    mkdir -p "$LOG_DIR"
    
    local i
    for ((i=1; i<=count; i++)); do
        local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ" 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%SZ")
        local level=$(get_random_log_level)
        local message=$(get_random_message "$level")
        
        # Structured log format: ISO8601 timestamp | service | level | message
        echo "$timestamp | $SERVICE_NAME | $level | $message" >> "$log_file"
        
        # Show progress every 100 entries
        if [ $((i % 100)) -eq 0 ]; then
            printf "\rProgress: %d/%d entries generated" "$i" "$count" >&2
        fi
    done
    
    printf "\rProgress: %d/%d entries generated\n" "$count" "$count" >&2
    
    log "Log file created: $log_file"
    echo "$log_file"
}

compress_logs() {
    local log_file=$1
    local compressed_file="${log_file}.gz"
    
    log "Compressing log file..."
    
    if gzip -f "$log_file"; then
        log "Compressed: $compressed_file"
        local original_size=$(wc -c < "$log_file" 2>/dev/null || echo "N/A")
        local compressed_size=$(wc -c < "$compressed_file")
        
        if [ "$original_size" != "N/A" ]; then
            local ratio=$((100 - (compressed_size * 100 / original_size)))
            log "Compression ratio: ${ratio}%"
        fi
        
        echo "$compressed_file"
    else
        error "Failed to compress log file"
        exit 1
    fi
}

upload_to_s3() {
    local file=$1
    local s3_path="s3://${S3_BUCKET}/logs/${SERVICE_NAME}/${S3_DATE_PATH}/$(basename "$file")"
    
    log "Uploading to S3: $s3_path"
    
    if aws s3 cp "$file" "$s3_path" --profile "$AWS_PROFILE" --no-progress; then
        log "Upload successful"
        echo "$s3_path"
    else
        error "Failed to upload to S3"
        exit 1
    fi
}

# ============================================================================
# Main Execution
# ============================================================================

main() {
    log "Starting log generation and upload process"
    log "Service: $SERVICE_NAME | Count: $LOG_COUNT | Bucket: $S3_BUCKET"
    
    # Generate logs
    local log_file
    log_file=$(generate_logs)
    
    # Compress logs
    local compressed_file
    compressed_file=$(compress_logs "$log_file")
    
    # Upload to S3
    local s3_location
    s3_location=$(upload_to_s3 "$compressed_file")
    
    # Summary
    echo ""
    echo "=========================================="
    echo "✓ Log Generation & Upload Complete"
    echo "=========================================="
    echo "Service:        $SERVICE_NAME"
    echo "Log Entries:    $LOG_COUNT"
    echo "Local File:     $compressed_file"
    echo "S3 Location:    $s3_location"
    echo "File Size:      $(du -h "$compressed_file" | cut -f1)"
    echo "AWS Profile:    $AWS_PROFILE"
    echo "=========================================="
    
    log "Process completed successfully"
}

# ============================================================================
# Parse Arguments
# ============================================================================

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -c|--count)
            LOG_COUNT="$2"
            shift 2
            ;;
        -s|--service)
            SERVICE_NAME="$2"
            shift 2
            ;;
        -b|--bucket)
            S3_BUCKET="$2"
            shift 2
            ;;
        -p|--profile)
            AWS_PROFILE="$2"
            shift 2
            ;;
        *)
            error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# ============================================================================
# Pre-flight Checks & Execution
# ============================================================================

check_dependencies
validate_inputs
main

exit 0
