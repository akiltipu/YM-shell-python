#!/bin/bash

# Practical Example 1: Log Parsing with Regex
# Extract errors, warnings, and metrics from application logs

echo "=== Log Parsing with Regular Expressions ==="
echo ""

# Sample log data
cat > /tmp/app.log << 'LOGDATA'
2024-12-01 10:15:23 [INFO] Application started successfully
2024-12-01 10:15:25 [DEBUG] Database connection established
2024-12-01 10:16:30 [WARN] High memory usage detected: 85%
2024-12-01 10:17:45 [ERROR] Failed to connect to Redis server at 192.168.1.100:6379
2024-12-01 10:18:00 [INFO] Processing request from user@example.com
2024-12-01 10:19:15 [ERROR] Database query timeout after 30s
2024-12-01 10:20:00 [WARN] API rate limit approaching: 950/1000 requests
2024-12-01 10:21:30 [FATAL] Out of memory error - terminating application
2024-12-01 10:22:00 [INFO] Application shutdown initiated
LOGDATA

echo "Sample log file created"
echo ""

# Extract all ERROR messages
echo "1. Extract all ERROR messages:"
echo "──────────────────────────────"
grep -E '\[ERROR\]' /tmp/app.log
echo ""

# Extract timestamps from error messages
echo "2. Extract timestamps from errors:"
echo "──────────────────────────────────────"
grep -E '\[ERROR\]' /tmp/app.log | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}'
echo ""

# Extract IP addresses
echo "3. Extract IP addresses from logs:"
echo "──────────────────────────────────────"
grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' /tmp/app.log
echo ""

# Extract email addresses
echo "4. Extract email addresses:"
echo "───────────────────────────"
grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' /tmp/app.log
echo ""

# Count log levels
echo "5. Count messages by log level:"
echo "────────────────────────────────"
for level in INFO DEBUG WARN ERROR FATAL; do
    count=$(grep -c "\[$level\]" /tmp/app.log || true)
    printf "%-6s: %d\n" "$level" "$count"
done
echo ""

# Extract numeric values
echo "6. Extract numeric metrics:"
echo "───────────────────────────"
grep -oE '[0-9]+%' /tmp/app.log
echo ""

echo "💡 Regex patterns used:"
echo "   - Date/Time: ^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}"
echo "   - IP Address: [0-9]{1,3}(\.[0-9]{1,3}){3}"
echo "   - Email: [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"

rm -f /tmp/app.log
