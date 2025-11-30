#!/bin/bash
# Functions Demonstration Script

echo "======================================="
echo "        FUNCTIONS IN BASH"
echo "======================================="
echo ""

# ===== 1. BASIC FUNCTION DECLARATION =====
echo "=== 1. Basic Function Declaration ==="

# Method 1: Using function keyword
function greet_method1 {
    echo "Hello from Method 1!"
}

# Method 2: POSIX style (preferred)
greet_method2() {
    echo "Hello from Method 2!"
}

# Call functions
greet_method1
greet_method2
echo ""

# ===== 2. FUNCTIONS WITH PARAMETERS =====
echo "=== 2. Functions with Parameters ==="

greet_user() {
    local name=$1
    local role=$2
    
    echo "Welcome, $name!"
    echo "Role: $role"
}

greet_user "Alice" "DevOps Engineer"
greet_user "Bob" "SRE"
echo ""

# ===== 3. PARAMETER COUNT AND ACCESS =====
echo "=== 3. Accessing Function Parameters ==="

show_params() {
    echo "Function name: $0"
    echo "First parameter: $1"
    echo "Second parameter: $2"
    echo "Total parameters: $#"
    echo "All parameters: $@"
    echo "All parameters (string): $*"
}

show_params "param1" "param2" "param3"
echo ""

# ===== 4. RETURN VALUES =====
echo "=== 4. Return Values ==="

