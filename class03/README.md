# Class `03`
# Advanced Shell Scripting Techniques


### Why Advanced Shell Scripting Matters in DevOps

**Production-Ready Scripts:** The difference between a script that works on your laptop and one that runs reliably in production environments lies in proper error handling, argument validation, and debugging capabilities.

**Maintainability:** Advanced techniques make your scripts easier to debug, modify, and understand by other team members. When a deployment script fails at 3 AM, proper error handling and logging can mean the difference between a 5-minute fix and hours of troubleshooting.

**Professional Standards:** DevOps engineers are expected to write scripts that can handle edge cases, provide meaningful feedback, and fail gracefully. These advanced techniques are what separate amateur scripts from production-grade automation.


### Command-Line Arguments

**What Are Command-Line Arguments?**

Command-line arguments allow users to pass information to scripts when executing them, making scripts flexible and reusable without modifying the code. Instead of hardcoding values or prompting for input, arguments let you run the same script with different parameters.

**Syntax:**
```bash
./script.sh arg1 arg2 arg3
```

**Built-in Variables:**

| Variable | Description | Example |
|----------|-------------|---------|
| `$0` | Script name | `./deploy.sh` |
| `$1, $2, ...` | Positional arguments | First, second arg |
| `$#` | Number of arguments | `3` |
| `$@` | All arguments (separate) | `"arg1" "arg2" "arg3"` |
| `$*` | All arguments (single string) | `"arg1 arg2 arg3"` |
| `$?` | Exit status of last command | `0` (success) or `1-255` |
| `$$` | Process ID of script | `12345` |

---

#### Basic Argument Handling

Create `args_demo.sh`:

```bash
#!/bin/bash
# Command-Line Arguments Demonstration

echo "======================================="
echo "   COMMAND-LINE ARGUMENTS DEMO"
echo "======================================="
echo ""

# Display all argument variables
echo "=== Argument Variables ==="
echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Third argument: $3"
echo "Number of arguments: $#"
echo "All arguments (\$@): $@"
echo "All arguments (\$*): $*"
echo "Process ID: $$"
echo ""

# Check if arguments were provided
if [ $# -eq 0 ]; then
    echo "No arguments provided!"
    echo "Usage: $0 <arg1> <arg2> <arg3>"
    exit 1
fi

# Process each argument
echo "=== Processing Arguments ==="
for arg in "$@"
do
    echo "Processing: $arg"
done
echo ""

echo "======================================="
echo "Demo complete!"
```

**Run Examples:**
```bash
chmod +x args_demo.sh

# No arguments
./args_demo.sh

# With arguments
./args_demo.sh production web-server 8080

# With spaces (quotes needed)
./args_demo.sh "New York" "Los Angeles" "San Francisco"
```

---

#### Advanced Argument Parsing

Create `args_advanced.sh`:

```bash
#!/bin/bash
# Advanced Command-Line Arguments with Flags

# Default values
environment="dev"
verbose=false
dry_run=false
server=""

# Usage function
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -e, --environment ENV    Set environment (dev/staging/prod)"
    echo "  -s, --server SERVER      Set server name"
    echo "  -v, --verbose            Enable verbose output"
    echo "  -d, --dry-run            Dry run mode (no actual changes)"
    echo "  -h, --help               Show this help message"
    echo ""
    echo "Example:"
    echo "  $0 -e prod -s web01 -v"
    exit 1
}

# Parse arguments
while [ $# -gt 0 ]; do
    case $1 in
        -e|--environment)
            environment="$2"
            shift 2
            ;;
        -s|--server)
            server="$2"
            shift 2
            ;;
        -v|--verbose)
            verbose=true
            shift
            ;;
        -d|--dry-run)
            dry_run=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate required arguments
if [ -z "$server" ]; then
    echo "Error: Server name is required!"
    usage
fi

# Validate environment
if [[ ! "$environment" =~ ^(dev|staging|prod)$ ]]; then
    echo "Error: Invalid environment. Must be dev, staging, or prod"
    exit 1
fi

# Display configuration
echo "======================================="
echo "       DEPLOYMENT CONFIGURATION"
echo "======================================="
echo "Environment: $environment"
echo "Server: $server"
echo "Verbose: $verbose"
echo "Dry Run: $dry_run"
echo "======================================="
echo ""

# Simulate deployment
if [ "$dry_run" = true ]; then
    echo "[DRY RUN] Would deploy to $server in $environment"
else
    echo "Deploying to $server in $environment..."
    [ "$verbose" = true ] && echo "[VERBOSE] Connecting to $server..."
    [ "$verbose" = true ] && echo "[VERBOSE] Deploying application..."
    [ "$verbose" = true ] && echo "[VERBOSE] Restarting services..."
    echo "Deployment complete!"
fi
```

