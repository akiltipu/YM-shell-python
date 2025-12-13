#!/bin/bash

# Comprehensive Practical Arguments Examples
# This file combines all practical argument parsing patterns in one place

set -euo pipefail

echo "======================================"
echo "Practical Command-Line Arguments Guide"
echo "======================================"
echo ""
echo "This comprehensive script demonstrates all argument parsing patterns."
echo "Individual examples are available in separate numbered files."
echo ""

# Example 1: Production Deployment Tool
echo "Example 1: Production Deployment Tool"
echo "--------------------------------------"
echo "Demonstrates: Environment validation, version parsing, rollback options"
echo "Usage: ./01-practical_arguments_deployment_tool.sh -e production -s api -v v1.2.3"
echo ""

# Example 2: Backup Script
echo "Example 2: Backup Utility"
echo "--------------------------------------"
echo "Demonstrates: File paths, compression, incremental backups"
echo "Usage: ./02-practical_arguments_backup_script.sh -s /var/www -d /backups -c"
echo ""

# Example 3: User Management
echo "Example 3: User Management Tool"
echo "--------------------------------------"
echo "Demonstrates: Actions, role validation, interactive mode"
echo "Usage: ./03-practical_arguments_user_management.sh create -u john -r developer"
echo ""

# Example 4: Configuration Manager
echo "Example 4: Configuration Manager"
echo "--------------------------------------"
echo "Demonstrates: Subcommands, CRUD operations, format options"
echo "Usage: ./04-practical_arguments_config_manager.sh get database.host"
echo ""

# Example 5: Docker Wrapper
echo "Example 5: Docker Wrapper"
echo "--------------------------------------"
echo "Demonstrates: Complex commands, arrays, option passthrough"
echo "Usage: ./05-practical_arguments_docker_wrapper.sh run nginx -n web -p 8080:80 -d"
echo ""

# Example 6: Log Analyzer
echo "Example 6: Log Analyzer"
echo "--------------------------------------"
echo "Demonstrates: File arguments, date parsing, filtering"
echo "Usage: ./06-practical_arguments_log_analyzer.sh -f app.log --level ERROR"
echo ""

# Example 7: Batch Processor
echo "Example 7: Batch File Processor"
echo "--------------------------------------"
echo "Demonstrates: Multiple files, parallel processing, progress tracking"
echo "Usage: ./07-practical_arguments_batch_processor.sh convert -j 4 *.jpg"
echo ""

echo "======================================"
echo "Key Patterns Covered:"
echo "======================================"
echo "✓ Required and optional arguments"
echo "✓ Named options (--long and -short)"
echo "✓ Positional parameters"
echo "✓ Action-based commands (subcommands)"
echo "✓ Multiple values (arrays)"
echo "✓ Boolean flags"
echo "✓ Argument validation"
echo "✓ Interactive mode"
echo "✓ Help messages"
echo "✓ Default values"
echo ""

echo "Run individual examples to see each pattern in action!"
