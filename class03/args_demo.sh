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
