#!/bin/bash
#
# Example 2: Deployment Validator
# Demonstrates: Case statements, regex validation, time-based rules
#

# Enable strict error handling in bash script:
# -e: Exit immediately if any command exits with a non-zero status
# -u: Treat unset variables as an error and exit immediately
# -o pipefail: Return the exit status of the last command in a pipeline that failed
set -euo pipefail

echo "======================================="
echo "  DEPLOYMENT VALIDATOR"
echo "======================================="
echo ""

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
