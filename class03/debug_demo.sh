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
