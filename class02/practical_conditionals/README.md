# Practical Conditionals Examples

This directory contains real-world examples demonstrating conditional logic patterns used in DevOps automation.

## Files in this Directory

### Individual Examples (Numbered)
1. **01-practical_conditionals_system_health.sh** - System health monitoring with thresholds and color-coded output
2. **02-practical_conditionals_deployment_validator.sh** - Environment and version validation for deployments
3. **03-practical_conditionals_dependency_checker.sh** - Service dependency validation with case statements
4. **04-practical_conditionals_config_validator.sh** - Configuration file validation and field checking
5. **05-practical_conditionals_backup_logic.sh** - Intelligent backup decisions based on multiple factors
6. **06-practical_conditionals_access_control.sh** - Role-based access control (RBAC) patterns
7. **07-practical_conditionals_rollback_decision.sh** - Automated rollback decisions based on health metrics

### Comprehensive File
- **practical_conditionals.sh** - All examples combined in a single file for reference

## Quick Start

### Run a Single Example
```bash
./01-practical_conditionals_system_health.sh
```

### Run All Examples
```bash
for f in 0*-practical_conditionals_*.sh; do
    echo "=== Running $f ==="
    ./"$f"
    echo ""
done
```

## What You'll Learn

- **If/Else Patterns** - Testing conditions and making decisions
- **File Testing** - Checking file existence, permissions, content
- **Numeric Comparisons** - Threshold-based decisions
- **String Matching** - Pattern matching and validation
- **Case Statements** - Multi-way branching
- **Logical Operators** - Combining multiple conditions
- **Exit Codes** - Function return values and error handling

## Use Cases Covered

- System monitoring and alerting
- Pre-deployment validation
- Configuration validation
- Access control and security
- Automated decision making
- Error handling and recovery

## Related Topics

See also:
- `../practical_loops/` - Loop constructs for iteration
- `../practical_functions/` - Reusable function patterns
- `../control_structures.sh` - Core control structure demos
