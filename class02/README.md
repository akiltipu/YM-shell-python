# Class `02`
# Advanced Shell Scripting - Core Features and Best Practices

---

## Class Overview and Script Guide

**Welcome to Class 02!** This class builds on the fundamentals from Class 01 and introduces you to advanced shell scripting concepts used in professional DevOps environments.

### How to Use This Class

**1. Read the Theory First:** Each section in this README explains concepts with examples  
**2. Run the Demo Scripts:** Hands-on practice with provided shell scripts  
**3. Complete the Exercises:** Apply what you learned  
**4. Build Real Projects:** Use the practical examples as templates

### Scripts Included in This Class

This class includes **7 executable shell scripts** that demonstrate different concepts:

| Script | Purpose | What You'll Learn | When to Run |
|--------|---------|-------------------|-------------|
| `control_structures.sh` | Advanced conditionals | Case statements, pattern matching, file tests | After reading "Control Structures" section |
| `functions_demo.sh` | Function basics | Declaration, parameters, scope, return values | After reading "Functions" section |
| `file_operations.sh` | File handling | Read/write, permissions, directories, archives | After reading "File Operations" section |
| `practical_conditionals.sh` | Real-world conditionals | System monitoring, validation, health checks | After understanding conditionals |
| `practical_loops.sh` | Advanced loops | Deployment automation, retry logic, parallel execution | After understanding loops |
| `practical_functions.sh` | Function library | Reusable utilities, logging, validation | After understanding functions |

### How to Run the Scripts

**Step 1: Make Scripts Executable**
```bash
cd /Users/akiltipu/WORK/yourmentors/class02
chmod +x *.sh
```

**Step 2: Run Any Script**
```bash
# Demo scripts (educational)
./control_structures.sh
./functions_demo.sh
./file_operations.sh

# Practical scripts (real-world examples)
./practical_conditionals.sh
./practical_loops.sh
./practical_functions.sh
```

**Step 3: Study the Code**
```bash
# Open any script in your editor to see the code
cat control_structures.sh
# or
code control_structures.sh  # If using VS Code
```

### Learning Path Recommendation

```
Week 1: Core Features
├── Day 1: Read "Core Features" → Run control_structures.sh
├── Day 2: Read "Control Structures" → Experiment with case statements
└── Day 3: Read "Functions" → Run functions_demo.sh

Week 2: Practical Application
├── Day 4: Run practical_conditionals.sh → Build your own health check
├── Day 5: Run practical_loops.sh → Create deployment script
└── Day 6: Run practical_functions.sh → Build function library

Week 3: Real Projects
└── Apply everything to create your DevOps automation suite
```

---


#### Building on Fundamentals

**Where We Left Off:**
```
Class 01 Recap:
✓ Shell scripting basics
✓ Variables and user input
✓ Basic conditionals (if/else)
✓ Basic loops (for/while/until)
✓ Simple automation scripts
```

**Class 02 Journey:**
```
Today's Focus:
→ Core shell scripting features
→ Advanced control structures
→ Functions and code organization
→ File and directory operations
→ Professional DevOps automation
```

### Core Features of Shell Scripting

Shell scripting offers powerful features that make it indispensable for DevOps automation. Understanding these core capabilities allows you to write more efficient, maintainable, and production-ready scripts.

---

#### Exit Status and Error Handling

**Understanding Exit Codes:**

Every command in shell scripting returns an exit status (0-255):
- `0` = Success
- `1-255` = Error (different codes indicate different errors)

```bash
# Check exit status of last command
echo "Hello"
echo $?  # Outputs: 0 (success)

ls /nonexistent
echo $?  # Outputs: 2 (error - file not found)
```

**The Special Variable `$?`:**

| Variable | Meaning | Example |
|----------|---------|---------|
| `$?` | Exit status of last command | `echo $?` |
| `$0` | Script name | `echo $0` |
| `$1, $2, ...` | Positional parameters | `echo $1` |
| `$#` | Number of arguments | `echo $#` |
| `$@` | All arguments (as array) | `echo $@` |
| `$*` | All arguments (as string) | `echo $*` |
| `$$` | Current process ID | `echo $$` |
| `$!` | Last background process ID | `echo $!` |

**Practical Error Handling:**

```bash
#!/bin/bash
# Error Handling Demo

# Method 1: Check exit status
mkdir /tmp/myapp
if [ $? -eq 0 ]; then
    echo "Directory created successfully"
else
    echo "Failed to create directory"
fi

# Method 2: Direct conditional
if cp source.txt backup.txt; then
    echo "Backup created"
else
    echo "Backup failed"
fi

# Method 3: Exit on any error
set -e  # Exit immediately if a command fails
set -u  # Treat unset variables as errors
set -o pipefail  # Pipeline fails if any command fails

# Method 4: Custom error handling
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

cd /important/directory || error_exit "Cannot change to directory"
```

**Best Practice Pattern:**
```bash
#!/bin/bash
set -euo pipefail  # Strict mode

# Enable debug mode
# set -x

cleanup() {
    echo "Cleaning up..."
    # Remove temp files, etc.
}

# Run cleanup on exit
trap cleanup EXIT

# Your script logic here
```

---

#### Command Line Arguments

**Accessing Arguments:**

```bash
#!/bin/bash
# Script: deploy.sh

echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Total arguments: $#"
echo "All arguments: $@"

# Usage: ./deploy.sh production app-v1.2
```

**Argument Validation:**

```bash
#!/bin/bash
# deployment_tool.sh

# Check if enough arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <environment> <version>"
    echo "Example: $0 production v1.2.3"
    exit 1
fi

ENVIRONMENT=$1
VERSION=$2

echo "Deploying $VERSION to $ENVIRONMENT environment..."
```

**Advanced Argument Parsing:**

```bash
#!/bin/bash
# Advanced argument handling

# Default values
VERBOSE=false
DRY_RUN=false
ENVIRONMENT=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [-v] [-d] -e <environment>"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate required arguments
if [ -z "$ENVIRONMENT" ]; then
    echo "Error: Environment is required"
    exit 1
fi

echo "Environment: $ENVIRONMENT"
echo "Verbose: $VERBOSE"
echo "Dry Run: $DRY_RUN"
```

---

#### Arrays and Advanced Data Structures

**Array Basics:**

```bash
#!/bin/bash

# 1. Array Declaration
servers=("web01" "web02" "db01" "cache01")
ports=(8080 8081 3306 6379)

# 2. Accessing Elements
echo "First server: ${servers[0]}"
echo "Second server: ${servers[1]}"

# 3. Array Length
echo "Total servers: ${#servers[@]}"

# 4. All Elements
echo "All servers: ${servers[@]}"

# 5. Adding Elements
servers+=("backup01")
echo "Updated list: ${servers[@]}"

# 6. Iterating Array
for server in "${servers[@]}"; do
    echo "Processing: $server"
done

# 7. Array Indices
for index in "${!servers[@]}"; do
    echo "Index $index: ${servers[$index]}"
done
```

