#!/bin/bash
#
# Example 5: Intelligent Backup System
# Demonstrates: Decision logic, file age checking, disk space validation
#

set -euo pipefail

echo "======================================="
echo "  INTELLIGENT BACKUP SYSTEM"
echo "======================================="
echo ""

should_backup() {
    local data_dir=$1
    local last_backup_file=$2
    
    echo "Analyzing backup requirements..."
    
    # Check if data directory exists
    if [ ! -d "$data_dir" ]; then
        echo "  ✗ Data directory not found: $data_dir"
        return 1
    fi
    
    # Check if there are any files
    local file_count=$(find "$data_dir" -type f | wc -l)
    if [ $file_count -eq 0 ]; then
        echo "  ℹ No files to backup"
        return 1
    fi
    
    echo "  Files to backup: $file_count"
    
    # Check last backup time
    if [ -f "$last_backup_file" ]; then
        local last_backup=$(stat -f%m "$last_backup_file" 2>/dev/null || stat -c%Y "$last_backup_file" 2>/dev/null)
        local current_time=$(date +%s)
        local hours_since_backup=$(( (current_time - last_backup) / 3600 ))
        
        echo "  Hours since last backup: $hours_since_backup"
        
        if [ $hours_since_backup -lt 24 ]; then
            echo "  ℹ Backup performed recently, skipping"
            return 1
        fi
    else
        echo "  ℹ No previous backup found"
    fi
    
    # Check day of week (prefer weekdays)
    local day_of_week=$(date +%u)
    if [ $day_of_week -gt 5 ]; then
        echo "  ℹ Weekend - backup not critical"
    else
        echo "  ✓ Weekday - backup recommended"
    fi
    
    # Check available disk space
    local available_space=$(df /tmp | tail -1 | awk '{print $4}')
    local required_space=1000000  # 1GB in KB
    
    if [ $available_space -lt $required_space ]; then
        echo "  ✗ Insufficient disk space for backup"
        return 1
    fi
    
    echo "  ✓ Sufficient disk space available"
    echo ""
    echo "✓ Backup should proceed"
    return 0
}

# Test backup logic
mkdir -p /tmp/test_data
touch /tmp/test_data/file{1..5}.txt
should_backup "/tmp/test_data" "/tmp/last_backup.marker" || echo "Backup skipped"

# Cleanup
rm -rf /tmp/test_data