**Run Examples:**
```bash
chmod +x args_advanced.sh

# Show help
./args_advanced.sh -h

# Basic deployment
./args_advanced.sh -e prod -s web01

# With verbose
./args_advanced.sh -e staging -s db01 -v

# Dry run
./args_advanced.sh -e prod -s web01 -d -v
```

---

### Error Handling and Debugging

#### Exit Codes and Error Handling

**Understanding Exit Codes:**
- `0` = Success
- `1-255` = Error (different codes can indicate different errors)
- `$?` = Contains exit code of last command

**Error Handling Strategies:**

Create `error_handling.sh`:

```bash
#!/bin/bash
# Error Handling Demonstration

# Enable strict error checking
set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

echo "======================================="
echo "      ERROR HANDLING DEMO"
echo "======================================="
echo ""

# Function to handle errors
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

# Function for warnings
warning() {
    echo "WARNING: $1" >&2
}

# Trap errors and cleanup
cleanup() {
    echo ""
    echo "Cleaning up..."
    # Add cleanup code here
    echo "Cleanup complete"
}

trap cleanup EXIT  # Run cleanup on exit
trap 'error_exit "Script interrupted"' INT TERM  # Handle Ctrl+C

# Example 1: Check command success
echo "=== Example 1: Command Success Check ==="
if command -v docker &> /dev/null; then
    echo "✓ Docker is installed"
else
    error_exit "Docker is not installed!"
fi
echo ""

# Example 2: File operations with error checking
echo "=== Example 2: File Operations ==="
config_file="config.txt"

if [ ! -f "$config_file" ]; then
    warning "Config file not found, creating default"
    echo "default_config=true" > "$config_file" || error_exit "Failed to create config"
fi

echo "✓ Config file ready: $config_file"
echo ""

# Example 3: Function with error return
echo "=== Example 3: Function Error Handling ==="
check_port() {
    local port=$1
    
    if [ -z "$port" ]; then
        return 1
    fi
    
    if [ "$port" -lt 1024 ] || [ "$port" -gt 65535 ]; then
        return 2
    fi
    
    return 0
}

if check_port 8080; then
    echo "✓ Port 8080 is valid"
else
    exit_code=$?
    case $exit_code in
        1)
            error_exit "Port number not provided"
            ;;
        2)
            error_exit "Port number out of range"
            ;;
    esac
fi
echo ""

# Example 4: Try-catch like behavior
echo "=== Example 4: Try-Catch Pattern ==="
{
    # Try block
    echo "Attempting risky operation..."
    # Simulate command that might fail
    [ -d "/nonexistent" ] && echo "Found" || echo "Not found (handled)"
} || {
    # Catch block
    warning "Operation had issues but recovered"
}
echo ""

echo "======================================="
echo "Script completed successfully!"
```

**Run:**
```bash
chmod +x error_handling.sh
./error_handling.sh
```

---

#### Debugging Techniques

Create `debug_demo.sh`:

```bash
#!/bin/bash
# Debugging Techniques Demonstration

# Method 1: Set debug mode
# set -x  # Enable debug mode (uncomment to activate)

echo "======================================="
echo "        DEBUGGING TECHNIQUES"
echo "======================================="
echo ""

# Method 2: Conditional debugging
DEBUG=${DEBUG:-false}

debug_print() {
    if [ "$DEBUG" = true ]; then
        echo "[DEBUG] $1" >&2
    fi
}

# Method 3: Function tracing
trace() {
    echo "[TRACE] $(date +%T) - $1"
}

# Example workflow with debugging
echo "=== Starting Deployment Process ==="
trace "Initializing deployment"

environment="production"
debug_print "Environment set to: $environment"

app_name="myapp"
debug_print "Application: $app_name"

version="1.2.3"
debug_print "Version: $version"

# Simulate deployment steps
steps=("Backup" "Stop services" "Deploy" "Start services" "Verify")

for step in "${steps[@]}"
do
    trace "Executing: $step"
    debug_print "Step details: $step in $environment"
    sleep 0.5
    echo "  ✓ $step completed"
done

echo ""
echo "======================================="
echo "Deployment completed successfully!"
echo ""
echo "Debugging Tips:"
echo "  Run with: DEBUG=true $0"
echo "  Or use: bash -x $0"
```

