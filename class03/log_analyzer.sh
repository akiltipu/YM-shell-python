#!/bin/bash
# Log Analyzer with Regex and Error Handling

set -euo pipefail

# Configuration
DEFAULT_LOG_FILE="/var/log/syslog"
OUTPUT_FILE="analysis_$(date +%Y%m%d_%H%M%S).txt"

# Usage
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Analyze log files for errors, warnings, and patterns.

OPTIONS:
    -f, --file FILE        Log file to analyze (default: $DEFAULT_LOG_FILE)
    -p, --pattern PATTERN  Custom regex pattern to search
    -o, --output FILE      Output file (default: $OUTPUT_FILE)
    -t, --time HOURS       Analyze logs from last N hours
    -h, --help             Show this help

EXAMPLES:
    $(basename "$0") -f app.log
    $(basename "$0") -f app.log -p "database.*error"
    $(basename "$0") -f app.log -t 24

EOF
    exit 0
}

# Parse arguments
log_file="$DEFAULT_LOG_FILE"
custom_pattern=""
output_file="$OUTPUT_FILE"
time_filter=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            log_file="$2"
            shift 2
            ;;
        -p|--pattern)
            custom_pattern="$2"
            shift 2
            ;;
        -o|--output)
            output_file="$2"
            shift 2
            ;;
        -t|--time)
            time_filter="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Create sample log if needed (for testing)
if [ ! -f "$log_file" ]; then
    echo "Log file not found: $log_file"
    echo "Creating sample log for demonstration..."
    log_file="sample_app.log"
    
    cat > "$log_file" << 'EOF'
2025-12-01 08:15:23 INFO Application started successfully
2025-12-01 08:16:45 ERROR Database connection timeout at 192.168.1.100:5432
2025-12-01 08:17:12 WARN Memory usage high: 85% used
2025-12-01 08:18:33 ERROR Failed authentication attempt from user: admin
2025-12-01 08:19:01 INFO User logged in: john@example.com
2025-12-01 08:20:15 ERROR Disk space critical: only 5% remaining
2025-12-01 08:21:44 WARN API response time exceeded 2s
2025-12-01 08:22:56 INFO Backup completed successfully
2025-12-01 08:23:12 ERROR Failed to send notification to admin@company.com
2025-12-01 08:24:30 CRITICAL System overload: CPU at 98%
EOF
    echo "Sample log created: $log_file"
fi

# Start analysis
echo "=======================================" | tee "$output_file"
echo "       LOG ANALYSIS REPORT" | tee -a "$output_file"
echo "=======================================" | tee -a "$output_file"
echo "File: $log_file" | tee -a "$output_file"
echo "Date: $(date)" | tee -a "$output_file"
echo "=======================================" | tee -a "$output_file"
echo "" | tee -a "$output_file"

# Count total lines
total_lines=$(wc -l < "$log_file")
echo "Total log entries: $total_lines" | tee -a "$output_file"
echo "" | tee -a "$output_file"

# Count by severity
echo "=== Severity Breakdown ===" | tee -a "$output_file"
error_count=$(grep -c "ERROR" "$log_file" || true)
warn_count=$(grep -c "WARN" "$log_file" || true)
info_count=$(grep -c "INFO" "$log_file" || true)
critical_count=$(grep -c "CRITICAL" "$log_file" || true)

echo "CRITICAL: $critical_count" | tee -a "$output_file"
echo "ERROR:    $error_count" | tee -a "$output_file"
echo "WARN:     $warn_count" | tee -a "$output_file"
echo "INFO:     $info_count" | tee -a "$output_file"
echo "" | tee -a "$output_file"

# Extract error messages
if [ "$error_count" -gt 0 ]; then
    echo "=== Error Messages ===" | tee -a "$output_file"
    grep "ERROR" "$log_file" | tee -a "$output_file"
    echo "" | tee -a "$output_file"
fi

# Extract critical messages
if [ "$critical_count" -gt 0 ]; then
    echo "=== Critical Messages ===" | tee -a "$output_file"
    grep "CRITICAL" "$log_file" | tee -a "$output_file"
    echo "" | tee -a "$output_file"
fi

# Extract IP addresses
echo "=== IP Addresses Found ===" | tee -a "$output_file"
ip_pattern='([0-9]{1,3}\.){3}[0-9]{1,3}'
grep -oE "$ip_pattern" "$log_file" | sort -u | tee -a "$output_file"
echo "" | tee -a "$output_file"

# Extract email addresses
echo "=== Email Addresses Found ===" | tee -a "$output_file"
email_pattern='[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
grep -oE "$email_pattern" "$log_file" | sort -u | tee -a "$output_file"
echo "" | tee -a "$output_file"

# Custom pattern search
if [ -n "$custom_pattern" ]; then
    echo "=== Custom Pattern Results ===" | tee -a "$output_file"
    echo "Pattern: $custom_pattern" | tee -a "$output_file"
    grep -iE "$custom_pattern" "$log_file" | tee -a "$output_file" || echo "No matches found"
    echo "" | tee -a "$output_file"
fi

# Summary
echo "=======================================" | tee -a "$output_file"
echo "Analysis complete!" | tee -a "$output_file"
echo "Report saved to: $output_file" | tee -a "$output_file"
echo "=======================================" | tee -a "$output_file"
