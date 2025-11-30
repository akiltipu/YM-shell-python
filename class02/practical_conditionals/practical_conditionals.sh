#!/bin/bash
#
# Practical Conditional Scripting Examples
# Real-world DevOps scenarios using advanced conditionals
#

set -euo pipefail

echo "======================================="
echo "  PRACTICAL CONDITIONAL SCRIPTING"
echo "======================================="
echo ""

# ===== EXAMPLE 1: SYSTEM HEALTH MONITOR =====
echo "=== Example 1: System Health Monitor ==="

# Configuration
CPU_WARN=70
CPU_CRIT=90
MEM_WARN=75
MEM_CRIT=90
DISK_WARN=80
DISK_CRIT=95

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

check_cpu_usage() {
    # Get CPU usage (simplified - actual might vary by OS)
    local cpu_idle=$(top -l 1 -n 0 2>/dev/null | grep "CPU usage" | awk '{print $7}' | sed 's/%//' || echo "0")
    local cpu_usage=$((100 - ${cpu_idle%.*}))
    
    echo -n "CPU Usage: ${cpu_usage}% - "
    
    if [ $cpu_usage -lt $CPU_WARN ]; then
        echo -e "${GREEN}NORMAL${NC}"
        return 0
    elif [ $cpu_usage -lt $CPU_CRIT ]; then
        echo -e "${YELLOW}WARNING${NC}"
        echo "  Action: Monitor closely"
        return 1
    else
        echo -e "${RED}CRITICAL${NC}"
        echo "  Action: Investigate high CPU processes"
        return 2
    fi
}

check_memory_usage() {
    # Simulate memory check
    local mem_usage=65
    
    echo -n "Memory Usage: ${mem_usage}% - "
    
    if [ $mem_usage -ge $MEM_CRIT ]; then
        echo -e "${RED}CRITICAL${NC}"
        echo "  Action: Clear cache or restart services"
        return 2
    elif [ $mem_usage -ge $MEM_WARN ]; then
        echo -e "${YELLOW}WARNING${NC}"
        echo "  Action: Review memory-intensive processes"
        return 1
    else
        echo -e "${GREEN}NORMAL${NC}"
        return 0
    fi
}

check_disk_space() {
    local disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    
    echo -n "Disk Usage: ${disk_usage}% - "
    
    if [ $disk_usage -ge $DISK_CRIT ]; then
        echo -e "${RED}CRITICAL${NC}"
        echo "  Action: Clean up immediately!"
        echo "  Suggested: Check logs, temp files, old backups"
        return 2
    elif [ $disk_usage -ge $DISK_WARN ]; then
        echo -e "${YELLOW}WARNING${NC}"
        echo "  Action: Plan cleanup soon"
        return 1
    else
        echo -e "${GREEN}NORMAL${NC}"
        return 0
    fi
}

# Run health checks
check_cpu_usage || true
check_memory_usage || true
check_disk_space || true
echo ""

# ===== EXAMPLE 2: DEPLOYMENT VALIDATOR =====
echo "=== Example 2: Deployment Validator ==="