**Run:**
```bash
chmod +x debug_demo.sh

# Normal mode
./debug_demo.sh

# Debug mode
DEBUG=true ./debug_demo.sh

# Bash debug mode
bash -x debug_demo.sh
```

**Debug Flags:**
```bash
set -x  # Print commands and arguments
set -v  # Print shell input lines
set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Pipeline fails if any command fails

# Combined (common in production scripts)
set -euo pipefail
```

---

### Regular Expressions in Shell

#### Basic Regular Expressions

**What Are Regular Expressions?**

Regular expressions (regex) are patterns used to match and manipulate text. They're essential for log parsing, validation, and text processing in DevOps scripts.

**Common Regex Patterns:**

| Pattern | Meaning | Example |
|---------|---------|---------|
| `.` | Any single character | `a.c` matches `abc`, `a1c` |
| `*` | Zero or more | `ab*c` matches `ac`, `abc`, `abbc` |
| `+` | One or more | `ab+c` matches `abc`, `abbc` |
| `?` | Zero or one | `ab?c` matches `ac`, `abc` |
| `^` | Start of line | `^Hello` matches lines starting with Hello |
| `$` | End of line | `end$` matches lines ending with end |
| `[abc]` | Character class | `[aeiou]` matches any vowel |
| `[^abc]` | Negated class | `[^0-9]` matches non-digits |
| `\d` | Digit | `\d+` matches numbers |
| `\w` | Word character | `\w+` matches words |
| `{n}` | Exactly n times | `a{3}` matches `aaa` |
| `{n,m}` | Between n and m | `a{2,4}` matches `aa`, `aaa`, `aaaa` |

---

#### Regex in Shell Scripts

Create `regex_demo.sh`:

```bash
#!/bin/bash
# Regular Expressions Demonstration

echo "======================================="
echo "     REGULAR EXPRESSIONS IN SHELL"
echo "======================================="
echo ""

# Example 1: Pattern matching with =~
echo "=== Example 1: Email Validation ==="
email_pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

validate_email() {
    local email=$1
    if [[ $email =~ $email_pattern ]]; then
        echo "✓ Valid email: $email"
        return 0
    else
        echo "✗ Invalid email: $email"
        return 1
    fi
}

validate_email "user@example.com"
validate_email "invalid-email"
validate_email "test.user+tag@domain.co.uk"
echo ""

# Example 2: IP Address validation
echo "=== Example 2: IP Address Validation ==="
ip_pattern="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

validate_ip() {
    local ip=$1
    if [[ $ip =~ $ip_pattern ]]; then
        # Additional check for valid ranges (0-255)
        IFS='.' read -ra octets <<< "$ip"
        for octet in "${octets[@]}"; do
            if [ "$octet" -gt 255 ]; then
                echo "✗ Invalid IP (out of range): $ip"
                return 1
            fi
        done
        echo "✓ Valid IP: $ip"
        return 0
    else
        echo "✗ Invalid IP format: $ip"
        return 1
    fi
}

validate_ip "192.168.1.1"
validate_ip "256.1.1.1"
validate_ip "10.0.0.1"
validate_ip "invalid"
echo ""

# Example 3: Log parsing
echo "=== Example 3: Log Parsing ==="
cat > sample.log << 'EOF'
2025-12-01 10:15:23 INFO User logged in: john@example.com
2025-12-01 10:16:45 ERROR Database connection failed: timeout
2025-12-01 10:17:12 WARN High memory usage: 85%
2025-12-01 10:18:33 ERROR Failed to send email to admin@company.com
2025-12-01 10:19:01 INFO Backup completed successfully
EOF

echo "Extracting ERROR messages:"
while IFS= read -r line; do
    if [[ $line =~ ERROR ]]; then
        echo "  $line"
    fi
done < sample.log
echo ""

echo "Extracting email addresses:"
email_regex='[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
while IFS= read -r line; do
    if [[ $line =~ $email_regex ]]; then
        echo "  Found: ${BASH_REMATCH[0]}"
    fi
done < sample.log
echo ""

# Example 4: URL validation
echo "=== Example 4: URL Validation ==="
url_pattern="^(https?|ftp)://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$"

validate_url() {
    local url=$1
    if [[ $url =~ $url_pattern ]]; then
        echo "✓ Valid URL: $url"
    else
        echo "✗ Invalid URL: $url"
    fi
}

validate_url "https://example.com"
validate_url "http://sub.domain.com/path/to/resource"
validate_url "ftp://files.company.com"
validate_url "not-a-url"
echo ""

# Example 5: Extract version numbers
echo "=== Example 5: Version Extraction ==="
version_pattern="v?([0-9]+)\.([0-9]+)\.([0-9]+)"

text="Deploying version v1.2.3 to production"
if [[ $text =~ $version_pattern ]]; then
    echo "Full match: ${BASH_REMATCH[0]}"
    echo "Major: ${BASH_REMATCH[1]}"
    echo "Minor: ${BASH_REMATCH[2]}"
    echo "Patch: ${BASH_REMATCH[3]}"
fi
echo ""

echo "======================================="
echo "Regex demo complete!"
```

