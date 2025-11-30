#!/bin/bash
#
# Example 3: System Information Functions Demo
# Demonstrates: System metrics, resource monitoring, information gathering
#

set -euo pipefail

echo "======================================="
echo "  SYSTEM INFORMATION DEMO"
echo "======================================="
echo ""

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
    elif command -v sysctl &> /dev/null; then
        sysctl -n hw.ncpu 2>/dev/null || echo "1"
    else
        echo "1"
    fi
}

get_memory_total() {
    if command -v free &> /dev/null; then
        free -h | awk '/^Mem:/ {print $2}'
    elif command -v sysctl &> /dev/null; then
        # macOS
        local mem_bytes=$(sysctl -n hw.memsize 2>/dev/null || echo "0")
        local mem_gb=$((mem_bytes / 1024 / 1024 / 1024))
        echo "${mem_gb}G"
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
        uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}' | xargs
    else
        echo "N/A"
    fi
}

display_system_info() {
    echo "System Information:"
    echo "  OS: $(get_os_type)"
    echo "  Hostname: $(get_hostname)"
    echo "  CPU Cores: $(get_cpu_count)"
    echo "  Total Memory: $(get_memory_total)"
    echo "  Memory Usage: $(get_memory_usage_percent)%"
    echo "  Disk Usage (/): $(get_disk_usage)%"
    echo "  Uptime: $(get_uptime)"
}

#==========================================
# DEMO
#==========================================

display_system_info
echo ""

echo "Individual function tests:"
echo "  OS Type: $(get_os_type)"
echo "  Hostname: $(get_hostname)"
echo "  CPU Count: $(get_cpu_count)"
echo ""

echo "System monitoring complete!"
