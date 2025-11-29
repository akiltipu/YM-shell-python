#!/bin/bash
# Variables Demonstration Script

# 1. Basic Variable Declaration
echo "=== Basic Variables ==="
name="John Doe"
age=30
role="DevOps Engineer"

echo "Name: $name"
echo "Age: $age"
echo "Role: $role"
echo ""

# 2. Different ways to reference variables
echo "=== Variable Referencing ==="
echo "Using \$name: $name"
echo "Using \${name}: ${name}"
echo "Combined: ${name} is ${age} years old"
echo ""

# 3. Command Substitution
echo "=== Command Substitution ==="
current_date=$(date +%Y-%m-%d)
server_name=$(hostname)
user_name=$(whoami)
file_count=$(ls -1 | wc -l)

echo "Today: $current_date"
echo "Server: $server_name"
echo "User: $user_name"
echo "Files in directory: $file_count"
echo ""

# 4. Environment Variables
echo "=== Environment Variables ==="
echo "Home Directory: $HOME"
echo "Current User: $USER"
echo "Shell: $SHELL"
echo "Path: $PATH"
echo ""

# 5. Read-only Variables
echo "=== Constants (Read-only) ==="
readonly PI=3.14159
readonly APP_NAME="DevOps Automation"

echo "PI: $PI"
echo "App: $APP_NAME"

# Try to change (this will error)
# PI=3.14  # Uncomment to see error
echo ""

# 6. Arithmetic Operations
echo "=== Arithmetic ==="
num1=10
num2=5

sum=$((num1 + num2))
diff=$((num1 - num2))
product=$((num1 * num2))
quotient=$((num1 / num2))

echo "$num1 + $num2 = $sum"
echo "$num1 - $num2 = $diff"
echo "$num1 × $num2 = $product"
echo "$num1 ÷ $num2 = $quotient"
echo ""

# 7. String Operations
echo "=== String Operations ==="
firstname="Jane"
lastname="Smith"
fullname="$firstname $lastname"

echo "Full name: $fullname"
echo "Length: ${#fullname}"
# echo "Uppercase: ${fullname^^}"
# echo "Lowercase: ${fullname,,}"

echo "Uppercase: $(echo "$fullname" | tr '[:lower:]' '[:upper:]')"
echo "Lowercase: $(echo "$fullname" | tr '[:upper:]' '[:lower:]')"