**Run:**
```bash
chmod +x regex_demo.sh
./regex_demo.sh
```

---

### Logging and Debugging

#### Structured Logging

Create `logging_demo.sh`:

```bash
#!/bin/bash
# Logging System Demonstration

# Log file setup
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/app_$(date +%Y%m%d).log"
mkdir -p "$LOG_DIR"

# Log levels
LOG_LEVEL_DEBUG=0
LOG_LEVEL_INFO=1
LOG_LEVEL_WARN=2
LOG_LEVEL_ERROR=3
LOG_LEVEL_FATAL=4

# Current log level (set to INFO by default)
CURRENT_LOG_LEVEL=${LOG_LEVEL:-$LOG_LEVEL_INFO}

# Color codes
COLOR_RESET='\033[0m'
COLOR_DEBUG='\033[0;36m'    # Cyan
COLOR_INFO='\033[0;32m'     # Green
COLOR_WARN='\033[0;33m'     # Yellow
COLOR_ERROR='\033[0;31m'    # Red
COLOR_FATAL='\033[1;31m'    # Bold Red

# Logging functions
log() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local color=$COLOR_RESET
    
    # Determine color and level name
    case $level in
        $LOG_LEVEL_DEBUG)
            level_name="DEBUG"
            color=$COLOR_DEBUG
            ;;
        $LOG_LEVEL_INFO)
            level_name="INFO "
            color=$COLOR_INFO
            ;;
        $LOG_LEVEL_WARN)
            level_name="WARN "
            color=$COLOR_WARN
            ;;
        $LOG_LEVEL_ERROR)
            level_name="ERROR"
            color=$COLOR_ERROR
            ;;
        $LOG_LEVEL_FATAL)
            level_name="FATAL"
            color=$COLOR_FATAL
            ;;
    esac
    
    # Only log if level is high enough
    if [ $level -ge $CURRENT_LOG_LEVEL ]; then
        # Console output (with color)
        echo -e "${color}[$timestamp] [$level_name] $message${COLOR_RESET}"
        
        # File output (no color)
        echo "[$timestamp] [$level_name] $message" >> "$LOG_FILE"
    fi
    
    # Exit on fatal
    if [ $level -eq $LOG_LEVEL_FATAL ]; then
        exit 1
    fi
}

# Convenience functions
log_debug() { log $LOG_LEVEL_DEBUG "$@"; }
log_info() { log $LOG_LEVEL_INFO "$@"; }
log_warn() { log $LOG_LEVEL_WARN "$@"; }
log_error() { log $LOG_LEVEL_ERROR "$@"; }
log_fatal() { log $LOG_LEVEL_FATAL "$@"; }

# Demo usage
echo "======================================="
echo "       LOGGING SYSTEM DEMO"
echo "======================================="
echo "Log file: $LOG_FILE"
echo ""

log_info "Application starting..."
log_debug "Debug mode enabled"
log_info "Loading configuration..."

# Simulate some operations
operations=("Initialize" "Connect to database" "Load modules" "Start services")
for op in "${operations[@]}"; do
    log_info "$op..."
    sleep 0.5
done

log_warn "Memory usage is high: 78%"
log_info "Performing health check..."

# Simulate an error scenario
if [ $((RANDOM % 2)) -eq 0 ]; then
    log_error "Failed to connect to external API"
    log_info "Retrying with backup server..."
else
    log_info "All systems operational"
fi

log_info "Application startup complete"

echo ""
echo "Check the log file: $LOG_FILE"
```

