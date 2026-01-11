#!/usr/bin/env bash

################################################################################
# Script: download_and_scan_logs.sh
# Description: Download logs from S3 and perform forensic analysis
# Author: AkilTipu
# Date: 2026-01-11
#
# Usage:
#   ./download_and_scan_logs.sh [OPTIONS]
#
# Examples:
#   ./download_and_scan_logs.sh --date 2026-01-10 --service auth-api
#   ./download_and_scan_logs.sh --date 2026-01-11 --service auth-api --bucket my-logs
#   ./download_and_scan_logs.sh --date 2026-01-10 --pattern "JWT expired"
#   ./download_and_scan_logs.sh -d 2026-01-11 -s payment-api -p prod
#   ./download_and_scan_logs.sh --date 2026-01-11 --service auth-api --bucket akiltipu-log-test-demo --pattern "JWT expired"
#
################################################################################

set -euo pipefail

# ============================================================================
# Configuration & Defaults
# ============================================================================

AWS_PROFILE="${AWS_PROFILE:-default}"
S3_BUCKET="${S3_BUCKET:-}"
SERVICE_NAME="${SERVICE_NAME:-api-service}"
TARGET_DATE=""
CUSTOM_PATTERN=""
DOWNLOAD_DIR="./downloaded_logs"
REPORT_DIR="./reports"
TEMP_DIR="./temp_logs"

# Default search patterns (label:pattern pairs)
SEARCH_PATTERNS=(
    "ERROR:ERROR"
    "WARN:WARN"
    "TIMEOUT:timeout|timed out|connection timeout"
    "5XX:50[0-9]|internal server error|service unavailable|gateway timeout"
)

# ============================================================================
# Functions
# ============================================================================

