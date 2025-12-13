#!/bin/bash

# Practical Example: Backup Utility
# Demonstrates: File path arguments, compression options, incremental backups

set -euo pipefail

# Default values
SOURCE=""
DESTINATION=""
COMPRESS=false
INCREMENTAL=false
EXCLUDE_PATTERN=""
BACKUP_TYPE="full"
VERBOSE=false

# Function to display usage
usage() {
    cat << 'EOF'
Backup Utility - Smart File Backup Tool

Usage: ./02-practical_arguments_backup_script.sh [OPTIONS] -s SOURCE -d DESTINATION

Required Arguments:
    -s, --source DIR        Source directory to backup
    -d, --dest DIR          Destination directory for backup

Optional Arguments:
    -c, --compress          Compress backup using gzip
    -i, --incremental       Perform incremental backup
    -e, --exclude PATTERN   Exclude files matching pattern
    -v, --verbose           Enable verbose output
    -h, --help              Show this help message

Examples:
    # Simple full backup
    ./02-practical_arguments_backup_script.sh -s /var/www -d /backups

    # Compressed backup
    ./02-practical_arguments_backup_script.sh -s /home/user -d /backups -c

    # Incremental backup excluding logs
    ./02-practical_arguments_backup_script.sh -s /app -d /backups -i -e "*.log"

EOF
    exit 0
}

# Logging function
log() {
    local level=$1
    shift
    echo "[$level] $(date '+%Y-%m-%d %H:%M:%S') - $*"
    
    if [ "$VERBOSE" = true ] && [ "$level" = "DEBUG" ]; then
        echo "[DEBUG] $*"
    fi
}

# Validate paths
validate_paths() {
    if [ ! -d "$SOURCE" ]; then
        log ERROR "Source directory does not exist: $SOURCE"
        exit 1
    fi
    
    if [ ! -d "$DESTINATION" ]; then
        log INFO "Creating destination directory: $DESTINATION"
        mkdir -p "$DESTINATION"
    fi
    
    log INFO "Source: $SOURCE"
    log INFO "Destination: $DESTINATION"
}

# Perform backup
perform_backup() {
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_name="backup_${timestamp}"
    
    if [ "$INCREMENTAL" = true ]; then
        BACKUP_TYPE="incremental"
        backup_name="backup_incremental_${timestamp}"
    fi
    
    log INFO "Starting $BACKUP_TYPE backup..."
    log INFO "Backup name: $backup_name"
    
    # Build rsync command
    local rsync_cmd="rsync -a"
    
    if [ "$VERBOSE" = true ]; then
        rsync_cmd="$rsync_cmd -v --progress"
    fi
    
    if [ -n "$EXCLUDE_PATTERN" ]; then
        rsync_cmd="$rsync_cmd --exclude='$EXCLUDE_PATTERN'"
        log INFO "Excluding pattern: $EXCLUDE_PATTERN"
    fi
    
    # Simulated backup operation
    log INFO "Executing: $rsync_cmd $SOURCE/ $DESTINATION/$backup_name/"
    
    # Create simulated backup
    mkdir -p "$DESTINATION/$backup_name"
    echo "Backup created at $(date)" > "$DESTINATION/$backup_name/backup_info.txt"
    echo "Source: $SOURCE" >> "$DESTINATION/$backup_name/backup_info.txt"
    echo "Type: $BACKUP_TYPE" >> "$DESTINATION/$backup_name/backup_info.txt"
    
    if [ "$COMPRESS" = true ]; then
        log INFO "Compressing backup..."
        local archive_name="${backup_name}.tar.gz"
        log INFO "Creating archive: $archive_name"
        # Simulated compression
        echo "Compressed backup" > "$DESTINATION/${archive_name}.info"
        log INFO "Backup compressed successfully"
    fi
    
    log INFO "Backup completed successfully!"
    log INFO "Backup location: $DESTINATION/$backup_name"
}

# Calculate backup size
calculate_size() {
    log INFO "Calculating backup size..."
    # Simulated size calculation
    echo "Estimated size: 1.2 GB"
    echo "Files: ~5,430"
    echo "Directories: ~850"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--source)
            SOURCE="$2"
            shift 2
            ;;
        -d|--dest|--destination)
            DESTINATION="$2"
            shift 2
            ;;
        -c|--compress)
            COMPRESS=true
            shift
            ;;
        -i|--incremental)
            INCREMENTAL=true
            shift
            ;;
        -e|--exclude)
            EXCLUDE_PATTERN="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h for help"
            exit 1
            ;;
    esac
done

# Validate required arguments
if [ -z "$SOURCE" ] || [ -z "$DESTINATION" ]; then
    echo "Error: Source and destination are required"
    echo ""
    usage
fi

# Main execution
echo "=== Backup Utility ==="
echo ""

validate_paths
calculate_size
echo ""
perform_backup

echo ""
echo "Backup operation completed at $(date)"