**Run:**
```bash
chmod +x logging_demo.sh
./logging_demo.sh

# View log
cat logs/app_*.log
```

---

### Practical: Scripts with Error-Handling

#### Practical 1: Deployment Script with Arguments

Create `deploy_app.sh`:

```bash
#!/bin/bash
# Production Deployment Script with Error Handling

set -euo pipefail  # Strict error handling

# Configuration
SCRIPT_NAME=$(basename "$0")
LOG_FILE="deploy_$(date +%Y%m%d_%H%M%S).log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

# Error handling
error_exit() {
    log_error "$1"
    log_error "Deployment failed. Check $LOG_FILE for details."
    cleanup
    exit 1
}

# Cleanup function
cleanup() {
    log_info "Performing cleanup..."
    # Add cleanup tasks here
}

trap cleanup EXIT
trap 'error_exit "Script interrupted by user"' INT TERM

# Usage
usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS]

Deploy application to specified environment.

OPTIONS:
    -e, --env ENV          Environment (dev/staging/prod) [required]
    -v, --version VERSION  Application version [required]
    -b, --branch BRANCH    Git branch (default: main)
    -d, --dry-run          Perform dry run only
    -h, --help             Show this help message

EXAMPLES:
    $SCRIPT_NAME -e prod -v 1.2.3
    $SCRIPT_NAME -e staging -v 1.2.3 -b develop
    $SCRIPT_NAME -e prod -v 1.2.3 -d

EOF
    exit 0
}

# Default values
environment=""
version=""
branch="main"
dry_run=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--env)
            environment="$2"
            shift 2
            ;;
        -v|--version)
            version="$2"
            shift 2
            ;;
        -b|--branch)
            branch="$2"
            shift 2
            ;;
        -d|--dry-run)
            dry_run=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            error_exit "Unknown option: $1"
            ;;
    esac
done

# Validate required arguments
[ -z "$environment" ] && error_exit "Environment is required. Use -e or --env"
[ -z "$version" ] && error_exit "Version is required. Use -v or --version"

# Validate environment
if [[ ! "$environment" =~ ^(dev|staging|prod)$ ]]; then
    error_exit "Invalid environment: $environment. Must be dev, staging, or prod"
fi

# Validate version format
version_pattern="^[0-9]+\.[0-9]+\.[0-9]+$"
if [[ ! "$version" =~ $version_pattern ]]; then
    error_exit "Invalid version format: $version. Expected: X.Y.Z"
fi

# Start deployment
echo "======================================="
echo "    APPLICATION DEPLOYMENT"
echo "======================================="
log_info "Environment: $environment"
log_info "Version: $version"
log_info "Branch: $branch"
log_info "Dry Run: $dry_run"
echo "======================================="
echo ""

# Pre-deployment checks
log_info "Running pre-deployment checks..."

# Check 1: Git available
if ! command -v git &> /dev/null; then
    error_exit "Git is not installed"
fi
log_info "✓ Git is available"

# Check 2: Required directories
required_dirs=("config" "scripts")
for dir in "${required_dirs[@]}"; do
    if [ ! -d "$dir" ]; then
        log_warn "Creating missing directory: $dir"
        mkdir -p "$dir" || error_exit "Failed to create directory: $dir"
    fi
done
log_info "✓ Required directories exist"

# Check 3: Disk space
available_space=$(df . | tail -1 | awk '{print $4}')
if [ "$available_space" -lt 1000000 ]; then
    log_warn "Low disk space: ${available_space}KB available"
fi

# Deployment steps
if [ "$dry_run" = true ]; then
    log_warn "DRY RUN MODE - No actual changes will be made"
    echo ""
fi

steps=(
    "Backup current version"
    "Pull latest code from $branch"
    "Install dependencies"
    "Run database migrations"
    "Build application"
    "Run tests"
    "Deploy to $environment"
    "Verify deployment"
)

for i in "${!steps[@]}"; do
    step_num=$((i + 1))
    step="${steps[$i]}"
    
    log_info "Step $step_num/${#steps[@]}: $step"
    
    if [ "$dry_run" = false ]; then
        # Simulate step execution
        sleep 1
        
        # Random failure for demo (remove in production)
        if [ $((RANDOM % 10)) -eq 0 ]; then
            error_exit "Failed at step: $step"
        fi
    fi
    
    log_info "✓ Completed: $step"
    echo ""
done

# Success
echo "======================================="
log_info "Deployment completed successfully!"
log_info "Version $version deployed to $environment"
log_info "Logs saved to: $LOG_FILE"
echo "======================================="

exit 0
```

