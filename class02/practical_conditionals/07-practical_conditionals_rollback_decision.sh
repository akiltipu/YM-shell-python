#!/bin/bash
#
# Example 7: Automated Rollback Decision
# Demonstrates: Threshold-based decisions, deployment health monitoring
#

set -euo pipefail

echo "======================================="
echo "  AUTOMATED ROLLBACK DECISION"
echo "======================================="
echo ""

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

echo "Test 2: High error rate (should trigger rollback)"
should_rollback 15 500 30 && echo "  Action: Initiating rollback..."
echo ""

echo "Test 3: Old deployment with high errors (should NOT auto-rollback)"
should_rollback 15 500 70 || echo "  Manual intervention needed"
