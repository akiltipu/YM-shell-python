#!/bin/bash

# Practical Example: Log Analyzer
# Demonstrates: File arguments, date range parsing, filtering options

set -euo pipefail

LOG_FILE=""
START_DATE=""
END_DATE=""
LEVEL=""
PATTERN=""
OUTPUT_FORMAT="text"
LIMIT=0
FOLLOW=false

usage() {
    cat << 'EOF'
Log Analyzer - Parse and analyze application logs

Usage: ./06-practical_arguments_log_analyzer.sh -f FILE [OPTIONS]

Required:
    -f, --file FILE         Log file to analyze

Filtering Options:
    --start DATE            Start date (YYYY-MM-DD or "2h ago", "1d ago")
    --end DATE              End date (YYYY-MM-DD)
    -l, --level LEVEL       Log level: ERROR, WARN, INFO, DEBUG
    -p, --pattern PATTERN   Filter by pattern (grep style)
    --limit N               Limit output to N lines

Output Options:
    -o, --output FORMAT     Output format: text, json, csv (default: text)
    --follow                Follow log file (like tail -f)

Examples:
    # Analyze error logs
    ./06-practical_arguments_log_analyzer.sh -f app.log --level ERROR

    # Logs from last 2 hours
    ./06-practical_arguments_log_analyzer.sh -f app.log --start "2h ago"

    # Export to JSON
    ./06-practical_arguments_log_analyzer.sh -f app.log -o json --limit 100

    # Search for pattern
    ./06-practical_arguments_log_analyzer.sh -f app.log -p "database connection"

    # Follow logs in real-time
    ./06-practical_arguments_log_analyzer.sh -f app.log --follow

EOF
    exit 0
}

log() {
    echo "[ANALYZER] $*"
}

parse_relative_date() {
    local date_str=$1
    
    if [[ $date_str =~ ([0-9]+)([hd])\ ago ]]; then
        local value=${BASH_REMATCH[1]}
        local unit=${BASH_REMATCH[2]}
        
        case $unit in
            h) echo "${value} hours ago" ;;
            d) echo "${value} days ago" ;;
        esac
    else
        echo "$date_str"
    fi
}

analyze_logs() {
    log "Analyzing log file: $LOG_FILE"
    
    # Build filter description
    local filters=()
    [ -n "$START_DATE" ] && filters+=("Start: $(parse_relative_date "$START_DATE")")
    [ -n "$END_DATE" ] && filters+=("End: $END_DATE")
    [ -n "$LEVEL" ] && filters+=("Level: $LEVEL")
    [ -n "$PATTERN" ] && filters+=("Pattern: $PATTERN")
    [ $LIMIT -gt 0 ] && filters+=("Limit: $LIMIT")
    
    if [ ${#filters[@]} -gt 0 ]; then
        echo "Filters:"
        for filter in "${filters[@]}"; do
            echo "  - $filter"
        done
    fi
    
    echo ""
    log "Processing logs..."
    
    # Simulated log analysis
    case $OUTPUT_FORMAT in
        text)
            display_text_output
            ;;
        json)
            display_json_output
            ;;
        csv)
            display_csv_output
            ;;
    esac
}

display_text_output() {
    echo ""
    echo "=== Log Analysis Results ==="
    echo ""
    
    cat << 'EOF'
2024-12-01 10:00:15 [ERROR] Database connection failed: timeout after 30s
2024-12-01 10:00:16 [WARN]  Retrying database connection (attempt 1/3)
2024-12-01 10:00:18 [ERROR] Database connection failed: timeout after 30s
2024-12-01 10:00:19 [WARN]  Retrying database connection (attempt 2/3)
2024-12-01 10:00:21 [INFO]  Database connection established
2024-12-01 10:05:32 [ERROR] API request failed: 500 Internal Server Error
2024-12-01 10:05:33 [WARN]  Cache miss for key: user:12345
2024-12-01 10:10:45 [ERROR] Payment processing failed: insufficient funds
EOF
    
    echo ""
    echo "--- Summary ---"
    echo "Total lines: 8"
    echo "Errors: 4"
    echo "Warnings: 3"
    echo "Info: 1"
}

display_json_output() {
    cat << 'EOF'
{
  "summary": {
    "total_lines": 8,
    "errors": 4,
    "warnings": 3,
    "info": 1
  },
  "logs": [
    {
      "timestamp": "2024-12-01T10:00:15Z",
      "level": "ERROR",
      "message": "Database connection failed: timeout after 30s"
    },
    {
      "timestamp": "2024-12-01T10:00:16Z",
      "level": "WARN",
      "message": "Retrying database connection (attempt 1/3)"
    },
    {
      "timestamp": "2024-12-01T10:00:18Z",
      "level": "ERROR",
      "message": "Database connection failed: timeout after 30s"
    },
    {
      "timestamp": "2024-12-01T10:05:32Z",
      "level": "ERROR",
      "message": "API request failed: 500 Internal Server Error"
    }
  ]
}
EOF
}

display_csv_output() {
    cat << 'EOF'
timestamp,level,message
2024-12-01 10:00:15,ERROR,"Database connection failed: timeout after 30s"
2024-12-01 10:00:16,WARN,"Retrying database connection (attempt 1/3)"
2024-12-01 10:00:18,ERROR,"Database connection failed: timeout after 30s"
2024-12-01 10:00:19,WARN,"Retrying database connection (attempt 2/3)"
2024-12-01 10:00:21,INFO,"Database connection established"
2024-12-01 10:05:32,ERROR,"API request failed: 500 Internal Server Error"
2024-12-01 10:05:33,WARN,"Cache miss for key: user:12345"
2024-12-01 10:10:45,ERROR,"Payment processing failed: insufficient funds"
EOF
}

follow_logs() {
    log "Following log file: $LOG_FILE (Press Ctrl+C to stop)"
    echo ""
    
    # Simulate following logs
    for i in {1..5}; do
        echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] New log entry $i"
        sleep 1
    done
    
    echo ""
    log "Stopped following logs"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            LOG_FILE="$2"
            shift 2
            ;;
        --start)
            START_DATE="$2"
            shift 2
            ;;
        --end)
            END_DATE="$2"
            shift 2
            ;;
        -l|--level)
            LEVEL="$2"
            shift 2
            ;;
        -p|--pattern)
            PATTERN="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        --follow)
            FOLLOW=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate required arguments
if [ -z "$LOG_FILE" ]; then
    echo "Error: Log file is required"
    echo ""
    usage
fi

# Main execution
echo "=== Log Analyzer ==="
echo "Log file: $LOG_FILE"
echo "Output format: $OUTPUT_FORMAT"
echo ""

if [ "$FOLLOW" = true ]; then
    follow_logs
else
    analyze_logs
fi

echo ""
echo "Analysis completed"