show_help() {
    cat << EOF
Usage: ${0##*/} [OPTIONS]

Download logs from S3 and perform forensic analysis.

OPTIONS:
    -h, --help              Show this help message
    -d, --date DATE         Target date for logs (YYYY-MM-DD) [REQUIRED]
    -s, --service NAME      Service name (default: api-service)
    -b, --bucket NAME       S3 bucket name (required if S3_BUCKET not set)
    -p, --profile NAME      AWS profile to use (default: default)
    --pattern REGEX         Custom regex pattern to search for
    
ENVIRONMENT VARIABLES:
    AWS_PROFILE            AWS CLI profile name
    S3_BUCKET              S3 bucket for log storage
    SERVICE_NAME           Service name identifier

EXAMPLES:
    ${0##*/} --date 2026-01-10 --service auth-api --bucket my-logs
    ${0##*/} -d 2026-01-11 -s payment-api --pattern "JWT expired"
    AWS_PROFILE=prod ${0##*/} --date 2026-01-10 --service user-service

SEARCH PATTERNS:
    - ERROR:     All error-level messages
    - WARN:      All warning messages  
    - TIMEOUT:   Connection and request timeouts
    - 5XX:       HTTP 5xx server errors
    - CUSTOM:    User-provided regex pattern

OUTPUT:
    Report saved to: ./reports/scan_report_YYYYMMDD_SERVICE.txt

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
    
    for cmd in aws gzip grep awk; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
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
    
    if [ -z "$TARGET_DATE" ]; then
        error "Target date is required. Use --date YYYY-MM-DD"
        show_help
        exit 1
    fi
    
    # Validate date format
    if ! [[ "$TARGET_DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        error "Invalid date format. Use YYYY-MM-DD"
        exit 1
    fi
    
    # Validate service name
    if ! [[ "$SERVICE_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        error "SERVICE_NAME contains invalid characters."
        exit 1
    fi
}

prepare_directories() {
    log "Preparing working directories..."
    mkdir -p "$DOWNLOAD_DIR" "$REPORT_DIR" "$TEMP_DIR"
}

cleanup_temp_files() {
    log "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
}

# Convert date format for S3 path
get_s3_date_path() {
    local date=$1
    # Convert YYYY-MM-DD to YYYY/MM/DD
    echo "$date" | sed 's/-/\//g'
}

download_logs_from_s3() {
    local s3_date_path=$(get_s3_date_path "$TARGET_DATE")
    local s3_prefix="s3://${S3_BUCKET}/logs/${SERVICE_NAME}/${s3_date_path}/"
    
    log "Downloading logs from: $s3_prefix"
    
    # Check if logs exist
    if ! aws s3 ls "$s3_prefix" --profile "$AWS_PROFILE" &> /dev/null; then
        error "No logs found at $s3_prefix"
        error "Please verify the date, service name, and bucket."
        exit 1
    fi
    
    # Download all log files for the date
    local download_count
    download_count=$(aws s3 ls "$s3_prefix" --profile "$AWS_PROFILE" | wc -l | tr -d ' ')
    
    if [ "$download_count" -eq 0 ]; then
        error "No log files found for $SERVICE_NAME on $TARGET_DATE"
        exit 1
    fi
    
    log "Found $download_count log file(s)"
    
    aws s3 sync "$s3_prefix" "$DOWNLOAD_DIR/" --profile "$AWS_PROFILE" --no-progress
    
    log "Download complete"
    echo "$download_count"
}

extract_compressed_logs() {
    log "Extracting compressed log files..."
    
    local extracted_count=0
    local file
    
    for file in "$DOWNLOAD_DIR"/*.gz; do
        if [ -f "$file" ]; then
            local basename=$(basename "$file" .gz)
            gunzip -c "$file" > "$TEMP_DIR/$basename"
            ((extracted_count++))
            log "Extracted: $basename"
        fi
    done
    
    if [ $extracted_count -eq 0 ]; then
        error "No compressed log files found to extract"
        exit 1
    fi
    
    log "Extracted $extracted_count file(s)"
    echo "$extracted_count"
}

# Search logs for a specific pattern
search_pattern() {
    local pattern=$1
    local label=$2
    local temp_file="$TEMP_DIR/matches_${label}.txt"
    
    # Case-insensitive grep across all extracted logs
    grep -iE "$pattern" "$TEMP_DIR"/*.log 2>/dev/null > "$temp_file" || true
    
    local count=$(wc -l < "$temp_file" | tr -d ' ')
    echo "$count"
}

# Analyze logs and generate report
analyze_logs() {
    local report_file="$REPORT_DIR/scan_report_${TARGET_DATE//-/}_${SERVICE_NAME}.txt"
    
    log "Analyzing logs for patterns..."
    
    {
        echo "=========================================="
        echo "LOG FORENSIC ANALYSIS REPORT"
        echo "=========================================="
        echo "Generated: $(date +'%Y-%m-%d %H:%M:%S %Z')"
        echo "Service:   $SERVICE_NAME"
        echo "Date:      $TARGET_DATE"
        echo "S3 Bucket: $S3_BUCKET"
        echo "Profile:   $AWS_PROFILE"
        echo ""
        
        # Count total log entries
        local total_lines=$(cat "$TEMP_DIR"/*.log | wc -l | tr -d ' ')
        echo "Total Log Entries: $total_lines"
        echo ""
        
        echo "=========================================="
        echo "PATTERN ANALYSIS"
        echo "=========================================="
        
        # Search for each predefined pattern
        local pattern_entry
        for pattern_entry in "${SEARCH_PATTERNS[@]}"; do
            local pattern_name="${pattern_entry%%:*}"
            local pattern="${pattern_entry#*:}"
            local count=$(search_pattern "$pattern" "$pattern_name")
            printf "%-15s : %6d occurrences\n" "$pattern_name" "$count"
        done
        
        # Search for custom pattern if provided
        if [ -n "$CUSTOM_PATTERN" ]; then
            echo ""
            local custom_count=$(search_pattern "$CUSTOM_PATTERN" "CUSTOM")
            printf "%-15s : %6d occurrences\n" "CUSTOM PATTERN" "$custom_count"
            echo "Custom Regex: $CUSTOM_PATTERN"
        fi
        
        echo ""
        echo "=========================================="
        echo "TOP 10 MOST FREQUENT ERROR MESSAGES"
        echo "=========================================="
        
        # Extract and count unique error messages
        grep -iE "ERROR|FATAL" "$TEMP_DIR"/*.log 2>/dev/null | \
            awk -F'|' '{print $NF}' | \
            sed 's/^ *//g' | \
            sort | uniq -c | sort -rn | head -10 | \
            awk '{$1=$1; printf "%5d  %s\n", $1, substr($0, index($0,$2))}' || echo "No errors found"
        
        echo ""
        echo "=========================================="
        echo "TOP 10 MOST FREQUENT WARNING MESSAGES"
        echo "=========================================="
        
        grep -iE "WARN" "$TEMP_DIR"/*.log 2>/dev/null | \
            awk -F'|' '{print $NF}' | \
            sed 's/^ *//g' | \
            sort | uniq -c | sort -rn | head -10 | \
            awk '{$1=$1; printf "%5d  %s\n", $1, substr($0, index($0,$2))}' || echo "No warnings found"
        
        echo ""
        echo "=========================================="
        echo "ERROR TIMELINE (Hourly Distribution)"
        echo "=========================================="
        
        grep -iE "ERROR|FATAL" "$TEMP_DIR"/*.log 2>/dev/null | \
            awk -F'|' '{print $1}' | \
            awk -F'T' '{print $2}' | \
            awk -F':' '{print $1":00"}' | \
            sort | uniq -c | \
            awk '{printf "%5d errors at hour %s\n", $1, $2}' || echo "No errors found"
        
        echo ""
        echo "=========================================="
        echo "LOG LEVEL DISTRIBUTION"
        echo "=========================================="
        
        for level in DEBUG INFO WARN ERROR FATAL; do
            local level_count=$(grep -c "|[[:space:]]*${level}[[:space:]]*|" "$TEMP_DIR"/*.log 2>/dev/null || echo 0)
            local percentage=0
            if [ "$total_lines" -gt 0 ]; then
                percentage=$((level_count * 100 / total_lines))
            fi
            printf "%-10s : %6d (%3d%%)\n" "$level" "$level_count" "$percentage"
        done
        
        echo ""
        echo "=========================================="
        echo "UNIQUE ERROR TYPES"
        echo "=========================================="
        
        grep -iE "ERROR|FATAL" "$TEMP_DIR"/*.log 2>/dev/null | \
            awk -F'|' '{print $NF}' | \
            sed 's/ | request_id=.*//g' | \
            sed 's/^ *//g' | \
            sort -u | head -20 || echo "No errors found"
        
        echo ""
        echo "=========================================="
        echo "SUSPICIOUS PATTERNS"
        echo "=========================================="
        
        echo "Authentication Failures:"
        grep -ic "authentication\|auth.*fail\|unauthorized" "$TEMP_DIR"/*.log 2>/dev/null || echo "0"
        
        echo "Rate Limiting:"
        grep -ic "rate limit\|too many requests\|429" "$TEMP_DIR"/*.log 2>/dev/null || echo "0"
        
        echo "Database Issues:"
        grep -ic "database.*error\|connection.*timeout\|deadlock" "$TEMP_DIR"/*.log 2>/dev/null || echo "0"
        
        echo "Memory Issues:"
        grep -ic "out of memory\|memory.*exceeded\|oom" "$TEMP_DIR"/*.log 2>/dev/null || echo "0"
        
        echo ""
        echo "=========================================="
        echo "END OF REPORT"
        echo "=========================================="
        
    } > "$report_file"
    
    log "Report generated: $report_file"
    echo "$report_file"
}

display_report_summary() {
    local report_file=$1
    
    echo ""
    echo "=========================================="
    echo "✓ Log Analysis Complete"
    echo "=========================================="
    
    # Extract key metrics from report
    local total_lines=$(grep "^Total Log Entries:" "$report_file" | awk '{print $4}')
    local error_count=$(grep "^ERROR" "$report_file" | head -1 | awk '{print $3}')
    local warn_count=$(grep "^WARN" "$report_file" | head -1 | awk '{print $3}')
    
    echo "Service:        $SERVICE_NAME"
    echo "Date:           $TARGET_DATE"
    echo "Total Entries:  $total_lines"
    echo "Errors:         $error_count"
    echo "Warnings:       $warn_count"
    echo ""
    echo "Full Report:    $report_file"
    echo "=========================================="
}

# ============================================================================
# Main Execution
# ============================================================================

main() {
    log "Starting log download and analysis"
    log "Target: $SERVICE_NAME on $TARGET_DATE"
    
    # Prepare directories
    prepare_directories
    
    # Download logs from S3
    local download_count
    download_count=$(download_logs_from_s3)
    
    # Extract compressed logs
    local extract_count
    extract_count=$(extract_compressed_logs)
    
    # Analyze logs and generate report
    local report_file
    report_file=$(analyze_logs)
    
    # Display summary
    display_report_summary "$report_file"
    
    # Cleanup
    cleanup_temp_files
    
    log "Process completed successfully"
    
    # Offer to display the report
    echo ""
    echo "View the full report with:"
    echo "  cat $report_file"
    echo "  less $report_file"
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
        -d|--date)
            TARGET_DATE="$2"
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
        --pattern)
            CUSTOM_PATTERN="$2"
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
