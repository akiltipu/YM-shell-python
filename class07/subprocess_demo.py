import subprocess
import sys
import os

print("=" * 60)
print("           SUBPROCESS MODULE DEMO")
print("=" * 60)
print()

# ===== 1. BASIC COMMAND EXECUTION =====
print("=== 1. Basic Command Execution ===")

# Run simple command
result = subprocess.run(["echo", "Hello from subprocess!"], capture_output=True, text=True)
print(f"Output: {result.stdout.strip()}")
print(f"Return code: {result.returncode}")
print()

# ===== 2. CAPTURE OUTPUT =====
print("=== 2. Capture Command Output ===")

result = subprocess.run(["whoami"], capture_output=True, text=True)
print(f"Current user: {result.stdout.strip()}")

result = subprocess.run(["pwd"], capture_output=True, text=True)
print(f"Current directory: {result.stdout.strip()}")

result = subprocess.run(["date"], capture_output=True, text=True)
print(f"Current date: {result.stdout.strip()}")
print()

# ===== 3. RUNNING SHELL COMMANDS =====
print("=== 3. Shell Commands ===")

# Using shell=True for complex commands
result = subprocess.run(
    "echo $USER at $(hostname)",
    shell=True,
    capture_output=True,
    text=True
)
print(f"Shell output: {result.stdout.strip()}")

# Pipe commands
result = subprocess.run(
    "ls -la | head -5",
    shell=True,
    capture_output=True,
    text=True
)
print(f"Piped output:\n{result.stdout}")

# ===== 4. ERROR HANDLING =====
print("=== 4. Error Handling ===")

# Command that fails
result = subprocess.run(
    ["ls", "/nonexistent_directory"],
    capture_output=True,
    text=True
)
print(f"Return code: {result.returncode}")
print(f"Error output: {result.stderr.strip()}")

# Using check=True raises exception on error
try:
    subprocess.run(
        ["ls", "/nonexistent"],
        check=True,
        capture_output=True,
        text=True
    )
except subprocess.CalledProcessError as e:
    print(f"Command failed with code {e.returncode}")
print()

# ===== 5. TIMEOUT =====
print("=== 5. Command Timeout ===")

try:
    result = subprocess.run(
        ["sleep", "1"],
        timeout=2,
        capture_output=True
    )
    print("Command completed within timeout")
except subprocess.TimeoutExpired:
    print("Command timed out!")
print()

# ===== 6. ENVIRONMENT VARIABLES =====
print("=== 6. Custom Environment ===")

custom_env = os.environ.copy()
custom_env["MY_CUSTOM_VAR"] = "custom_value"

result = subprocess.run(
    ["bash", "-c", "echo $MY_CUSTOM_VAR"],
    env=custom_env,
    capture_output=True,
    text=True
)
print(f"Custom env var: {result.stdout.strip()}")
print()

# ===== 7. WORKING DIRECTORY =====
print("=== 7. Working Directory ===")

result = subprocess.run(
    ["pwd"],
    cwd="/tmp",
    capture_output=True,
    text=True
)
print(f"Command ran in: {result.stdout.strip()}")
print()

# ===== 8. PRACTICAL EXAMPLES =====
print("=== 8. Practical DevOps Examples ===")

# Get disk usage
result = subprocess.run(
    ["df", "-h", "/"],
    capture_output=True,
    text=True
)
print("Disk Usage:")
print(result.stdout)

# Get memory info
result = subprocess.run(
    ["free", "-h"],
    capture_output=True,
    text=True
)
if result.returncode == 0:
    print("Memory Info:")
    print(result.stdout)
else:
    print("Memory info not available (non-Linux system)")
print()

# ===== 9. RUNNING PYTHON SCRIPTS =====
print("=== 9. Running Python Scripts ===")

# Run Python code
python_code = "print('Hello from Python subprocess!')"
result = subprocess.run(
    [sys.executable, "-c", python_code],
    capture_output=True,
    text=True
)
print(f"Output: {result.stdout.strip()}")
print()

print("=" * 60)
print("           DEMO COMPLETE")
print("=" * 60)
