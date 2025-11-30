# Practical Functions Examples

This directory contains real-world function examples demonstrating reusable patterns for DevOps automation.

## Files in this Directory

### Individual Examples by Category
1. **01-practical_functions_logging.sh** - Structured logging with multiple log levels
2. **02-practical_functions_validation.sh** - Input validation (empty, number, IP, email, port)
3. **03-practical_functions_system_info.sh** - System information gathering functions
4. **04-practical_functions_file_operations.sh** - File backup, rotation, and cleanup
5. **05-practical_functions_network.sh** - Port checking and service availability
6. **06-practical_functions_deployment.sh** - Deployment helpers (prerequisites, downloads, checksums)
7. **07-practical_functions_utilities.sh** - Retry mechanisms and execution timing

### Comprehensive Library
- **practical_functions.sh** - Complete function library (can be sourced into other scripts)

## Quick Start

### Run a Single Example
```bash
./01-practical_functions_logging.sh
```

### Run All Examples
```bash
for f in 0*-practical_functions_*.sh; do
    echo "=== Running $f ==="
    ./"$f"
    echo ""
done
```

### Source the Library
```bash
# In your own script
source ./practical_functions.sh

# Now use the functions
log_info "Starting deployment..."
validate_ip_address "192.168.1.1"
check_prerequisites "curl" "git" "docker"
```

## What You'll Learn

- **Function Declaration** - Basic function syntax and organization
- **Parameters** - Passing and handling function arguments
- **Return Values** - Exit codes and output
- **Error Handling** - Proper error propagation
- **Code Reuse** - Building function libraries
- **Validation Patterns** - Input sanitization and checking
- **Logging Patterns** - Structured logging with levels
- **Utility Functions** - Common DevOps helper functions

## Function Categories

### Logging Functions
- `log_info()` - Info level logging
- `log_warn()` - Warning level logging
- `log_error()` - Error level logging
- `log_success()` - Success level logging
- `log_debug()` - Debug level logging

### Validation Functions
- `validate_not_empty()` - Check for empty values
- `validate_number()` - Numeric validation
- `validate_ip_address()` - IP address format checking
- `validate_email()` - Email format validation
- `validate_port()` - Port number validation

### System Information Functions
- `get_os_type()` - Operating system detection
- `get_hostname()` - Get system hostname
- `get_cpu_count()` - CPU core count
- `get_memory_usage_percent()` - Memory usage metrics
- `get_disk_usage()` - Disk usage percentage

### File Operation Functions
- `backup_file()` - Create timestamped backups
- `rotate_file()` - Log rotation with versioning
- `cleanup_old_files()` - Remove files older than N days

### Network Functions
- `check_port_open()` - Test if port is reachable
- `wait_for_port()` - Wait for service availability

### Deployment Functions
- `check_prerequisites()` - Verify required commands exist
- `download_file()` - Download with retry logic
- `verify_checksum()` - Validate file checksums

### Utility Functions
- `retry_command()` - Execute command with retries
- `measure_execution_time()` - Time command execution

## Use Cases Covered

- Centralized logging for scripts
- Input validation and sanitization
- System health monitoring
- File management automation
- Network connectivity checking
- Deployment automation
- Error handling and recovery

## Related Topics

See also:
- `../practical_conditionals/` - Using functions with conditionals
- `../practical_loops/` - Using functions in loops
- `../functions_demo.sh` - Function basics demonstration
