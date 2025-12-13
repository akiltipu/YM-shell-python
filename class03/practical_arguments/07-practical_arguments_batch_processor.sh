#!/bin/bash

# Practical Example: Batch File Processor
# Demonstrates: Multiple file arguments, parallel processing, progress tracking

set -euo pipefail

FILES=()
OPERATION=""
OUTPUT_DIR=""
PARALLEL=1
RECURSIVE=false
DRY_RUN=false
VERBOSE=false

usage() {
    cat << 'EOF'
Batch File Processor - Process multiple files with various operations

Usage: ./07-practical_arguments_batch_processor.sh OPERATION [OPTIONS] FILE...

Operations:
    convert         Convert files (e.g., resize images, transcode video)
    compress        Compress files
    encrypt         Encrypt files
    backup          Backup files
    validate        Validate file integrity

Options:
    -o, --output DIR        Output directory (default: ./output)
    -j, --parallel N        Number of parallel jobs (default: 1)
    -r, --recursive         Process directories recursively
    -d, --dry-run           Show what would be done without doing it
    -v, --verbose           Verbose output
    -h, --help              Show this help message

Examples:
    # Convert multiple images
    ./07-practical_arguments_batch_processor.sh convert -o /output *.jpg

    # Compress files in parallel
    ./07-practical_arguments_batch_processor.sh compress -j 4 file1.txt file2.txt

    # Recursive processing
    ./07-practical_arguments_batch_processor.sh validate -r /data

    # Dry run to preview
    ./07-practical_arguments_batch_processor.sh backup -d *.log

EOF
    exit 0
}

log() {
    local level=$1
    shift
    echo "[$level] $*"
}

validate_operation() {
    local op=$1
    local valid_ops=("convert" "compress" "encrypt" "backup" "validate")
    
    if [[ ! " ${valid_ops[@]} " =~ " ${op} " ]]; then
        echo "Error: Invalid operation '$op'"
        echo "Valid operations: ${valid_ops[*]}"
        exit 1
    fi
}

process_file() {
    local file=$1
    local operation=$2
    
    [ "$VERBOSE" = true ] && log "DEBUG" "Processing: $file"
    
    case $operation in
        convert)
            echo "  → Converting $file..."
            sleep 0.2
            echo "  ✓ Converted: $file → ${OUTPUT_DIR}/$(basename "$file")"
            ;;
        compress)
            echo "  → Compressing $file..."
            sleep 0.2
            local size_before="1.2 MB"
            local size_after="350 KB"
            echo "  ✓ Compressed: $file ($size_before → $size_after, 71% reduction)"
            ;;
        encrypt)
            echo "  → Encrypting $file..."
            sleep 0.2
            echo "  ✓ Encrypted: $file.enc"
            ;;
        backup)
            echo "  → Backing up $file..."
            sleep 0.2
            echo "  ✓ Backed up: ${OUTPUT_DIR}/$(basename "$file").bak"
            ;;
        validate)
            echo "  → Validating $file..."
            sleep 0.2
            echo "  ✓ Valid: $file (checksum: abc123def456)"
            ;;
    esac
}

process_files() {
    local total=${#FILES[@]}
    local processed=0
    local failed=0
    
    log "INFO" "Processing $total file(s) with $PARALLEL parallel job(s)"
    echo ""
    
    if [ "$DRY_RUN" = true ]; then
        log "WARN" "DRY RUN MODE - No actual changes will be made"
        echo ""
    fi
    
    # Process files
    for file in "${FILES[@]}"; do
        ((processed++))
        local progress=$((processed * 100 / total))
        
        echo "[$processed/$total] ($progress%) $file"
        
        if [ "$DRY_RUN" = false ]; then
            if process_file "$file" "$OPERATION"; then
                [ "$VERBOSE" = true ] && log "DEBUG" "Success: $file"
            else
                ((failed++))
                log "ERROR" "Failed: $file"
            fi
        else
            echo "  → Would $OPERATION: $file"
        fi
        
        echo ""
    done
    
    # Summary
    echo "=== Summary ==="
    echo "Total files: $total"
    echo "Processed: $processed"
    [ $failed -gt 0 ] && echo "Failed: $failed"
    
    if [ "$DRY_RUN" = true ]; then
        echo ""
        log "INFO" "This was a dry run. Use without -d to perform actual operations"
    fi
}

# Parse operation
if [ $# -eq 0 ]; then
    usage
fi

OPERATION=$1
shift

# Validate operation
case $OPERATION in
    -h|--help)
        usage
        ;;
    *)
        validate_operation "$OPERATION"
        ;;
esac

# Parse options and files
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -j|--parallel)
            PARALLEL="$2"
            shift 2
            ;;
        -r|--recursive)
            RECURSIVE=true
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            # Collect file arguments
            FILES+=("$1")
            shift
            ;;
    esac
done

# Validate inputs
if [ ${#FILES[@]} -eq 0 ]; then
    echo "Error: No files specified"
    echo ""
    usage
fi

# Set default output directory
if [ -z "$OUTPUT_DIR" ]; then
    OUTPUT_DIR="./output"
fi

# Main execution
echo "=== Batch File Processor ==="
echo "Operation: $OPERATION"
echo "Output directory: $OUTPUT_DIR"
echo "Parallel jobs: $PARALLEL"
echo ""

# Create output directory
if [ "$DRY_RUN" = false ] && [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
    log "INFO" "Created output directory: $OUTPUT_DIR"
    echo ""
fi

# Process files
process_files

echo ""
echo "Batch processing completed"