**Associative Arrays (Bash 4+):**

```bash
#!/bin/bash

# Declare associative array
declare -A service_ports

# Assign values
service_ports[nginx]=80
service_ports[mysql]=3306
service_ports[redis]=6379
service_ports[postgres]=5432

# Access values
echo "Nginx port: ${service_ports[nginx]}"

# Get all keys
echo "Services: ${!service_ports[@]}"

# Get all values
echo "Ports: ${service_ports[@]}"

# Iterate
for service in "${!service_ports[@]}"; do
    echo "$service runs on port ${service_ports[$service]}"
done
```

**Practical Example - Server Configuration:**

```bash
#!/bin/bash

declare -A server_config

# Configuration
server_config[web_ip]="192.168.1.10"
server_config[web_port]="8080"
server_config[db_ip]="192.168.1.20"
server_config[db_port]="3306"
server_config[db_name]="production"

# Function to display config
show_config() {
    echo "=== Server Configuration ==="
    echo "Web Server: ${server_config[web_ip]}:${server_config[web_port]}"
    echo "Database: ${server_config[db_ip]}:${server_config[db_port]}"
    echo "DB Name: ${server_config[db_name]}"
}

show_config
```

---

### Control Structures

**What Are Control Structures?**

Control structures are the decision-making components of your scripts. They determine:
- **What code runs** (conditionals)
- **How many times it runs** (loops)
- **Which path to take** (case statements)

Think of them as traffic lights and signs for your code—directing the flow of execution.

---

#### Advanced Conditional Statements

**Why Use Case Statements?**

When you have many if-elif-else chains, code becomes hard to read:
```bash
# Hard to read 
if [ "$choice" = "start" ]; then
    ...
elif [ "$choice" = "stop" ]; then
    ...
elif [ "$choice" = "restart" ]; then
    ...
# etc...
```

Case statements make this cleaner:
```bash
# Easy to read
case $choice in
    start) ... ;;
    stop) ... ;;
    restart) ... ;;
esac
```

**Case Statements:**

The `case` statement is perfect for handling multiple conditions cleanly.

**Syntax:**
```bash
case $variable in
    pattern1)
        # commands
        ;;
    pattern2)
        # commands
        ;;
    *)
        # default case
        ;;
esac
```

**Practical Example:**

```bash
#!/bin/bash
# Service Management Script

ACTION=$1
SERVICE=$2

case $ACTION in
    start)
        echo "Starting $SERVICE..."
        # systemctl start $SERVICE
        ;;
    stop)
        echo "Stopping $SERVICE..."
        # systemctl stop $SERVICE
        ;;
    restart)
        echo "Restarting $SERVICE..."
        # systemctl restart $SERVICE
        ;;
    status)
        echo "Checking $SERVICE status..."
        # systemctl status $SERVICE
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status} <service>"
        exit 1
        ;;
esac
```

**Advanced Pattern Matching:**

```bash
#!/bin/bash

read -p "Enter file name: " filename

case $filename in
    *.txt)
        echo "Text file detected"
        cat "$filename"
        ;;
    *.sh)
        echo "Shell script detected"
        bash -n "$filename"  # Syntax check
        ;;
    *.log)
        echo "Log file detected"
        tail -20 "$filename"
        ;;
    *.json|*.yaml|*.yml)
        echo "Configuration file detected"
        ;;
    *)
        echo "Unknown file type"
        ;;
esac
```

**Environment-Based Configuration:**

```bash
#!/bin/bash

ENVIRONMENT=$1

case $ENVIRONMENT in
    dev|development)
        DB_HOST="localhost"
        DB_NAME="dev_db"
        DEBUG=true
        LOG_LEVEL="DEBUG"
        ;;
    staging|stage)
        DB_HOST="staging-db.company.com"
        DB_NAME="staging_db"
        DEBUG=true
        LOG_LEVEL="INFO"
        ;;
    prod|production)
        DB_HOST="prod-db.company.com"
        DB_NAME="production_db"
        DEBUG=false
        LOG_LEVEL="ERROR"
        ;;
    *)
        echo "Unknown environment: $ENVIRONMENT"
        echo "Use: dev, staging, or production"
        exit 1
        ;;
esac

echo "Configuration for $ENVIRONMENT:"
echo "  DB Host: $DB_HOST"
echo "  DB Name: $DB_NAME"
echo "  Debug: $DEBUG"
echo "  Log Level: $LOG_LEVEL"
```

---

#### Advanced Test Conditions

**Double Brackets `[[ ]]` vs Single Brackets `[ ]`:**

```bash
#!/bin/bash

# Single brackets (POSIX compatible)
if [ "$var" = "value" ]; then
    echo "Match"
fi

# Double brackets (Bash extended)
if [[ $var == value ]]; then
    echo "Match"
fi

# Pattern matching (only with [[]])
if [[ $filename == *.txt ]]; then
    echo "Text file"
fi

# Regular expressions (only with [[]])
if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Valid email"
fi

# Logical operators
if [[ $age -gt 18 && $country == "US" ]]; then
    echo "Eligible"
fi
```

**File Test Operators:**

```bash
#!/bin/bash

FILE="config.txt"

# File existence and type
[[ -e $FILE ]] && echo "File exists"
[[ -f $FILE ]] && echo "Regular file"
[[ -d $FILE ]] && echo "Directory"
[[ -L $FILE ]] && echo "Symbolic link"

# Permissions
[[ -r $FILE ]] && echo "Readable"
[[ -w $FILE ]] && echo "Writable"
[[ -x $FILE ]] && echo "Executable"

# File properties
[[ -s $FILE ]] && echo "File is not empty"
[[ -O $FILE ]] && echo "You own this file"

# Comparisons
FILE1="file1.txt"
FILE2="file2.txt"

[[ $FILE1 -nt $FILE2 ]] && echo "$FILE1 is newer than $FILE2"
[[ $FILE1 -ot $FILE2 ]] && echo "$FILE1 is older than $FILE2"
```

---

### Functions and Script Organization

**Why Functions Matter in Shell Scripting:**

