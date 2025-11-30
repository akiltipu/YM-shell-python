#!/bin/bash
# Advanced Control Structures Demo

echo "======================================="
echo "   ADVANCED CONTROL STRUCTURES"
echo "======================================="
echo ""

# ===== 1. CASE STATEMENT - BASIC =====
echo "=== 1. CASE Statement - Menu System ==="
echo "Enter your choice:"
echo "  1. Start service"
echo "  2. Stop service"
echo "  3. Restart service"
echo "  4. Check status"
read -p "Choice [1-4]: " choice

case $choice in
    1)
        echo "Starting service..."
        ;;
    2)
        echo "Stopping service..."
        ;;
    3)
        echo "Restarting service..."
        ;;
    4)
        echo "Checking service status..."
        ;;
    *)
        echo "Invalid choice!"
        ;;
esac
echo ""

# ===== 2. CASE WITH PATTERN MATCHING =====
echo "=== 2. CASE with Pattern Matching ==="
read -p "Enter a filename: " filename

case $filename in
    *.txt)
        echo "Text file detected"
        echo "Action: Open with text editor"
        ;;
    *.sh)
        echo "Shell script detected"
        echo "Action: Check for execute permissions"
        ;;
    *.log)
        echo "Log file detected"
        echo "Action: Display last 20 lines"
        ;;
    *.json|*.yaml|*.yml)
        echo "Configuration file detected"
        echo "Action: Validate syntax"
        ;;
    *.tar.gz|*.zip)
        echo "Archive file detected"
        echo "Action: Extract contents"
        ;;
    *)
        echo "Unknown file type"
        ;;
esac
echo ""

# ===== 3. ENVIRONMENT-BASED CONFIG =====
echo "=== 3. Environment-Based Configuration ==="
read -p "Enter environment (dev/staging/prod): " env

case $env in
    dev|development)
        DB_HOST="localhost"
        DB_PORT="3306"
        DEBUG="true"
        LOG_LEVEL="DEBUG"
        echo "Development Environment"
        ;;
    staging|stage)
        DB_HOST="staging-db.company.com"
        DB_PORT="3306"
        DEBUG="true"
        LOG_LEVEL="INFO"
        echo "Staging Environment"
        ;;
    prod|production)
        DB_HOST="prod-db.company.com"
        DB_PORT="3306"
        DEBUG="false"
        LOG_LEVEL="ERROR"
        echo "Production Environment"
        ;;
    *)
        echo "ERROR: Unknown environment '$env'"
        echo "Valid options: dev, staging, prod"
        exit 1
        ;;
esac

echo "Configuration:"
echo "  Database: $DB_HOST:$DB_PORT"
echo "  Debug Mode: $DEBUG"
echo "  Log Level: $LOG_LEVEL"
echo ""

# ===== 4. ADVANCED CONDITIONALS - DOUBLE BRACKETS =====
echo "=== 4. Advanced Conditionals with [[ ]] ==="

# String pattern matching
test_string="example.log"
if [[ $test_string == *.log ]]; then
    echo "✓ Pattern match: $test_string is a log file"
fi

# Regular expression matching
email="user@example.com"
if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "✓ Valid email address: $email"
else
    echo "Invalid email address"
fi

# Logical operators
age=25
country="US"
if [[ $age -ge 18 && $country == "US" ]]; then
    echo "✓ Eligible for service"
fi
echo ""

# ===== 5. MULTIPLE CONDITIONS =====
echo "=== 5. Multiple Conditions ==="
read -p "Enter your username: " username
read -p "Enter your age: " user_age

if [[ -z $username ]]; then
    echo "Username cannot be empty"
elif [[ ! $user_age =~ ^[0-9]+$ ]]; then
    echo "Age must be a number"
elif [[ $user_age -lt 18 ]]; then
    echo "Must be 18 or older"
elif [[ $user_age -gt 100 ]]; then
    echo "Invalid age"
else
    echo "✓ Welcome, $username (age: $user_age)"
fi
echo ""

# ===== 6. FILE TESTING =====
echo "=== 6. File and Directory Testing ==="
test_file="control_structures.sh"

echo "Testing file: $test_file"

if [[ -e $test_file ]]; then
    echo "  ✓ File exists"
    
    if [[ -f $test_file ]]; then
        echo "  ✓ Is a regular file"
    elif [[ -d $test_file ]]; then
        echo "  ✓ Is a directory"
    elif [[ -L $test_file ]]; then
        echo "  ✓ Is a symbolic link"
    fi
    
    if [[ -r $test_file ]]; then
        echo "  ✓ Readable"
    fi
    
    if [[ -w $test_file ]]; then
        echo "  ✓ Writable"
    fi
    
    if [[ -x $test_file ]]; then
        echo "  ✓ Executable"
    else
        echo "  Not executable (run: chmod +x $test_file)"
    fi
    
    if [[ -s $test_file ]]; then
        echo "  ✓ File is not empty"
    fi
else
    echo "  File does not exist"
fi
echo ""

# ===== 7. NESTED CONDITIONALS =====
echo "=== 7. Nested Conditionals - Server Check ==="
read -p "Enter server type (web/db/cache): " server_type
read -p "Enter server status (running/stopped): " status

case $server_type in
    web)
        echo "Web Server:"
        if [[ $status == "running" ]]; then
            echo "  ✓ Web server is running"
            echo "  Checking ports..."
            echo "  Port 80: OK"
            echo "  Port 443: OK"
        else
            echo "  Web server is stopped"
            echo "  Action: Run 'systemctl start nginx'"
        fi
        ;;
    db)
        echo "Database Server:"
        if [[ $status == "running" ]]; then
            echo "  ✓ Database is running"
            echo "  Connections: Active"
            echo "  Replication: OK"
        else
            echo "  Database is stopped"
            echo "  Action: Run 'systemctl start mysql'"
        fi
        ;;
    cache)
        echo "Cache Server:"
        if [[ $status == "running" ]]; then
            echo "  ✓ Cache server is running"
            echo "  Memory usage: Normal"
            echo "  Hit rate: 95%"
        else
            echo "  Cache server is stopped"
            echo "  Action: Run 'systemctl start redis'"
        fi
        ;;
    *)
        echo "Unknown server type"
        ;;
esac
echo ""

# ===== 8. CONDITIONAL EXPRESSIONS TABLE =====
echo "=== 8. Conditional Test Operators Reference ==="
cat << 'EOF'
Number Comparisons:
  -eq  Equal to
  -ne  Not equal
  -gt  Greater than
  -lt  Less than
  -ge  Greater or equal
  -le  Less or equal

String Comparisons:
  =    Equal (use == with [[]])
  !=   Not equal
  <    Less than (alphabetically)
  >    Greater than (alphabetically)
  -z   String is empty
  -n   String is not empty

File Tests:
  -e   File exists
  -f   Regular file
  -d   Directory
  -L   Symbolic link
  -r   Readable
  -w   Writable
  -x   Executable
  -s   File is not empty
  -O   You own the file
  -G   Group ID matches yours

Logical Operators:
  &&   AND
  ||   OR
  !    NOT
EOF
echo ""

echo "======================================="
echo "      DEMO COMPLETED"
echo "======================================="
