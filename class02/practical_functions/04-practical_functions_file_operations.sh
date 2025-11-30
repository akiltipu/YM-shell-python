#!/bin/bash
#
# Example 4: File Operation Functions Demo
# Demonstrates: File backup, rotation, cleanup automation
#

set -euo pipefail

echo "======================================="
echo "  FILE OPERATIONS DEMO"
echo "======================================="
echo ""

log_info() {
    echo "[INFO] $*"
}

log_success() {
    echo "[SUCCESS] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
}

log_debug() {
    echo "[DEBUG] $*"
}

log_warn() {
    echo "[WARN] $*"
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
    done < <(find "$directory" -name "$pattern" -type f -mtime "+$days_old" -print0 2>/dev/null)
    
    log_success "Removed $count old file(s)"
    return 0
}

#==========================================
# DEMO
#==========================================

echo "Test 1: Backup file"
echo "test content" > /tmp/test_file.txt
backup_file "/tmp/test_file.txt" "/tmp/demo_backups"
echo ""

echo "Test 2: File rotation"
echo "log entry 1" > /tmp/app.log
rotate_file "/tmp/app.log" 3
echo "log entry 2" > /tmp/app.log
rotate_file "/tmp/app.log" 3
echo "log entry 3" > /tmp/app.log
rotate_file "/tmp/app.log" 3
ls -la /tmp/app.log* 2>/dev/null || true
echo ""

echo "Test 3: Cleanup old files"
mkdir -p /tmp/old_files_test
touch /tmp/old_files_test/file1.log
touch /tmp/old_files_test/file2.log
cleanup_old_files "/tmp/old_files_test" "*.log" -1
echo ""

# Cleanup
rm -rf /tmp/test_file.txt /tmp/demo_backups /tmp/app.log* /tmp/old_files_test

log_success "File operations demo completed!"