Functions are the building blocks of maintainable scripts. They help you:
- **Avoid repetition** (DRY principle: Don't Repeat Yourself)
- **Organize code** into logical, reusable chunks
- **Test easily** by isolating functionality
- **Debug faster** by narrowing down problems
- **Scale scripts** from simple to complex

**Real-World Analogy:** Think of functions like tools in a toolbox. Instead of buying a new hammer every time you need to drive a nail, you use the same hammer repeatedly. Functions work the same way—write once, use many times.

---

#### Function Basics

**Core Concept:** A function is a named block of code that performs a specific task. You define it once and call it whenever needed.

**Two Ways to Declare Functions:**

**Function Declaration:**

```bash
#!/bin/bash

# Method 1: Traditional syntax
function greet {
    echo "Hello, World!"
}

# Method 2: POSIX syntax (preferred)
greet() {
    echo "Hello, World!"
}

# Call the function
greet
```

**Functions with Parameters:**

```bash
#!/bin/bash

# Function with arguments
greet_user() {
    local name=$1
    local role=$2
    
    echo "Hello, $name!"
    echo "Welcome, $role"
}

# Call with arguments
greet_user "Alice" "DevOps Engineer"
greet_user "Bob" "SRE"
```

**Return Values:**

```bash
#!/bin/bash

# Functions can return exit status (0-255)
check_service() {
    local service=$1
    
    if systemctl is-active --quiet "$service"; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Use return value
if check_service nginx; then
    echo "Nginx is running"
else
    echo "Nginx is not running"
fi

# Capture output instead
get_timestamp() {
    date +%Y-%m-%d_%H-%M-%S
}

# Call and capture
timestamp=$(get_timestamp)
echo "Current timestamp: $timestamp"
```

---

#### Variable Scope

**Local vs Global Variables:**

```bash
#!/bin/bash

# Global variable
GLOBAL_VAR="I'm global"

demo_scope() {
    # Local variable (only exists in function)
    local LOCAL_VAR="I'm local"
    
    # Modify global
    GLOBAL_VAR="Modified in function"
    
    echo "Inside function:"
    echo "  Global: $GLOBAL_VAR"
    echo "  Local: $LOCAL_VAR"
}

echo "Before function:"
echo "  Global: $GLOBAL_VAR"

demo_scope

echo "After function:"
echo "  Global: $GLOBAL_VAR"
# echo "  Local: $LOCAL_VAR"  # This would be empty
```

**Best Practice Example:**

```bash
#!/bin/bash

# Configuration (global constants)
readonly APP_NAME="MyApp"
readonly VERSION="1.0.0"

# Function with proper scoping
deploy_application() {
    local environment=$1
    local version=$2
    local deploy_dir="/opt/apps/$APP_NAME"
    
    echo "Deploying $APP_NAME v$version to $environment"
    echo "Deploy directory: $deploy_dir"
    
    # Local work
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="${deploy_dir}_backup_${timestamp}"
    
    echo "Backup directory: $backup_dir"
}

deploy_application "production" "$VERSION"
```

---

#### Code Organization Best Practices

**Modular Script Structure:**

```bash
#!/bin/bash
#
# Script: deployment_manager.sh
# Description: Automated deployment system
# Author: Akil Tipu
# Date: 2025-11-30
# Version: 1.0.0
#

set -euo pipefail

#==========================================
# CONFIGURATION
#==========================================

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="/var/log/deployment.log"
readonly CONFIG_FILE="${SCRIPT_DIR}/config.conf"

#==========================================
# UTILITY FUNCTIONS
#==========================================

log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$LOG_FILE" >&2
}

error_exit() {
    log_error "$1"
    exit 1
}

#==========================================
# BUSINESS LOGIC FUNCTIONS
#==========================================

validate_environment() {
    local env=$1
    case $env in
        dev|staging|production)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

backup_current_version() {
    local app_dir=$1
    local backup_dir="${app_dir}_backup_$(date +%Y%m%d_%H%M%S)"
    
    log_info "Creating backup: $backup_dir"
    cp -r "$app_dir" "$backup_dir"
}

deploy() {
    local environment=$1
    local version=$2
    
    log_info "Starting deployment to $environment"
    log_info "Version: $version"
    
    # Validate
    validate_environment "$environment" || error_exit "Invalid environment"
    
    # Backup
    backup_current_version "/opt/myapp"
    
    # Deploy logic here
    log_info "Deployment completed successfully"
}

#==========================================
# MAIN FUNCTION
#==========================================

main() {
    # Parse arguments
    if [ $# -lt 2 ]; then
        echo "Usage: $0 <environment> <version>"
        exit 1
    fi
    
    local environment=$1
    local version=$2
    
    # Execute deployment
    deploy "$environment" "$version"
}

#==========================================
# SCRIPT ENTRY POINT
#==========================================

main "$@"
```

---

### File and Directory Handling

#### File Operations

**Reading Files:**

```bash
#!/bin/bash

# Method 1: Read entire file
content=$(cat file.txt)
echo "$content"

# Method 2: Read line by line
while IFS= read -r line; do
    echo "Line: $line"
done < file.txt

# Method 3: Read into array
mapfile -t lines < file.txt
echo "Total lines: ${#lines[@]}"

# Method 4: Process with conditions
while IFS= read -r line; do
    if [[ $line == ERROR* ]]; then
        echo "Error found: $line"
    fi
done < logfile.log
```

**Writing to Files:**

```bash
#!/bin/bash

# Overwrite file
echo "New content" > file.txt

# Append to file
echo "More content" >> file.txt

# Write multiple lines
cat > config.txt << EOF
server=localhost
port=8080
timeout=30
EOF

# Write with variables
cat > dynamic.conf << EOF
# Generated at: $(date)
hostname=$(hostname)
user=$(whoami)
EOF
```

**File Manipulation:**

```bash
#!/bin/bash

# Copy
cp source.txt destination.txt
cp -r source_dir/ destination_dir/

# Move/Rename
mv oldname.txt newname.txt
mv file.txt /new/location/

# Delete
rm file.txt
rm -rf directory/

# Check before operations
if [ -f "important.txt" ]; then
    cp important.txt "backup_$(date +%Y%m%d).txt"
fi
```

---

#### Directory Operations

**Directory Management:**

```bash
#!/bin/bash

# Create directory
mkdir mydir
mkdir -p path/to/nested/dir  # Create parent directories

# Change directory
cd /path/to/dir
cd ..  # Parent
cd ~   # Home
cd -   # Previous directory

# Remove directory
rmdir empty_dir  # Only if empty
rm -rf directory  # Force remove with contents

# List contents
ls
ls -la  # Detailed list with hidden files
ls -lh  # Human-readable sizes
```

**Working with Paths:**

```bash
#!/bin/bash

# Current directory
current_dir=$(pwd)
echo "Current: $current_dir"

# Script directory
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Script location: $script_dir"

# Parent directory
parent_dir="$(dirname "$current_dir")"
echo "Parent: $parent_dir"

# Basename (filename only)
filepath="/path/to/file.txt"
filename=$(basename "$filepath")
echo "Filename: $filename"  # file.txt

# Directory name
dirpath=$(dirname "$filepath")
echo "Directory: $dirpath"  # /path/to
```

**Directory Traversal:**

```bash
#!/bin/bash

# Find all .log files
find /var/log -name "*.log" -type f

# Find and process
find . -name "*.txt" -type f | while read -r file; do
    echo "Processing: $file"
    # Do something with $file
done

# Find with size filter
find . -name "*.log" -size +10M

# Find modified in last 7 days
find . -name "*.conf" -mtime -7

# Execute command on found files
find . -name "*.tmp" -type f -exec rm {} \;
```

---

#### Practical File Processing Examples

**Log File Analyzer:**

```bash
#!/bin/bash

LOG_FILE="/var/log/application.log"

echo "=== Log Analysis ==="

# Count total lines
total_lines=$(wc -l < "$LOG_FILE")
echo "Total lines: $total_lines"

# Count errors
error_count=$(grep -c "ERROR" "$LOG_FILE")
echo "Errors: $error_count"

# Count warnings
warning_count=$(grep -c "WARN" "$LOG_FILE")
echo "Warnings: $warning_count"

# Extract unique error messages
echo ""
echo "Unique Errors:"
grep "ERROR" "$LOG_FILE" | awk -F': ' '{print $2}' | sort -u

# Find most common errors
echo ""
echo "Most Common Errors:"
grep "ERROR" "$LOG_FILE" | awk -F': ' '{print $2}' | sort | uniq -c | sort -rn | head -5
```

**Backup Script:**

```bash
#!/bin/bash

# Configuration
SOURCE_DIR="/var/www/html"
BACKUP_DIR="/backup"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="website_backup_${DATE}.tar.gz"
KEEP_DAYS=7

# Create backup
echo "Creating backup..."
tar -czf "${BACKUP_DIR}/${BACKUP_NAME}" "$SOURCE_DIR"

if [ $? -eq 0 ]; then
    echo "Backup created: $BACKUP_NAME"
    
    # Remove old backups
    echo "Cleaning old backups (older than $KEEP_DAYS days)..."
    find "$BACKUP_DIR" -name "website_backup_*.tar.gz" -mtime +$KEEP_DAYS -delete
    
    echo "Backup completed successfully"
else
    echo "Backup failed!"
    exit 1
fi
```

---

## Hands-On Demo Scripts Guide

Now that you understand the theory, it's time to practice! This section provides detailed walkthroughs for each demo script included in class02.

### Demo Script 1: control_structures.sh

** Purpose:** Master advanced control structures including case statements, pattern matching, and file testing.

**🎓 Learning Objectives:**
- Understand when to use case vs if-elif-else
- Learn pattern matching with wildcards
- Master file test operators
- Implement environment-based configuration
- Use regular expressions in conditionals

**📂 File:** `control_structures.sh` (276 lines)

**🔍 What's Inside:**

This script demonstrates **8 different control structure patterns**:

1. **Basic Case Statement** - Menu system with numbered choices
2. **Pattern Matching** - Handle different file types (*.txt, *.sh, *.log)
3. **Environment Configuration** - dev/staging/prod environment setup
4. **Double Bracket Conditionals** - Advanced test syntax with regex
5. **Multiple Conditions** - Combining AND/OR logic
6. **File Testing** - Check file existence, permissions, type
7. **Nested Conditionals** - Server status checks with inner logic
8. **Reference Table** - Complete operator cheat sheet

**👨‍🏫 How to Use This Script:**

**Step 1: Make it executable**
```bash
chmod +x control_structures.sh
```

**Step 2: Run it**
```bash
./control_structures.sh
```

**Step 3: Interact with prompts**
```
The script will ask you for inputs:
- Enter menu choices (1-4)
- Enter filenames to test pattern matching
- Enter environment names
- Enter usernames and ages for validation
```

**Step 4: Observe the outputs**
```
Watch how:
- Case statements route to different actions
- Patterns match file extensions
- Conditionals validate inputs
- File tests check properties
```

**🔑 Key Takeaways:**

```bash
# When to use CASE vs IF
case $var in          # Use for: Multiple exact matches, patterns
  pattern) ;;
esac

if [[ condition ]];   # Use for: Complex conditions, ranges, logic
```

**💡 Try These Modifications:**

1. Add a new case for `.json` files in section 2
2. Add a `qa` environment in section 3
3. Change the file test in section 6 to check your own file
4. Add validation for email addresses using regex

**📚 Related Concepts:** This script practices topics from the "Control Structures" section of the README.

---

### Demo Script 2: functions_demo.sh

**📝 Purpose:** Learn function fundamentals including declaration, parameters, scope, and return values.

**🎓 Learning Objectives:**
- Declare functions using both syntaxes
- Pass parameters to functions
- Understand local vs global scope
- Return values and capture output
- Create validation functions
- Implement recursive functions
- Build utility function libraries

**📂 File:** `functions_demo.sh` (402 lines)

**🔍 What's Inside:**

This script demonstrates **15 function patterns**:

1. **Basic Declaration** - Two ways to define functions
2. **Parameters** - Passing arguments to functions
3. **Parameter Access** - Using $1, $2, $@, $#
4. **Return Values** - Exit codes (0-255)
5. **Output Capture** - Using $() to get function output
6. **Variable Scope** - Local vs global variables
7. **Default Values** - Parameter defaults with ${var:-default}
8. **Validation** - Input checking functions
9. **Recursion** - Functions calling themselves
10. **Utility Functions** - Logging helpers
11. **Array Processing** - Functions with array parameters
12. **Error Handling** - Returning error codes
13. **Practical Example** - Health check function
14. **Function Library** - Reusable system info functions
15. **Best Practices** - Coding standards summary

**👨‍🏫 How to Use This Script:**

**Step 1: Run it**
```bash
chmod +x functions_demo.sh
./functions_demo.sh
```

**Step 2: Watch the auto-demo**
```
The script runs automatically, showing:
- Function calls and outputs
- Scope demonstrations
- Validation examples
- Recursive countdown
```

**Step 3: Study the code**
```bash
# Open in editor to see implementation
code functions_demo.sh

# Focus on these sections:
# - Lines 1-40: Basic declarations
# - Lines 60-85: Return values
# - Lines 90-110: Scope demo
# - Lines 300-350: Best practices
```

** Key Takeaways:**

```bash
# Function Anatomy
function_name() {           # Declaration
    local var=$1            # Local variable from parameter
    echo "output"           # Send output to stdout
    return 0                # Return exit code
}

# Calling functions
result=$(function_name "arg")   # Capture output
function_name "arg"             # Just run it
if function_name "arg"; then    # Check return code
```

** Try These Modifications:**

1. Add a function to check if a number is prime
2. Create a `log_critical()` function
3. Build a `validate_phone_number()` function
4. Make a recursive function to calculate Fibonacci numbers
5. Add a function that counts words in a file

** Related Concepts:** This script practices topics from the "Functions and Script Organization" section.

---

### Demo Script 3: file_operations.sh

** Purpose:** Master file and directory operations essential for DevOps automation.

**🎓 Learning Objectives:**
- Create, read, and write files
- Manipulate file permissions
- Work with directories
- Process multiple files
- Handle paths and archives
- Implement file rotation
- Clean up old files

** File:** `file_operations.sh` (380 lines)

** What's Inside:**

This script demonstrates **20 file operation patterns**:

1. **Creating Files** - touch, echo, cat methods
2. **Reading Files** - cat, while read, mapfile
3. **Writing Files** - Overwrite vs append
4. **File Information** - stat, permissions, owner
5. **Copying Files** - cp with options
6. **Moving/Renaming** - mv operations
7. **Deleting Files** - rm safely
8. **Directory Operations** - mkdir, cd, ls
9. **Navigation** - pwd, cd tricks
10. **Directory Info** - Counting contents
11. **Searching Files** - find command patterns
12. **Advanced Find** - Conditions and filters
13. **Processing Multiple Files** - Loops with files
14. **Bulk Operations** - Renaming, batch processing
15. **File Permissions** - chmod demonstrations
16. **Path Operations** - basename, dirname
17. **Temporary Files** - mktemp usage
18. **File Comparisons** - cmp, diff
19. **Archives** - tar and gzip
20. **Log Rotation** - Practical example

**How to Use This Script:**

**Step 1: Run in a safe directory**
```bash
# Create a test directory first!
mkdir ~/test_file_ops
cd ~/test_file_ops

# Copy script here
cp /path/to/file_operations.sh .
chmod +x file_operations.sh

# Run it
./file_operations.sh
```

**Step 2: Watch file creation**
```
The script creates demo files:
- greeting.txt
- config.txt
- output.txt
- test_*.txt files
- backup.tar.gz

All are automatically cleaned up at the end
```

**Step 3: Check intermediate results**
```bash
# Run script in steps by commenting out sections
# Add 'exit 0' after any section to stop early
```

**Key Takeaways:**

```bash
# File Operations Cheat Sheet
touch file.txt                    # Create empty file
echo "content" > file.txt         # Overwrite file
echo "more" >> file.txt           # Append to file
cat file.txt                      # Read file
cp source dest                    # Copy file
mv source dest                    # Move/rename
rm file.txt                       # Delete file
chmod +x file.sh                  # Make executable
find . -name "*.log" -type f      # Find files
tar -czf backup.tar.gz files/     # Create archive
```

**Try These Modifications:**

1. Add a function to count lines in all .sh files
2. Create a backup script that compresses and dates files
3. Build a cleanup script for /tmp files older than 7 days
4. Make a script that organizes files by extension
5. Create a disk usage reporter for a directory

**Related Concepts:** This script practices topics from the "File and Directory Handling" section.



### Practical Examples

Now that we've covered the theory, let's dive into practical, real-world examples. Each example builds on the concepts we've learned and demonstrates how to apply them in DevOps scenarios.

---

#### Practical Example 1: Advanced Conditional Scripting

**What You'll Learn:**
- How to implement system health monitoring
- Using colors for better output readability
- Implementing threshold-based alerts
- Combining multiple conditionals for complex logic
- Real-world decision-making patterns

**Use Case:** A production system health monitor that checks CPU, memory, and disk usage, alerting operators when thresholds are exceeded.

**Step-by-Step Walkthrough:**

Before we look at the code, let's understand what this script does:

1. **Sets up strict mode** (`set -euo pipefail`) to catch errors early
2. **Defines color codes** for visual feedback (green=good, yellow=warning, red=critical)
3. **Establishes thresholds** for system resources
4. **Creates check functions** that return different exit codes based on severity
5. **Uses conditionals** to determine appropriate responses

**Key Concepts Used:**
- Function declaration and return values
- Conditional logic with multiple branches
- Color-coded output for better UX
- Exit codes for status reporting
- Command substitution for system metrics

**Script File:** `practical_conditionals.sh`

Create this file to implement the health monitoring system:

```bash
#!/bin/bash
#
# System Health Check with Advanced Conditionals
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=85

# Check CPU usage
check_cpu() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    
    echo -n "CPU Usage: ${cpu_usage}% - "
    
    if (( $(echo "$cpu_usage < 50" | bc -l) )); then
        echo -e "${GREEN}NORMAL${NC}"
        return 0
    elif (( $(echo "$cpu_usage < $CPU_THRESHOLD" | bc -l) )); then
        echo -e "${YELLOW}WARNING${NC}"
        return 1
    else
        echo -e "${RED}CRITICAL${NC}"
        return 2
    fi
}

# Check memory usage
check_memory() {
    local mem_usage=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')
    
    echo -n "Memory Usage: ${mem_usage}% - "
    
    case $mem_usage in
        [0-4][0-9]|50)
            echo -e "${GREEN}NORMAL${NC}"
            return 0
            ;;
        5[1-9]|6[0-9]|7[0-9])
            echo -e "${YELLOW}WARNING${NC}"
            return 1
            ;;
        *)
            echo -e "${RED}CRITICAL${NC}"
            return 2
            ;;
    esac
}

# Check disk usage
check_disk() {
    local disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    
    echo -n "Disk Usage: ${disk_usage}% - "
    
    if [[ $disk_usage -lt 70 ]]; then
        echo -e "${GREEN}NORMAL${NC}"
        return 0
    elif [[ $disk_usage -lt $DISK_THRESHOLD ]]; then
        echo -e "${YELLOW}WARNING${NC}"
        return 1
    else
        echo -e "${RED}CRITICAL${NC}"
        return 2
    fi
}

# Check service status
check_service() {
    local service=$1
    
    echo -n "Service $service: "
    
    if systemctl is-active --quiet "$service" 2>/dev/null; then
        echo -e "${GREEN}RUNNING${NC}"
        return 0
    elif systemctl is-enabled --quiet "$service" 2>/dev/null; then
        echo -e "${YELLOW}STOPPED (but enabled)${NC}"
        return 1
    else
        echo -e "${RED}NOT INSTALLED${NC}"
        return 2
    fi
}

# Main health check
main() {
    echo "======================================="
    echo "     SYSTEM HEALTH CHECK"
    echo "======================================="
    echo ""
    
    check_cpu
    check_memory
    check_disk
    
    echo ""
    echo "Service Status:"
    check_service "sshd" || true
    check_service "nginx" || true
    check_service "docker" || true
    
    echo ""
    echo "Check completed at: $(date)"
}

main
```

**How to Run:**
```bash
chmod +x practical_conditionals.sh
./practical_conditionals.sh
```

**What Happens When You Run It:**

1. **Initialization Phase:**
   - Script enters strict mode (exits on errors)
   - Color codes and thresholds are set up
   - Functions are defined (but not executed yet)

2. **Execution Phase:**
   - `main()` function is called
   - Each check function runs in sequence
   - System commands (top, free, df) gather metrics
   - Conditionals compare metrics against thresholds
   - Appropriate colored output is displayed

3. **Status Reporting:**
   - Each check returns 0 (OK), 1 (Warning), or 2 (Critical)
   - The `|| true` prevents script exit on non-zero returns
   - Final timestamp shows when check completed

**Key Learning Points:**

| Concept | What It Teaches | Line Example |
|---------|----------------|--------------|
| `set -euo pipefail` | Error handling best practice | Line 7 |
| Color codes | User-friendly output | Lines 9-12 |
| `local` variables | Proper variable scoping | Line 20 |
| Arithmetic comparison | Using `bc` for decimals | Line 24 |
| Case patterns | Range matching | Lines 51-59 |
| Double brackets | Modern test syntax | Line 68 |
| `|| true` | Preventing exit on failure | Line 121 |

**Exercise Questions:**
1. What happens if you remove `set -e`?
2. Why use `local` for variables inside functions?
3. How would you add email alerts for CRITICAL status?
4. Can you add a network connectivity check?

---

#### Practical Example 2: Advanced Looping Constructs

**What You'll Learn:**
- Multi-server deployment patterns
- Sequential vs parallel execution
- Retry mechanisms with backoff
- Loop control (break, continue)
- Progress tracking and reporting
- Processing arrays and files

**Use Case:** Deploying an application to multiple servers with retry logic, progress tracking, and comprehensive error handling.

**Step-by-Step Walkthrough:**

This script demonstrates real-world deployment automation:

1. **Array Management:** Stores server lists in indexed arrays
2. **Associative Arrays:** Maps services to ports (key-value pairs)
3. **Sequential Deployment:** Processes servers one at a time
4. **Parallel Deployment:** Launches multiple deployments simultaneously
5. **Retry Logic:** Implements exponential backoff for failed connections
6. **Progress Tracking:** Shows current position in deployment queue

**Key Concepts Used:**
- Indexed arrays for lists (`SERVERS=("web01" "web02")`)
- Associative arrays for mappings (`declare -A SERVICE_PORTS`)
- For loops with array indices (`"${!SERVERS[@]}"`)
- While loops for retry logic
- Background processes (`&` and `wait`)
- Loop counters for tracking
- Break and continue for flow control

**Script File:** `practical_loops.sh`

Create this file to see advanced looping in action:

```bash
#!/bin/bash
#
# Multi-Server Deployment with Advanced Loops
#

set -euo pipefail

# Server list
declare -a SERVERS=(
    "web01.example.com"
    "web02.example.com"
    "api01.example.com"
    "api02.example.com"
)

# Port mapping
declare -A SERVICE_PORTS=(
    [web]=8080
    [api]=3000
    [db]=5432
)

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Simulate SSH connection
connect_server() {
    local server=$1
    # Simulate connection (replace with real SSH)
    sleep 1
    return 0
}

# Deploy to single server
deploy_to_server() {
    local server=$1
    local attempt=1
    local max_attempts=3
    
    log "Deploying to $server..."
    
    while [ $attempt -le $max_attempts ]; do
        log "  Attempt $attempt of $max_attempts"
        
        if connect_server "$server"; then
            log "  ✓ Successfully deployed to $server"
            return 0
        else
            log "  ✗ Connection failed"
            
            if [ $attempt -lt $max_attempts ]; then
                log "  Retrying in 5 seconds..."
                sleep 5
            fi
        fi
        
        ((attempt++))
    done
    
    log "  FAILED: Could not deploy to $server after $max_attempts attempts"
    return 1
}

# Check service ports
check_ports() {
    log "Checking service ports..."
    
    for service in "${!SERVICE_PORTS[@]}"; do
        local port=${SERVICE_PORTS[$service]}
        log "  $service: port $port"
        # Add actual port check here
    done
}

# Parallel deployment simulation
deploy_all_parallel() {
    log "Starting parallel deployment..."
    
    local pids=()
    
    for server in "${SERVERS[@]}"; do
        deploy_to_server "$server" &
        pids+=($!)
    done
    
    # Wait for all deployments
    local failed=0
    for pid in "${pids[@]}"; do
        if ! wait "$pid"; then
            ((failed++))
        fi
    done
    
    if [ $failed -eq 0 ]; then
        log "All deployments completed successfully"
        return 0
    else
        log "WARNING: $failed deployment(s) failed"
        return 1
    fi
}

# Sequential deployment with status tracking
deploy_all_sequential() {
    log "Starting sequential deployment..."
    
    local success_count=0
    local fail_count=0
    local total=${#SERVERS[@]}
    
    for i in "${!SERVERS[@]}"; do
        local server="${SERVERS[$i]}"
        local progress=$((i + 1))
        
        log "[$progress/$total] Processing $server"
        
        if deploy_to_server "$server"; then
            ((success_count++))
        else
            ((fail_count++))
        fi
        
        echo ""
    done
    
    log "========================================="
    log "Deployment Summary:"
    log "  Total: $total"
    log "  Success: $success_count"
    log "  Failed: $fail_count"
    log "========================================="
    
    [ $fail_count -eq 0 ]
}

# Process configuration files
process_configs() {
    log "Processing configuration files..."
    
    # Find all config files
    while IFS= read -r -d '' config_file; do
        log "  Processing: $config_file"
        
        # Read and validate config
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ $key =~ ^#.*$ || -z $key ]] && continue
            
            log "    $key = $value"
        done < "$config_file"
        
    done < <(find . -name "*.conf" -type f -print0)
}

# Menu system with loop
interactive_menu() {
    while true; do
        echo ""
        echo "======================================="
        echo "       DEPLOYMENT MANAGER"
        echo "======================================="
        echo "1. Deploy to all servers (sequential)"
        echo "2. Deploy to all servers (parallel)"
        echo "3. Check service ports"
        echo "4. Process configurations"
        echo "5. Exit"
        echo "======================================="
        read -p "Select option [1-5]: " choice
        
        case $choice in
            1)
                deploy_all_sequential
                ;;
            2)
                deploy_all_parallel
                ;;
            3)
                check_ports
                ;;
            4)
                process_configs
                ;;
            5)
                log "Exiting..."
                break
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
    done
}

# Main execution
main() {
    if [ $# -eq 0 ]; then
        interactive_menu
    else
        case $1 in
            sequential)
                deploy_all_sequential
                ;;
            parallel)
                deploy_all_parallel
                ;;
            *)
                echo "Usage: $0 {sequential|parallel}"
                echo "Or run without arguments for interactive menu"
                exit 1
                ;;
        esac
    fi
}

main "$@"
```

**How to Run:**
```bash
chmod +x practical_loops.sh

# Interactive mode (shows menu)
./practical_loops.sh

# Direct sequential deployment
./practical_loops.sh sequential

# Direct parallel deployment
./practical_loops.sh parallel
```

**What Happens When You Run It:**

1. **Array Initialization:**
   - Server list loaded into indexed array
   - Service ports mapped in associative array
   - Both data structures ready for iteration

2. **Sequential Deployment (Option 1):**
   - Loops through servers one by one
   - Attempts deployment with retry logic
   - Tracks success/failure counts
   - Shows progress (e.g., "[3/4] Processing...")
   - Waits for each to complete before next

3. **Parallel Deployment (Option 2):**
   - Starts all deployments at once (background &)
   - Stores process IDs in array
   - Waits for all processes to complete
   - Reports overall success/failure

4. **Retry Mechanism:**
   - While loop with attempt counter
   - Exponential backoff (2^attempt seconds)
   - Logs each attempt
   - Returns 0 on success, 1 on failure

**Key Learning Points:**

| Technique | Purpose | Example in Script |
|-----------|---------|-------------------|
| `declare -a` | Create indexed array | Line 11 |
| `declare -A` | Create associative array | Line 18 |
| `${!array[@]}` | Get array indices | Line 83 |
| `${#array[@]}` | Get array length | Line 84 |
| `&` operator | Run in background | Line 142 |
| `wait $pid` | Wait for process | Line 149 |
| Exponential backoff | Smart retry timing | Line 68 |
| `while true` | Infinite loop | Line 309 |

**Comparison: Sequential vs Parallel**

```
Sequential:
  web01 -> deploy (10s)
  web02 -> deploy (10s)  
  web03 -> deploy (10s)
  Total: 30 seconds

Parallel:
  web01, web02, web03 -> all deploy simultaneously
  Total: 10 seconds (faster but less control)
```

**Exercise Questions:**
1. What's the trade-off between sequential and parallel deployment?
2. Why use exponential backoff instead of fixed delays?
3. How would you add a maximum concurrent limit for parallel?
4. Can you implement a "rolling deployment" (deploy 2 at a time)?

---

#### Practical Example 3: Function Usage in DevOps

**What You'll Learn:**
- Creating reusable function libraries
- Professional logging system
- Input validation patterns
- System information gathering
- File operation utilities
- Network checking functions
- Deployment helper functions
- Health monitoring utilities

**Use Case:** A comprehensive DevOps function library that can be sourced by other scripts, providing common utilities for logging, validation, system checks, and more.

**Step-by-Step Walkthrough:**

This script is different—it's a **library** not a standalone script:

1. **Library Pattern:** Functions are defined but not automatically executed
2. **Source-able:** Other scripts can use `source practical_functions.sh`
3. **Organized by Category:** Related functions grouped together
4. **Consistent Naming:** All functions follow naming conventions
5. **Well Documented:** Each function has clear purpose
6. **Reusable:** Functions work independently

**Key Concepts Used:**
- Function libraries and sourcing
- Readonly variables for constants
- Local scope for all function variables
- Consistent error handling
- Return codes for success/failure
- Parameter validation
- Command substitution for system info
- Logging abstraction

**Script File:** `practical_functions.sh`

Create this file to build your DevOps utility library:

```bash
#!/bin/bash
#
# DevOps Utility Library
# Demonstrates professional function usage
#

set -euo pipefail

#==========================================
# LOGGING FUNCTIONS
#==========================================

readonly LOG_FILE="/tmp/devops_$(date +%Y%m%d).log"

log_message() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

log_info() {
    log_message "INFO" "$@"
}

log_warn() {
    log_message "WARN" "$@"
}

log_error() {
    log_message "ERROR" "$@" >&2
}

log_success() {
    log_message "SUCCESS" "$@"
}

#==========================================
# VALIDATION FUNCTIONS
#==========================================

validate_not_empty() {
    local value=$1
    local field_name=$2
    
    if [ -z "$value" ]; then
        log_error "$field_name cannot be empty"
        return 1
    fi
    return 0
}

validate_number() {
    local value=$1
    local field_name=$2
    
    if ! [[ $value =~ ^[0-9]+$ ]]; then
        log_error "$field_name must be a number"
        return 1
    fi
    return 0
}

validate_ip_address() {
    local ip=$1
    
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 0
    else
        log_error "Invalid IP address: $ip"
        return 1
    fi
}

validate_email() {
    local email=$1
    
    if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        log_error "Invalid email: $email"
        return 1
    fi
}

#==========================================
# SYSTEM FUNCTIONS
#==========================================

get_system_info() {
    local info_type=$1
    
    case $info_type in
        os)
            uname -s
            ;;
        hostname)
            hostname
            ;;
        cpu_count)
            nproc
            ;;
        memory_total)
            free -h | awk '/^Mem:/ {print $2}'
            ;;
        uptime)
            uptime -p
            ;;
        *)
            echo "Unknown info type: $info_type"
            return 1
            ;;
    esac
}

display_system_info() {
    log_info "System Information:"
    echo "  OS: $(get_system_info os)"
    echo "  Hostname: $(get_system_info hostname)"
    echo "  CPUs: $(get_system_info cpu_count)"
    echo "  Memory: $(get_system_info memory_total)"
    echo "  Uptime: $(get_system_info uptime)"
}

#==========================================
# FILE OPERATIONS
#==========================================

backup_file() {
    local file=$1
    local backup_dir=${2:-./backups}
    
    if [ ! -f "$file" ]; then
        log_error "File not found: $file"
        return 1
    fi
    
    mkdir -p "$backup_dir"
    
    local filename=$(basename "$file")
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="${backup_dir}/${filename}.${timestamp}.bak"
    
    if cp "$file" "$backup_file"; then
        log_success "Backed up $file to $backup_file"
        echo "$backup_file"
        return 0
    else
        log_error "Failed to backup $file"
        return 1
    fi
}

rotate_logs() {
    local log_file=$1
    local max_size_mb=${2:-100}
    local max_files=${3:-5}
    
    if [ ! -f "$log_file" ]; then
        return 0
    fi
    
    local file_size_mb=$(du -m "$log_file" | cut -f1)
    
    if [ "$file_size_mb" -ge "$max_size_mb" ]; then
        log_info "Rotating log: $log_file (${file_size_mb}MB)"
        
        # Remove oldest backup if max reached
        local backup_count=$(ls -1 "${log_file}".* 2>/dev/null | wc -l)
        if [ "$backup_count" -ge "$max_files" ]; then
            oldest=$(ls -1t "${log_file}".* | tail -1)
            rm "$oldest"
            log_info "Removed oldest backup: $oldest"
        fi
        
        # Rotate
        mv "$log_file" "${log_file}.$(date +%Y%m%d_%H%M%S)"
        touch "$log_file"
        log_success "Log rotated successfully"
    fi
}

#==========================================
# DEPLOYMENT FUNCTIONS
#==========================================

check_prerequisites() {
    local -a required_commands=("$@")
    local missing=()
    
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing required commands: ${missing[*]}"
        return 1
    fi
    
    log_success "All prerequisites satisfied"
    return 0
}

download_artifact() {
    local url=$1
    local destination=$2
    local max_retries=${3:-3}
    
    local attempt=1
    
    while [ $attempt -le $max_retries ]; do
        log_info "Downloading (attempt $attempt/$max_retries)..."
        log_info "  URL: $url"
        log_info "  Destination: $destination"
        
        if curl -fsSL -o "$destination" "$url"; then
            log_success "Download completed"
            return 0
        else
            log_warn "Download failed"
            
            if [ $attempt -lt $max_retries ]; then
                sleep $((attempt * 2))
            fi
        fi
        
        ((attempt++))
    done
    
    log_error "Download failed after $max_retries attempts"
    return 1
}

verify_checksum() {
    local file=$1
    local expected_checksum=$2
    local algorithm=${3:-sha256}
    
    log_info "Verifying checksum..."
    
    local actual_checksum
    case $algorithm in
        md5)
            actual_checksum=$(md5sum "$file" | awk '{print $1}')
            ;;
        sha256)
            actual_checksum=$(sha256sum "$file" | awk '{print $1}')
            ;;
        *)
            log_error "Unsupported algorithm: $algorithm"
            return 1
            ;;
    esac
    
    if [ "$actual_checksum" = "$expected_checksum" ]; then
        log_success "Checksum verified"
        return 0
    else
        log_error "Checksum mismatch!"
        log_error "  Expected: $expected_checksum"
        log_error "  Actual: $actual_checksum"
        return 1
    fi
}

#==========================================
# NOTIFICATION FUNCTIONS
#==========================================

send_notification() {
    local title=$1
    local message=$2
    local level=${3:-info}
    
    # Placeholder for actual notification system
    log_info "NOTIFICATION [$level]: $title - $message"
    
    # Example integrations:
    # - Slack webhook
    # - Email
    # - PagerDuty
    # - Teams webhook
}

notify_success() {
    send_notification "Success" "$1" "success"
}

notify_failure() {
    send_notification "Failure" "$1" "error"
}

#==========================================
# DEMO USAGE
#==========================================

demo_usage() {
    echo "========================================="
    echo "  DevOps Function Library Demo"
    echo "========================================="
    echo ""
    
    # Logging demo
    log_info "Starting demo..."
    log_warn "This is a warning"
    log_error "This is an error"
    log_success "This is a success message"
    
    echo ""
    
    # System info
    display_system_info
    
    echo ""
    
    # Validation demo
    log_info "Testing validation functions..."
    validate_not_empty "test" "Test Field" && echo "  ✓ Not empty validation passed"
    validate_number "123" "Age" && echo "  ✓ Number validation passed"
    validate_ip_address "192.168.1.1" && echo "  ✓ IP validation passed"
    validate_email "user@example.com" && echo "  ✓ Email validation passed"
    
    echo ""
    
    # Prerequisites check
    check_prerequisites "bash" "awk" "sed" "grep"
    
    echo ""
    log_success "Demo completed!"
}

#==========================================
# MAIN
#==========================================

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    # Script is being executed directly
    demo_usage
else
    # Script is being sourced
    log_info "DevOps function library loaded"
fi
```

---

### Wrap-up & Best Practices

#### Key Takeaways

```
Class 02 Summary:

Core Features:
  ✓ Exit status and error handling
  ✓ Command line arguments
  ✓ Arrays and data structures

Control Structures:
  ✓ Case statements
  ✓ Advanced conditionals
  ✓ Pattern matching

Functions:
  ✓ Function declaration and parameters
  ✓ Return values and scope
  ✓ Modular code organization

File Operations:
  ✓ Reading and writing files
  ✓ Directory management
  ✓ File processing patterns
```

---

#### Professional Shell Scripting Checklist

```bash
#!/bin/bash
#
# Professional Script Template
# Author: [Your Name]
# Date: [Date]
# Description: [What this script does]
#

# 1. Strict mode
set -euo pipefail

# 2. Constants
readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 3. Configuration
CONFIG_FILE="${SCRIPT_DIR}/config.conf"
LOG_FILE="/var/log/${SCRIPT_NAME}.log"

# 4. Utility functions
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

error_exit() {
    log "ERROR: $1"
    exit 1
}

# 5. Cleanup function
cleanup() {
    log "Cleaning up..."
    # Remove temp files, etc.
}

trap cleanup EXIT

# 6. Validation
validate_args() {
    if [ $# -lt 1 ]; then
        echo "Usage: $SCRIPT_NAME <argument>"
        exit 1
    fi
}

# 7. Main logic
main() {
    validate_args "$@"
    
    log "Starting $SCRIPT_NAME"
    
    # Your script logic here
    
    log "Completed successfully"
}

# 8. Execute
main "$@"
```

---

#### Homework Assignment

**Create a "DevOps Automation Suite"**

Requirements:
```bash
# Script: devops_suite.sh

# 1. Implement these functions:
#    - System health monitoring
#    - Log analysis and rotation
#    - Backup management
#    - Service management

# 2. Use proper:
#    - Error handling
#    - Logging
#    - Function organization
#    - Command line arguments

# 3. Features:
#    - Interactive menu
#    - Configuration file support
#    - Status reporting
#    - Email notifications (simulated)

# 4. Bonus:
#    - Parallel execution
#    - Progress indicators
#    - Colored output
#    - JSON configuration
```

---

#### Additional Resources

```
Learning Resources:
- Advanced Bash Guide: https://tldp.org/LDP/abs/html/
- ShellCheck: https://www.shellcheck.net/
- Bash Hackers Wiki: https://wiki.bash-hackers.org/
- Google Shell Style Guide: https://google.github.io/styleguide/shellguide.html

Practice Projects:
- Build a deployment pipeline script
- Create a log monitoring system
- Automate server provisioning
- Develop a backup rotation system

Next Class Preview:
- Advanced text processing (awk, sed)
- Process management
- Network operations
- Security best practices
```

---

## Message

```
"Excellent work completing Class 02!

You've mastered advanced shell scripting concepts that
separate beginners from professional DevOps engineers.

These functions and patterns you learned today are the
building blocks of production automation systems.

Keep building, keep automating, and remember:
Good code is maintainable code.

Ready for Class 03? Let's dive deeper!"
```

---

**Happy Scripting!**