**Run:**
```bash
chmod +x deploy_app.sh

# Show help
./deploy_app.sh -h

# Dry run
./deploy_app.sh -e staging -v 1.2.3 -d

# Actual deployment
./deploy_app.sh -e prod -v 1.2.3
```

---

#### Practical 2: Log Analyzer Script

Create `log_analyzer.sh`:

```bash
#!/bin/bash
# Log Analyzer with Regex and Error Handling

set -euo pipefail

# Configuration
DEFAULT_LOG_FILE="/var/log/syslog"
OUTPUT_FILE="analysis_$(date +%Y%m%d_%H%M%S).txt"

# Usage
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Analyze log files for errors, warnings, and patterns.

OPTIONS:
    -f, --file FILE        Log file to analyze (default: $DEFAULT_LOG_FILE)
    -p, --pattern PATTERN  Custom regex pattern to search
    -o, --output FILE      Output file (default: $OUTPUT_FILE)
    -t, --time HOURS       Analyze logs from last N hours
    -h, --help             Show this help

EXAMPLES:
    $(basename "$0") -f app.log
    $(basename "$0") -f app.log -p "database.*error"
    $(basename "$0") -f app.log -t 24

EOF
    exit 0
}

# Parse arguments
log_file="$DEFAULT_LOG_FILE"
custom_pattern=""
output_file="$OUTPUT_FILE"
time_filter=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            log_file="$2"
            shift 2
            ;;
        -p|--pattern)
            custom_pattern="$2"
            shift 2
            ;;
        -o|--output)
            output_file="$2"
            shift 2
            ;;
        -t|--time)
            time_filter="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Create sample log if needed (for testing)
if [ ! -f "$log_file" ]; then
    echo "Log file not found: $log_file"
    echo "Creating sample log for demonstration..."
    log_file="sample_app.log"
    
    cat > "$log_file" << 'EOF'
2025-12-01 08:15:23 INFO Application started successfully
2025-12-01 08:16:45 ERROR Database connection timeout at 192.168.1.100:5432
2025-12-01 08:17:12 WARN Memory usage high: 85% used
2025-12-01 08:18:33 ERROR Failed authentication attempt from user: admin
2025-12-01 08:19:01 INFO User logged in: john@example.com
2025-12-01 08:20:15 ERROR Disk space critical: only 5% remaining
2025-12-01 08:21:44 WARN API response time exceeded 2s
2025-12-01 08:22:56 INFO Backup completed successfully
2025-12-01 08:23:12 ERROR Failed to send notification to admin@company.com
2025-12-01 08:24:30 CRITICAL System overload: CPU at 98%
EOF
    echo "Sample log created: $log_file"
fi

# Start analysis
echo "=======================================" | tee "$output_file"
echo "       LOG ANALYSIS REPORT" | tee -a "$output_file"
echo "=======================================" | tee -a "$output_file"
echo "File: $log_file" | tee -a "$output_file"
echo "Date: $(date)" | tee -a "$output_file"
echo "=======================================" | tee -a "$output_file"
echo "" | tee -a "$output_file"

# Count total lines
total_lines=$(wc -l < "$log_file")
echo "Total log entries: $total_lines" | tee -a "$output_file"
echo "" | tee -a "$output_file"

# Count by severity
echo "=== Severity Breakdown ===" | tee -a "$output_file"
error_count=$(grep -c "ERROR" "$log_file" || true)
warn_count=$(grep -c "WARN" "$log_file" || true)
info_count=$(grep -c "INFO" "$log_file" || true)
critical_count=$(grep -c "CRITICAL" "$log_file" || true)

echo "CRITICAL: $critical_count" | tee -a "$output_file"
echo "ERROR:    $error_count" | tee -a "$output_file"
echo "WARN:     $warn_count" | tee -a "$output_file"
echo "INFO:     $info_count" | tee -a "$output_file"
echo "" | tee -a "$output_file"

# Extract error messages
if [ "$error_count" -gt 0 ]; then
    echo "=== Error Messages ===" | tee -a "$output_file"
    grep "ERROR" "$log_file" | tee -a "$output_file"
    echo "" | tee -a "$output_file"
fi

# Extract critical messages
if [ "$critical_count" -gt 0 ]; then
    echo "=== Critical Messages ===" | tee -a "$output_file"
    grep "CRITICAL" "$log_file" | tee -a "$output_file"
    echo "" | tee -a "$output_file"
fi

# Extract IP addresses
echo "=== IP Addresses Found ===" | tee -a "$output_file"
ip_pattern='([0-9]{1,3}\.){3}[0-9]{1,3}'
grep -oE "$ip_pattern" "$log_file" | sort -u | tee -a "$output_file"
echo "" | tee -a "$output_file"

# Extract email addresses
echo "=== Email Addresses Found ===" | tee -a "$output_file"
email_pattern='[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
grep -oE "$email_pattern" "$log_file" | sort -u | tee -a "$output_file"
echo "" | tee -a "$output_file"

# Custom pattern search
if [ -n "$custom_pattern" ]; then
    echo "=== Custom Pattern Results ===" | tee -a "$output_file"
    echo "Pattern: $custom_pattern" | tee -a "$output_file"
    grep -iE "$custom_pattern" "$log_file" | tee -a "$output_file" || echo "No matches found"
    echo "" | tee -a "$output_file"
fi

# Summary
echo "=======================================" | tee -a "$output_file"
echo "Analysis complete!" | tee -a "$output_file"
echo "Report saved to: $output_file" | tee -a "$output_file"
echo "=======================================" | tee -a "$output_file"
```

