#!/bin/bash
#
# Example 1: System Health Monitor
# Demonstrates: Multi-level thresholds, color-coded output, status checking
#

set -euo pipefail

echo "======================================="
echo "  SYSTEM HEALTH MONITOR"
echo "======================================="
echo ""

# Configuration
CPU_WARN=70
CPU_CRIT=90
MEM_WARN=75
MEM_CRIT=90
DISK_WARN=80
DISK_CRIT=95

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

check_cpu_usage() {
    # Get CPU usage 
    # Get idle CPU percentage from top command 
    # 2>: File descriptor redirection. 0 = stdin, 1 = stdout, 2 = stderr
    # Pipe (|): Chains commands together, feeding output of one as input to the next
    # grep: Pattern matching - finds lines containing specific text
    # awk: Column-based text processor - treats each line as fields separated by whitespace
    # sed: Find-and-replace tool - transforms text using patterns
    # ||: Fallback operator - runs second command only if first fails
    local cpu_idle=$(top -l 1 -n 0 2>/dev/null | grep "CPU usage" | awk '{print $7}' | sed 's/%//' || echo "0")
    local cpu_usage=$((100 - ${cpu_idle%.*}))
    
    echo -n "CPU Usage: ${cpu_usage}% - "
    
    if [ $cpu_usage -lt $CPU_WARN ]; then
        echo -e "${GREEN}NORMAL${NC}"
        return 0
    elif [ $cpu_usage -lt $CPU_CRIT ]; then
        echo -e "${YELLOW}WARNING${NC}"
        echo "  Action: Monitor closely"
        return 1
    else
        echo -e "${RED}CRITICAL${NC}"
        echo "  Action: Investigate high CPU processes"
        return 2
    fi
}

check_memory_usage() {
    # Simulate memory check
    local mem_usage=65
    
    echo -n "Memory Usage: ${mem_usage}% - "
    
    if [ $mem_usage -ge $MEM_CRIT ]; then
        echo -e "${RED}CRITICAL${NC}"
        echo "  Action: Clear cache or restart services"
        return 2
    elif [ $mem_usage -ge $MEM_WARN ]; then
        echo -e "${YELLOW}WARNING${NC}"
        echo "  Action: Review memory-intensive processes"
        return 1
    else
        echo -e "${GREEN}NORMAL${NC}"
        return 0
    fi
}

check_disk_space() {
    local disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    
    echo -n "Disk Usage: ${disk_usage}% - "
    
    if [ $disk_usage -ge $DISK_CRIT ]; then
        echo -e "${RED}CRITICAL${NC}"
        echo "  Action: Clean up immediately!"
        echo "  Suggested: Check logs, temp files, old backups"
        return 2
    elif [ $disk_usage -ge $DISK_WARN ]; then
        echo -e "${YELLOW}WARNING${NC}"
        echo "  Action: Plan cleanup soon"
        return 1
    else
        echo -e "${GREEN}NORMAL${NC}"
        return 0
    fi
}

# Run health checks
check_cpu_usage || true
check_memory_usage || true
check_disk_space || true

echo ""
echo "✓ Health check completed"
