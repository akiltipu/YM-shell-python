# Practical Loops Examples

This directory contains real-world examples demonstrating loop patterns used in DevOps automation and system administration.

## Files in this Directory

### Individual Examples (Numbered)
1. **01-practical_loops_multi_server_deployment.sh** - Sequential deployment to multiple servers with progress tracking
2. **02-practical_loops_retry_backoff.sh** - Retry mechanism with exponential backoff
3. **03-practical_loops_parallel_processing.sh** - Parallel task execution with job control
4. **04-practical_loops_file_processing.sh** - Log file processing pipeline
5. **05-practical_loops_wait_for_service.sh** - Wait for service readiness with timeout
6. **06-practical_loops_health_check_matrix.sh** - Multi-server, multi-service health checks
7. **07-practical_loops_break_continue.sh** - Smart loop control with break and continue
8. **08-practical_loops_csv_processing.sh** - CSV data processing and parsing
9. **09-practical_loops_monitoring.sh** - Continuous monitoring with metrics collection
10. **10-practical_loops_array_iteration.sh** - Indexed array processing with progress calculation
11. **11-practical_loops_config_generation.sh** - Dynamic configuration file generation
12. **12-practical_loops_batch_processing.sh** - Batch processing with rate limiting
13. **13-practical_loops_menu_system.sh** - Interactive menu system pattern

### Comprehensive File
- **practical_loops.sh** - All examples combined in a single file for reference

## Quick Start

### Run a Single Example
```bash
./01-practical_loops_multi_server_deployment.sh
```

### Run All Examples
```bash
for f in 0*-practical_loops_*.sh 1*-practical_loops_*.sh; do
    echo "=== Running $f ==="
    ./"$f"
    echo ""
done
```

## What You'll Learn

- **For Loops** - Iterating over lists, arrays, and ranges
- **While Loops** - Conditional iteration and retry patterns
- **Until Loops** - Waiting for conditions to be met
- **Nested Loops** - Multi-dimensional iteration
- **Loop Control** - Break, continue, and early exits
- **Array Iteration** - Working with indexed and associative arrays
- **Parallel Processing** - Background jobs and process management
- **CSV Processing** - Reading and parsing structured data

## Use Cases Covered

- Multi-server deployments
- Retry and backoff strategies
- Service health monitoring
- Log file analysis
- Configuration management
- Batch processing
- Resource monitoring
- Menu-driven interfaces

## Related Topics

See also:
- `../practical_conditionals/` - Conditional logic patterns
- `../practical_functions/` - Reusable function patterns
- `../control_structures.sh` - Core loop demos
