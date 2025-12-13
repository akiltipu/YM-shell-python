#!/bin/bash

# Practical Example 5: Database Backup with Error Handling
# Demonstrates comprehensive error handling in database backup operations

set -euo pipefail

# Configuration
DB_NAME="production_db"
BACKUP_DIR="/var/backups/database"
RETENTION_DAYS=7
LOG_FILE="/var/log/db_backup.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# Error handler
error_exit() {
    log "ERROR" "$1"
    cleanup_on_error
    exit 1
}

# Success handler
success_exit() {
    log "INFO" "$1"
    exit 0
}

# Cleanup on error
cleanup_on_error() {
    log "INFO" "Cleaning up after error..."
    if [ -f "$TEMP_BACKUP" ]; then
        rm -f "$TEMP_BACKUP"
        log "INFO" "Removed temporary backup file"
    fi
}

# Set up trap for cleanup
trap cleanup_on_error ERR

# Pre-flight checks
preflight_checks() {
    log "INFO" "Running pre-flight checks..."
    
    # Check if backup directory exists
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR" || error_exit "Cannot create backup directory"
    fi
    
    # Check disk space (need at least 1GB free)
    available_space=$(df "$BACKUP_DIR" | awk 'NR==2 {print $4}')
    if [ "$available_space" -lt 1048576 ]; then
        error_exit "Insufficient disk space. Need at least 1GB free"
    fi
    
    # Check if database is accessible
    if ! command -v mysql &> /dev/null; then
        error_exit "MySQL client not found"
    fi
    
    log "INFO" "Pre-flight checks passed"
}

# Perform backup
perform_backup() {
    local backup_file="$BACKUP_DIR/${DB_NAME}_$(date +%Y%m%d_%H%M%S).sql.gz"
    TEMP_BACKUP="${backup_file}.tmp"
    
    log "INFO" "Starting backup of database: $DB_NAME"
    
    # Simulate backup (in production, use actual mysqldump)
    if mysqldump "$DB_NAME" 2>/dev/null | gzip > "$TEMP_BACKUP"; then
        mv "$TEMP_BACKUP" "$backup_file"
        log "INFO" "Backup completed successfully: $backup_file"
        
        # Verify backup
        if [ ! -s "$backup_file" ]; then
            error_exit "Backup file is empty or doesn't exist"
        fi
        
        # Calculate and log backup size
        local size=$(du -h "$backup_file" | cut -f1)
        log "INFO" "Backup size: $size"
        
        echo "$backup_file"
    else
        error_exit "Backup failed for database: $DB_NAME"
    fi
}

# Cleanup old backups
cleanup_old_backups() {
    log "INFO" "Cleaning up backups older than $RETENTION_DAYS days..."
    
    local deleted_count=0
    while IFS= read -r old_backup; do
        if rm -f "$old_backup"; then
            log "INFO" "Deleted old backup: $(basename "$old_backup")"
            ((deleted_count++))
        else
            log "WARN" "Failed to delete: $(basename "$old_backup")"
        fi
    done < <(find "$BACKUP_DIR" -name "${DB_NAME}_*.sql.gz" -type f -mtime +${RETENTION_DAYS})
    
    log "INFO" "Cleanup complete. Removed $deleted_count old backup(s)"
}

# Main execution
main() {
    log "INFO" "=== Database Backup Script Started ==="
    
    # Run checks
    preflight_checks
    
    # Perform backup
    backup_file=$(perform_backup)
    
    # Cleanup old backups
    cleanup_old_backups
    
    # Success
    log "INFO" "=== Database Backup Script Completed Successfully ==="
    echo -e "${GREEN}✓ Backup completed: $backup_file${NC}"
}

# For demo purposes (simulated environment)
demo_mode() {
    echo "=== Database Backup Error Handling Demo ==="
    echo ""
    
    # Simulate backup directory creation
    echo "Creating backup directory..."
    mkdir -p /tmp/demo_backups
    
    # Simulate successful backup
    echo "Performing backup..."
    echo "-- MySQL dump" | gzip > /tmp/demo_backups/production_db_$(date +%Y%m%d_%H%M%S).sql.gz
    echo -e "${GREEN}✓ Backup successful${NC}"
    
    # Simulate old backup cleanup
    echo ""
    echo "Cleaning up old backups..."
    echo "- Retention period: 7 days"
    echo -e "${GREEN}✓ Cleanup complete${NC}"
    
    # Demonstrate error handling
    echo ""
    echo "=== Error Handling Scenarios ==="
    echo ""
    
    echo "1. Insufficient disk space:"
    echo -e "${RED}✗ ERROR: Insufficient disk space. Need at least 1GB free${NC}"
    
    echo ""
    echo "2. Database not accessible:"
    echo -e "${RED}✗ ERROR: Cannot connect to database${NC}"
    
    echo ""
    echo "3. Backup file is empty:"
    echo -e "${RED}✗ ERROR: Backup file is empty or corrupted${NC}"
    
    echo ""
    echo "All errors are logged to: $LOG_FILE"
}

# Run demo mode
demo_mode

echo ""
echo "💡 Key Error Handling Patterns:"
echo "   - Pre-flight checks before operations"
echo "   - Trap for cleanup on error"
echo "   - Atomic operations with temp files"
echo "   - Comprehensive logging"
echo "   - Disk space validation"
echo "   - Backup verification"
