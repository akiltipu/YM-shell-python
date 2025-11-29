#!/bin/bash
# Conditional Statements Demo

echo "=== Server Health Check Script ==="
echo ""

# 1. Number comparison
echo "Enter server load (0-100):"
read load

if [ $load -lt 50 ]; then
    echo "Server load: NORMAL ($load%)"
elif [ $load -lt 80 ]; then
    echo "Server load: MODERATE ($load%)"
else
    echo "Server load: HIGH ($load%) - Action needed!"
fi
echo ""

# 2. String comparison
echo "Enter environment (dev/staging/prod):"
read env

if [ "$env" = "prod" ]; then
    echo "PRODUCTION - Extra caution required!"
elif [ "$env" = "staging" ]; then
    echo "STAGING - Testing environment"
elif [ "$env" = "dev" ]; then
    echo "DEVELOPMENT - Safe to experiment"
else
    echo "Unknown environment!"
fi
echo ""

# 3. File checking
config_file="config.txt"

if [ -f "$config_file" ]; then
    echo "Config file found: $config_file"
else
    echo "Config file missing: $config_file"
    echo "Creating default config..."
    touch "$config_file"
    echo "Config file created"
fi
echo ""

# 4. Multiple conditions (AND, OR)
read -p "Enter username: " username
read -p "Enter age: " age

if [ -n "$username" ] && [ $age -ge 18 ]; then
    echo "Access granted to $username"
elif [ -z "$username" ]; then
    echo "Username cannot be empty"
elif [ $age -lt 18 ]; then
    echo "Must be 18 or older"
fi
echo ""

# 5. Advanced: Check disk space
disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ $disk_usage -gt 90 ]; then
    echo "CRITICAL: Disk usage at ${disk_usage}%"
elif [ $disk_usage -gt 70 ]; then
    echo "WARNING: Disk usage at ${disk_usage}%"
else
    echo "Disk usage normal: ${disk_usage}%"
fi