validate_deployment() {
    local environment=$1
    local version=$2
    local deploy_user=$3
    
    echo "Validating deployment parameters..."
    
    # Check environment
    case $environment in
        dev|development)
            echo "  ✓ Environment: Development"
            local require_approval=false
            local backup_required=false
            ;;
        staging|stage)
            echo "  ✓ Environment: Staging"
            local require_approval=true
            local backup_required=true
            ;;
        prod|production)
            echo "  ✓ Environment: Production"
            local require_approval=true
            local backup_required=true
            
            # Additional production checks
            if [[ ! $deploy_user =~ ^(admin|deploy-bot)$ ]]; then
                echo "  ✗ Error: Only admin or deploy-bot can deploy to production"
                return 1
            fi
            
            # Check time window (weekdays 9-17)
            local hour=$(date +%H)
            local day=$(date +%u)  # 1=Monday, 7=Sunday
            
            if [ $day -gt 5 ]; then
                echo "  ✗ Error: No production deployments on weekends"
                return 1
            elif [ $hour -lt 9 ] || [ $hour -gt 17 ]; then
                echo "  ✗ Error: Production deployments only allowed 9AM-5PM"
                return 1
            fi
            ;;
        *)
            echo "  ✗ Error: Invalid environment '$environment'"
            return 1
            ;;
    esac
    
    # Validate version format (e.g., v1.2.3)
    if [[ ! $version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "  ✗ Error: Invalid version format (expected: v1.2.3)"
        return 1
    else
        echo "  ✓ Version format: Valid"
    fi
    
    # Check if version already deployed
    local deployed_version="v1.2.2"  # Simulate current version
    if [ "$version" = "$deployed_version" ]; then
        echo "  ⚠ Warning: Version $version already deployed"
        read -p "  Continue anyway? (yes/no): " confirm
        if [ "$confirm" != "yes" ]; then
            echo "  Deployment cancelled by user"
            return 1
        fi
    fi
    
    echo ""
    echo "Validation Summary:"
    echo "  Environment: $environment"
    echo "  Version: $version"
    echo "  User: $deploy_user"
    echo "  Approval Required: $require_approval"
    echo "  Backup Required: $backup_required"
    echo ""
    echo "✓ All validations passed"
    return 0
}

# Test deployment validation
validate_deployment "staging" "v1.2.3" "deploy-bot" || echo "Validation failed"
echo ""

# ===== EXAMPLE 3: SERVICE DEPENDENCY CHECKER =====
echo "=== Example 3: Service Dependency Checker ==="

check_service_dependencies() {
    local service=$1
    
    echo "Checking dependencies for: $service"
    
    case $service in
        webapp)
            local deps=("nginx" "nodejs" "postgres")
            ;;
        api)
            local deps=("nodejs" "redis" "postgres")
            ;;
        database)
            local deps=("postgres")
            ;;
        *)
            echo "  ✗ Unknown service"
            return 1
            ;;
    esac
    
    local all_ok=true
    
    for dep in "${deps[@]}"; do
        # Simulate dependency check
        if command -v $dep &> /dev/null || [ "$dep" = "nodejs" ] || [ "$dep" = "postgres" ] || [ "$dep" = "redis" ]; then
            echo "  ✓ $dep: Available"
        else
            echo "  ✗ $dep: Missing"
            all_ok=false
        fi
    done
    
    echo ""
    if $all_ok; then
        echo "✓ All dependencies satisfied"
        return 0
    else
        echo "✗ Missing dependencies - cannot start service"
        return 1
    fi
}

check_service_dependencies "webapp"
echo ""

# ===== EXAMPLE 4: CONFIGURATION VALIDATOR =====
echo "=== Example 4: Configuration File Validator ==="