**Run:**
```bash
chmod +x log_analyzer.sh

# Analyze log
./log_analyzer.sh

# With custom pattern
./log_analyzer.sh -p "database|connection"

# Analyze specific file
./log_analyzer.sh -f /var/log/app.log
```

---

### Wrap-up & Q&A

#### Summary & Key Takeaways

**Recap:**
```
What We Learned Today:
  1. Command-line arguments and advanced parsing
  2. Error handling with exit codes and traps
  3. Debugging techniques and logging
  4. Regular expressions for pattern matching
  5. Production-ready script patterns

Skills Gained:
  - Writing flexible scripts with arguments
  - Implementing proper error handling
  - Using regex for log parsing
  - Creating structured logging systems
  - Building production-grade automation
```

---

#### Homework Assignment

**Assignment:**
```bash
Create a "System Health Monitor" script that:
1. Accepts arguments for threshold values
2. Checks CPU, memory, and disk usage
3. Uses regex to parse system stats
4. Logs results with proper severity levels
5. Handles errors gracefully
6. Sends alerts (email or file) when thresholds exceeded

Bonus: Add command-line flags for different modes
Bonus: Implement retry logic with exponential backoff
```

**Resources to Share:**
```
Learning Resources:
- Regex Testing: https://regex101.com/
- ShellCheck: https://www.shellcheck.net/
- Advanced Bash Guide: https://tldp.org/LDP/abs/html/
- Error Handling: https://wizardzines.com/comics/return-codes/
```

## Message

```
"Excellent work on Class 03!

You've now mastered advanced shell scripting techniques
that separate hobby scripts from production-grade automation.

These skills - argument parsing, error handling, regex, and logging -
are what you'll use every day as a DevOps engineer.

Remember: A script without error handling is a production incident
waiting to happen. Always code defensively!

Ready for Class 04? Let's dive into system operations!"
```

---

**Keep scripting and automating!**
