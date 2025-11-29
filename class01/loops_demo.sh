#!/bin/bash
# Loops Demonstration

echo "======================================="
echo "       SHELL SCRIPTING LOOPS"
echo "======================================="
echo ""

# ===== 1. FOR LOOP =====
echo "=== 1. FOR LOOP - Simple Range ==="
for i in 1 2 3 4 5
do
    echo "Iteration: $i"
done
echo ""

# FOR loop - Range with seq
echo "=== 2. FOR LOOP - Using seq ==="
for i in $(seq 1 5)
do
    echo "Number: $i"
done
echo ""

# FOR loop - C-style
echo "=== 3. FOR LOOP - C-style ==="
for ((i=1; i<=5; i++))
do
    echo "Count: $i"
done
echo ""

# FOR loop - Array iteration
echo "=== 4. FOR LOOP - Array ==="
servers=("web01" "web02" "db01" "cache01")
for server in "${servers[@]}"
do
    echo "Processing server: $server"
done
echo ""

# FOR loop - File iteration
echo "=== 5. FOR LOOP - Files ==="
echo "Files in current directory:"
for file in *.sh
do
    echo "  - $file"
done
echo ""

# ===== 2. WHILE LOOP =====
echo "=== 6. WHILE LOOP - Counter ==="
counter=1
while [ $counter -le 5 ]
do
    echo "While iteration: $counter"
    ((counter++))
done
echo ""

# WHILE loop - Reading file
echo "=== 7. WHILE LOOP - Reading file ==="
echo "Creating sample log..."
cat > sample.log << EOF
2025-01-15 ERROR: Connection failed
2025-01-15 INFO: Service started
2025-01-15 WARN: High memory usage
2025-01-15 ERROR: Timeout occurred
EOF

echo "Processing log file:"
while IFS= read -r line
do
    if [[ $line == *"ERROR"* ]]; then
        echo "$line"
    elif [[ $line == *"WARN"* ]]; then
        echo "$line"
    else
        echo "$line"
    fi
done < sample.log
echo ""

# ===== 3. UNTIL LOOP =====
echo "=== UNTIL LOOP - Countdown ==="
countdown=5
until [ $countdown -eq 0 ]
do
    echo "Countdown: $countdown"
    ((countdown--))
done
echo "Liftoff!"
echo ""

# ===== PRACTICAL DEVOPS EXAMPLE =====
echo "=== PRACTICAL - Service Health Check ==="
services=("nginx" "ssh" "cron")

for service in "${services[@]}"
do
    # Simulate check (replace with actual systemctl)
    if command -v $service &> /dev/null; then
        echo "$service is available"
    else
        echo "$service is not available"
    fi
done
echo ""

# ===== LOOP CONTROL =====
echo "=== LOOP CONTROL - break & continue ==="
for i in {1..10}
do
    if [ $i -eq 3 ]; then
        echo "  Skipping 3"
        continue
    fi
    if [ $i -eq 7 ]; then
        echo "  Breaking at 7"
        break
    fi
    echo "  Processing: $i"
done
echo ""

echo "======================================="
echo "          LOOPS DEMO COMPLETE"
echo "======================================="