# Return exit status (0-255)
check_number() {
    local num=$1
    
    if [ $num -gt 0 ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Test return value
if check_number 5; then
    echo "Number is positive"
else
    echo "Number is not positive"
fi

if check_number -3; then
    echo "Number is positive"
else
    echo "Number is not positive"
fi
echo ""

# ===== 5. CAPTURING OUTPUT =====
echo "=== 5. Capturing Function Output ==="

get_timestamp() {
    date +%Y-%m-%d_%H-%M-%S
}

get_system_info() {
    echo "Hostname: $(hostname)"
    echo "OS: $(uname -s)"
    echo "User: $(whoami)"
}

# Capture output
timestamp=$(get_timestamp)
echo "Timestamp: $timestamp"

echo ""
echo "System Information:"
system_info=$(get_system_info)
echo "$system_info"
echo ""

# ===== 6. LOCAL VS GLOBAL VARIABLES =====
echo "=== 6. Variable Scope ==="

GLOBAL_VAR="I am global"

scope_demo() {
    local LOCAL_VAR="I am local"
    GLOBAL_VAR="Modified in function"
    
    echo "Inside function:"
    echo "  Global: $GLOBAL_VAR"
    echo "  Local: $LOCAL_VAR"
}

echo "Before function:"
echo "  Global: $GLOBAL_VAR"

scope_demo

echo "After function:"
echo "  Global: $GLOBAL_VAR"
echo "  Local: $LOCAL_VAR"  # Will be empty
echo ""

# ===== 7. DEFAULT PARAMETER VALUES =====
echo "=== 7. Default Parameter Values ==="

deploy_app() {
    local app_name=${1:-"myapp"}
    local environment=${2:-"development"}
    local version=${3:-"latest"}
    
    echo "Deploying application:"
    echo "  Name: $app_name"
    echo "  Environment: $environment"
    echo "  Version: $version"
}

deploy_app
echo ""
deploy_app "webapp" "production" "v1.2.3"
echo ""

# ===== 8. VALIDATION FUNCTIONS =====
echo "=== 8. Validation Functions ==="

validate_not_empty() {
    local value=$1
    local field_name=$2
    
    if [ -z "$value" ]; then
        echo "Error: $field_name cannot be empty"
        return 1
    fi
    return 0
}

validate_number() {
    local value=$1
    
    if [[ ! $value =~ ^[0-9]+$ ]]; then
        echo "Error: Must be a number"
        return 1
    fi
    return 0
}

# Test validations
echo "Testing validations:"
validate_not_empty "test" "Username" && echo "  Username validation passed"
validate_not_empty "" "Password" || echo "  (Expected to fail)"
validate_number "123" && echo "  Number validation passed"
validate_number "abc" || echo "  (Expected to fail)"
echo ""

# ===== 9. RECURSIVE FUNCTIONS =====
echo "=== 9. Recursive Functions ==="

factorial() {
    local n=$1
    
    if [ $n -le 1 ]; then
        echo 1
    else
        local prev=$(factorial $((n - 1)))
        echo $((n * prev))
    fi
}

echo "Factorial of 5: $(factorial 5)"

countdown() {
    local n=$1
    
    if [ $n -le 0 ]; then
        echo "Liftoff!"
        return
    fi
    
    echo "Countdown: $n"
    sleep 1
    countdown $((n - 1))
}

echo "Starting countdown:"
countdown 3
echo ""

# ===== 10. UTILITY FUNCTIONS =====
echo "=== 10. Utility Functions Library ==="

# Logging function
log() {
    local level=$1
    shift
    local message="$@"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message"
}

# Usage
log "INFO" "Application started"
log "WARN" "High memory usage detected"
log "ERROR" "Connection failed"
echo ""

# ===== 11. FUNCTIONS WITH ARRAYS =====
echo "=== 11. Functions with Arrays ==="

print_array() {
    local -a arr=("$@")
    
    echo "Array contents:"
    for i in "${!arr[@]}"; do
        echo "  [$i] = ${arr[$i]}"
    done
}

servers=("web01" "web02" "db01")
print_array "${servers[@]}"
echo ""

# ===== 12. ERROR HANDLING IN FUNCTIONS =====
echo "=== 12. Error Handling ==="

divide() {
    local numerator=$1
    local denominator=$2
    
    if [ $denominator -eq 0 ]; then
        echo "ERROR: Division by zero" >&2
        return 1
    fi
    
    echo $((numerator / denominator))
    return 0
}

# Test error handling
result=$(divide 10 2) && echo "10 ÷ 2 = $result"
divide 10 0 || echo "Failed as expected"
echo ""

# ===== 13. PRACTICAL EXAMPLE - SERVER CHECK =====
echo "=== 13. Practical Example - Server Health Check ==="

check_service() {
    local service=$1
    
    # Simulate service check
    if command -v $service &> /dev/null; then
        echo "  $service: Available"
        return 0
    else
        echo "  $service: Not found"
        return 1
    fi
}

check_port() {
    local port=$1
    
    echo "  Checking port $port..."
    # Actual implementation would use netstat or ss
    return 0
}

health_check() {
    local server_name=$1
    
    echo "Health Check for: $server_name"
    echo "Time: $(date)"
    
    local services=("bash" "sh" "ls")
    local failed=0
    
    for service in "${services[@]}"; do
        check_service "$service" || ((failed++))
    done
    
    echo ""
    if [ $failed -eq 0 ]; then
        echo "Status: All checks passed ✓"
        return 0
    else
        echo "Status: $failed check(s) failed ✗"
        return 1
    fi
}

health_check "web-server-01"
echo ""

# ===== 14. FUNCTION LIBRARY PATTERN =====
echo "=== 14. Function Library Pattern ==="

# These functions could be in a separate file and sourced
# Source example: source ./lib/utilities.sh

get_os_type() {
    uname -s
}

get_cpu_count() {
    if command -v nproc &> /dev/null; then
        nproc
    else
        echo "N/A"
    fi
}

get_memory_total() {
    if command -v free &> /dev/null; then
        free -h | awk '/^Mem:/ {print $2}'
    else
        echo "N/A"
    fi
}

display_system_summary() {
    echo "System Summary:"
    echo "  OS: $(get_os_type)"
    echo "  CPU Cores: $(get_cpu_count)"
    echo "  Total Memory: $(get_memory_total)"
    echo "  Uptime: $(uptime -p 2>/dev/null || echo 'N/A')"
}

display_system_summary
echo ""

# ===== 15. BEST PRACTICES SUMMARY =====
echo "=== 15. Best Practices ==="
cat << 'EOF'
Function Best Practices:

1. Use lowercase names with underscores
   get_user_info()
   GetUserInfo()

2. Use local variables
   local var_name="value"

3. Validate parameters
   if [ $# -lt 2 ]; then
       echo "Error: Need 2 parameters"
       return 1
   fi

4. Return exit codes
   return 0  # Success
   return 1  # Failure

5. Document functions
   # Function: deploy_app
   # Description: Deploys application to environment
   # Parameters:
   #   $1 - Environment name
   #   $2 - Version number
   # Returns: 0 on success, 1 on failure

6. Keep functions focused
   One function = One responsibility

7. Use descriptive names
   validate_email_format()
   check()

8. Handle errors gracefully
   command || { echo "Failed"; return 1; }
EOF

echo ""
echo "======================================="
echo "      FUNCTIONS DEMO COMPLETED"
echo "======================================="