validate_config() {
    local config_file=$1
    
    echo "Validating configuration: $config_file"
    
    # Check if file exists
    if [ ! -f "$config_file" ]; then
        echo "  ✗ Error: Config file not found"
        return 1
    fi
    
    echo "  ✓ File exists"
    
    # Check file permissions
    if [ ! -r "$config_file" ]; then
        echo "  ✗ Error: Config file not readable"
        return 1
    fi
    
    echo "  ✓ File is readable"
    
    # Check if empty
    if [ ! -s "$config_file" ]; then
        echo "  ✗ Error: Config file is empty"
        return 1
    fi
    
    echo "  ✓ File has content"
    
    # Validate required fields
    local required_fields=("server" "port" "timeout")
    local missing_fields=()
    
    for field in "${required_fields[@]}"; do
        if ! grep -q "^${field}=" "$config_file"; then
            missing_fields+=("$field")
        fi
    done
    
    if [ ${#missing_fields[@]} -gt 0 ]; then
        echo "  ✗ Error: Missing required fields: ${missing_fields[*]}"
        return 1
    fi
    
    echo "  ✓ All required fields present"
    
    # Validate port number
    local port=$(grep "^port=" "$config_file" | cut -d= -f2)
    if [ -n "$port" ]; then
        if [[ ! $port =~ ^[0-9]+$ ]]; then
            echo "  ✗ Error: Port must be numeric"
            return 1
        elif [ $port -lt 1 ] || [ $port -gt 65535 ]; then
            echo "  ✗ Error: Port must be between 1-65535"
            return 1
        fi
        echo "  ✓ Port number valid: $port"
    fi
    
    echo ""
    echo "✓ Configuration validation passed"
    return 0
}

# Create test config file
cat > test_config.txt << EOF
server=localhost
port=8080
timeout=30
EOF

validate_config "test_config.txt"
rm test_config.txt
echo ""

# ===== EXAMPLE 5: BACKUP DECISION LOGIC =====
echo "=== Example 5: Intelligent Backup System ==="

should_backup() {
    local data_dir=$1
    local last_backup_file=$2
    
    echo "Analyzing backup requirements..."
    
    # Check if data directory exists
    if [ ! -d "$data_dir" ]; then
        echo "  ✗ Data directory not found: $data_dir"
        return 1
    fi
    
    # Check if there are any files
    local file_count=$(find "$data_dir" -type f | wc -l)
    if [ $file_count -eq 0 ]; then
        echo "  ℹ No files to backup"
        return 1
    fi
    
    echo "  Files to backup: $file_count"
    
    # Check last backup time
    if [ -f "$last_backup_file" ]; then
        local last_backup=$(stat -f%m "$last_backup_file" 2>/dev/null || stat -c%Y "$last_backup_file" 2>/dev/null)
        local current_time=$(date +%s)
        local hours_since_backup=$(( (current_time - last_backup) / 3600 ))
        
        echo "  Hours since last backup: $hours_since_backup"
        
        if [ $hours_since_backup -lt 24 ]; then
            echo "  ℹ Backup performed recently, skipping"
            return 1
        fi
    else
        echo "  ℹ No previous backup found"
    fi
    
    # Check day of week (prefer weekdays)
    local day_of_week=$(date +%u)
    if [ $day_of_week -gt 5 ]; then
        echo "  ℹ Weekend - backup not critical"
    else
        echo "  ✓ Weekday - backup recommended"
    fi
    
    # Check available disk space
    local available_space=$(df /tmp | tail -1 | awk '{print $4}')
    local required_space=1000000  # 1GB in KB
    
    if [ $available_space -lt $required_space ]; then
        echo "  ✗ Insufficient disk space for backup"
        return 1
    fi
    
    echo "  ✓ Sufficient disk space available"
    echo ""
    echo "✓ Backup should proceed"
    return 0
}

# Test backup logic (simulated)
mkdir -p /tmp/test_data
touch /tmp/test_data/file{1..5}.txt
should_backup "/tmp/test_data" "/tmp/last_backup.marker" || echo "Backup skipped"
rm -rf /tmp/test_data
echo ""

# ===== EXAMPLE 6: USER ACCESS CONTROL =====
echo "=== Example 6: Access Control Logic ==="

check_access() {
    local user=$1
    local resource=$2
    local action=$3
    
    echo "Checking access: $user -> $action on $resource"
    
    # Admin has full access
    if [ "$user" = "admin" ]; then
        echo "  ✓ Access granted (admin user)"
        return 0
    fi
    
    # Check resource type
    case $resource in
        production-db)
            if [[ $action == "read" ]]; then
                echo "  ✓ Read access granted"
                return 0
            else
                echo "  ✗ Write access denied (production database)"
                return 1
            fi
            ;;
        staging-db)
            if [[ $user =~ ^(developer|tester)$ ]]; then
                echo "  ✓ Access granted"
                return 0
            else
                echo "  ✗ Access denied (not authorized)"
                return 1
            fi
            ;;
        logs)
            echo "  ✓ Access granted (logs are public)"
            return 0
            ;;
        *)
            echo "  ✗ Unknown resource"
            return 1
            ;;
    esac
}

check_access "developer" "staging-db" "write"
check_access "developer" "production-db" "write" || echo ""
check_access "admin" "production-db" "write"
echo ""

# ===== EXAMPLE 7: AUTOMATED ROLLBACK DECISION =====
echo "=== Example 7: Automated Rollback Decision ==="

should_rollback() {
    local error_rate=$1
    local response_time=$2
    local deployment_age=$3  # minutes
    
    echo "Analyzing deployment health..."
    echo "  Error rate: ${error_rate}%"
    echo "  Avg response time: ${response_time}ms"
    echo "  Deployment age: ${deployment_age} minutes"
    echo ""
    
    local rollback_needed=false
    local reasons=()
    
    # Check error rate
    if [ $error_rate -gt 10 ]; then
        rollback_needed=true
        reasons+=("Error rate above 10%")
    fi
    
    # Check response time
    if [ $response_time -gt 1000 ]; then
        rollback_needed=true
        reasons+=("Response time above 1000ms")
    fi
    
    # Only rollback if deployment is recent (< 60 min)
    if [ $deployment_age -gt 60 ]; then
        echo "  ℹ Deployment is older than 60 minutes"
        echo "  Manual intervention required instead of automatic rollback"
        return 1
    fi
    
    if $rollback_needed; then
        echo "  ✗ ROLLBACK REQUIRED"
        echo "  Reasons:"
        for reason in "${reasons[@]}"; do
            echo "    - $reason"
        done
        return 0
    else
        echo "  ✓ Deployment is healthy"
        return 1
    fi
}

echo "Test 1: Healthy deployment"
should_rollback 2 500 30 || echo ""
echo ""

echo "Test 2: High error rate"
should_rollback 15 500 30 && echo "  Action: Initiating rollback..."
echo ""

# ===== CLEANUP =====
rm -f test_config.txt /tmp/last_backup.marker 2>/dev/null

echo "======================================="
echo "      EXAMPLES COMPLETED"
echo "======================================="
