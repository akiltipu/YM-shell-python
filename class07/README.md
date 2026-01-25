# Class `07`
# Python Scripting for System Administration 

#### Mastering System Automation with Python

#### Setting Up Virtual Environments

**Why Virtual Environments?**

Virtual environments isolate project dependencies, preventing conflicts between different projects and system packages.

```bash
# Create virtual environment
python3 -m venv devops_env

# Activate virtual environment
# Linux/macOS
source devops_env/bin/activate

# Windows
devops_env\Scripts\activate

# Verify activation (you'll see the env name in prompt)
which python

# Install packages in the environment
pip install requests boto3 paramiko

# Deactivate when done
deactivate
```

**Best Practices:**
```bash
# Create requirements.txt for project dependencies
pip freeze > requirements.txt

# Install from requirements.txt
pip install -r requirements.txt

# Upgrade pip
pip install --upgrade pip
```


---


### File Handling in Python

#### Reading Files

Create `file_reading.py`:

```python
#!/usr/bin/env python3
"""
File Reading Operations in Python
"""

import os

print("=" * 60)
print("           FILE READING OPERATIONS")
print("=" * 60)
print()

# Create sample file for demo
sample_content = """server=web-01
ip=192.168.1.10
port=8080
environment=production
debug=false
max_connections=1000
timeout=30"""

with open("sample_config.txt", "w") as f:
    f.write(sample_content)

print("Created sample_config.txt")
print()

# ===== 1. READ ENTIRE FILE =====
print("=== 1. Read Entire File ===")

with open("sample_config.txt", "r") as file:
    content = file.read()
    print(content)
print()

# ===== 2. READ LINE BY LINE =====
print("=== 2. Read Line by Line ===")

with open("sample_config.txt", "r") as file:
    for line_number, line in enumerate(file, 1):
        print(f"  Line {line_number}: {line.strip()}")
print()

# ===== 3. READ INTO LIST =====
print("=== 3. Read All Lines into List ===")

with open("sample_config.txt", "r") as file:
    lines = file.readlines()
    print(f"  Total lines: {len(lines)}")
    print(f"  First line: {lines[0].strip()}")
    print(f"  Last line: {lines[-1].strip()}")
print()

# ===== 4. PARSE CONFIG FILE =====
print("=== 4. Parse Configuration File ===")

config = {}
with open("sample_config.txt", "r") as file:
    for line in file:
        line = line.strip()
        if line and "=" in line:
            key, value = line.split("=", 1)
            config[key] = value

print("Parsed configuration:")
for key, value in config.items():
    print(f"  {key}: {value}")
print()

# ===== 5. READ SPECIFIC BYTES =====
print("=== 5. Read Specific Bytes ===")

with open("sample_config.txt", "r") as file:
    first_50_chars = file.read(50)
    print(f"First 50 characters: {first_50_chars}")
print()

# Cleanup
os.remove("sample_config.txt")
print("Cleaned up sample file")
print()

print("=" * 60)
print("           DEMO COMPLETE")
print("=" * 60)
```

---

#### Writing Files

Create `file_writing.py`:

```python
#!/usr/bin/env python3
"""
File Writing Operations in Python
"""

import os
import json
from datetime import datetime

print("=" * 60)
print("           FILE WRITING OPERATIONS")
print("=" * 60)
print()

# ===== 1. WRITE NEW FILE =====
print("=== 1. Write New File ===")

with open("output.txt", "w") as file:
    file.write("Hello, DevOps World!\n")
    file.write("This is line 2\n")
    file.write("This is line 3\n")

with open("output.txt", "r") as file:
    print(file.read())

# ===== 2. APPEND TO FILE =====
print("=== 2. Append to File ===")

with open("output.txt", "a") as file:
    file.write("This line was appended\n")

with open("output.txt", "r") as file:
    print(file.read())

# ===== 3. WRITE MULTIPLE LINES =====
print("=== 3. Write Multiple Lines ===")

lines = [
    "Server: web-01\n",
    "Status: Running\n",
    "CPU: 45%\n",
    "Memory: 60%\n"
]

with open("server_status.txt", "w") as file:
    file.writelines(lines)

with open("server_status.txt", "r") as file:
    print(file.read())

# ===== 4. WRITE JSON FILE =====
print("=== 4. Write JSON File ===")

server_config = {
    "name": "web-server-01",
    "ip": "192.168.1.10",
    "port": 8080,
    "environment": "production",
    "services": ["nginx", "app", "monitoring"]
}

with open("config.json", "w") as file:
    json.dump(server_config, file, indent=2)

with open("config.json", "r") as file:
    print(file.read())

# ===== 5. WRITE LOG ENTRIES =====
print("=== 5. Write Log Entries ===")

def log_message(message, level="INFO"):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_entry = f"[{timestamp}] [{level}] {message}\n"
    
    with open("app.log", "a") as log_file:
        log_file.write(log_entry)
    
    return log_entry.strip()

print(log_message("Application started"))
print(log_message("Processing request", "DEBUG"))
print(log_message("High memory usage", "WARNING"))
print(log_message("Connection failed", "ERROR"))

print("\nLog file contents:")
with open("app.log", "r") as file:
    print(file.read())

# ===== 6. WRITE WITH CONTEXT MANAGER =====
print("=== 6. Safe Writing with Exception Handling ===")

try:
    with open("safe_output.txt", "w") as file:
        file.write("This write is safe\n")
        file.write("Even if exceptions occur, file will be closed\n")
    print("File written successfully")
except IOError as e:
    print(f"Error writing file: {e}")
print()

# Cleanup
for filename in ["output.txt", "server_status.txt", "config.json", "app.log", "safe_output.txt"]:
    if os.path.exists(filename):
        os.remove(filename)
print("Cleaned up all demo files")
print()

print("=" * 60)
print("           DEMO COMPLETE")
print("=" * 60)
```

---

### OS & subprocess Modules

#### OS Module Operations

Create `os_operations.py`:

```python
#!/usr/bin/env python3
"""
OS Module Operations for DevOps
"""

import os
import shutil
from datetime import datetime

print("=" * 60)
print("           OS MODULE OPERATIONS")
print("=" * 60)
print()

# ===== 1. CURRENT WORKING DIRECTORY =====
print("=== 1. Directory Operations ===")

print(f"Current Directory: {os.getcwd()}")
print(f"User Home: {os.path.expanduser('~')}")
print()

# ===== 2. ENVIRONMENT VARIABLES =====
print("=== 2. Environment Variables ===")

print(f"USER: {os.getenv('USER', 'unknown')}")
print(f"HOME: {os.getenv('HOME', 'unknown')}")
print(f"PATH: {os.getenv('PATH', 'unknown')[:60]}...")

# Set environment variable
os.environ['MY_APP_ENV'] = 'production'
print(f"MY_APP_ENV: {os.getenv('MY_APP_ENV')}")
print()

# ===== 3. PATH OPERATIONS =====
print("=== 3. Path Operations ===")

path = "/home/user/projects/webapp/src/main.py"
print(f"Full path: {path}")
print(f"Directory: {os.path.dirname(path)}")
print(f"Filename: {os.path.basename(path)}")
print(f"Split: {os.path.split(path)}")
print(f"Extension: {os.path.splitext(path)}")

# Join paths (platform independent)
new_path = os.path.join("home", "user", "documents")
print(f"Joined path: {new_path}")
print()

# ===== 4. FILE/DIRECTORY CHECKS =====
print("=== 4. File and Directory Checks ===")

test_file = "test_file.txt"
test_dir = "test_dir"

# Create test file and directory
with open(test_file, "w") as f:
    f.write("test content")
os.makedirs(test_dir, exist_ok=True)

print(f"'{test_file}' exists: {os.path.exists(test_file)}")
print(f"'{test_file}' is file: {os.path.isfile(test_file)}")
print(f"'{test_dir}' is directory: {os.path.isdir(test_dir)}")
print(f"'/nonexistent' exists: {os.path.exists('/nonexistent')}")
print()

# ===== 5. FILE INFORMATION =====
print("=== 5. File Information ===")

stat_info = os.stat(test_file)
print(f"File: {test_file}")
print(f"  Size: {stat_info.st_size} bytes")
print(f"  Mode: {oct(stat_info.st_mode)}")
print(f"  Modified: {datetime.fromtimestamp(stat_info.st_mtime)}")
print()

# ===== 6. LISTING DIRECTORIES =====
print("=== 6. Listing Directories ===")

# Create some files
for i in range(3):
    with open(f"file_{i}.txt", "w") as f:
        f.write(f"Content {i}")

print("Files in current directory:")
for item in os.listdir("."):
    item_path = os.path.join(".", item)
    item_type = "DIR" if os.path.isdir(item_path) else "FILE"
    print(f"  [{item_type}] {item}")
print()

# ===== 7. WALKING DIRECTORIES =====
print("=== 7. Walking Directory Tree ===")

# Create nested structure
os.makedirs("project/src/lib", exist_ok=True)
with open("project/src/main.py", "w") as f:
    f.write("# main")
with open("project/src/lib/utils.py", "w") as f:
    f.write("# utils")

print("Directory tree:")
for root, dirs, files in os.walk("project"):
    level = root.replace("project", "").count(os.sep)
    indent = "  " * level
    print(f"{indent}{os.path.basename(root)}/")
    for file in files:
        print(f"{indent}  {file}")
print()

# ===== 8. FILE OPERATIONS =====
print("=== 8. File Operations ===")

# Rename file
os.rename("file_0.txt", "renamed_file.txt")
print("Renamed file_0.txt to renamed_file.txt")

# Copy file
shutil.copy("renamed_file.txt", "copied_file.txt")
print("Copied renamed_file.txt to copied_file.txt")

# Remove file
os.remove("file_1.txt")
print("Removed file_1.txt")
print()

# ===== CLEANUP =====
print("=== Cleanup ===")

# Clean up files
for f in ["test_file.txt", "renamed_file.txt", "copied_file.txt", "file_2.txt"]:
    if os.path.exists(f):
        os.remove(f)
        print(f"  Removed {f}")

# Clean up directories
for d in ["test_dir", "project"]:
    if os.path.exists(d):
        shutil.rmtree(d)
        print(f"  Removed {d}/")
print()

print("=" * 60)
print("           DEMO COMPLETE")
print("=" * 60)
```

---

#### Subprocess Module

Create `subprocess_demo.py`:

```python
#!/usr/bin/env python3
"""
Subprocess Module for System Commands
"""

import subprocess
import sys

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

import os
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
```

---

### Error Handling in Python Scripts

Create `error_handling.py`:

```python
#!/usr/bin/env python3
"""
Error Handling in Python for DevOps Scripts
"""

import os
import sys

print("=" * 60)
print("           ERROR HANDLING IN PYTHON")
print("=" * 60)
print()

# ===== 1. BASIC TRY-EXCEPT =====
print("=== 1. Basic Try-Except ===")

try:
    result = 10 / 0
except ZeroDivisionError:
    print("Error: Cannot divide by zero!")
print()

# ===== 2. CATCHING MULTIPLE EXCEPTIONS =====
print("=== 2. Multiple Exceptions ===")

def divide(a, b):
    try:
        return a / b
    except ZeroDivisionError:
        print("Error: Division by zero")
        return None
    except TypeError:
        print("Error: Invalid types for division")
        return None

print(f"10 / 2 = {divide(10, 2)}")
print(f"10 / 0 = {divide(10, 0)}")
print(f"10 / 'a' = {divide(10, 'a')}")
print()

# ===== 3. TRY-EXCEPT-ELSE-FINALLY =====
print("=== 3. Complete Error Handling Pattern ===")

filename = "test_error.txt"

try:
    # Create file first
    with open(filename, "w") as f:
        f.write("test content")
    
    with open(filename, "r") as file:
        content = file.read()
except FileNotFoundError:
    print(f"Error: File '{filename}' not found")
except PermissionError:
    print(f"Error: Permission denied for '{filename}'")
except Exception as e:
    print(f"Unexpected error: {e}")
else:
    print(f"Successfully read file: {content}")
finally:
    print("Cleanup: Always runs")
    if os.path.exists(filename):
        os.remove(filename)
print()

# ===== 4. RAISING EXCEPTIONS =====
print("=== 4. Raising Custom Exceptions ===")

def validate_port(port):
    if not isinstance(port, int):
        raise TypeError("Port must be an integer")
    if port < 1 or port > 65535:
        raise ValueError(f"Port must be between 1 and 65535, got {port}")
    return True

try:
    validate_port(8080)
    print("Port 8080 is valid")
    
    validate_port(70000)
except ValueError as e:
    print(f"Validation error: {e}")
except TypeError as e:
    print(f"Type error: {e}")
print()

# ===== 5. CUSTOM EXCEPTION CLASSES =====
print("=== 5. Custom Exception Classes ===")

class DevOpsError(Exception):
    """Base exception for DevOps operations"""
    pass

class ServerNotFoundError(DevOpsError):
    """Raised when server is not found"""
    def __init__(self, server_name):
        self.server_name = server_name
        super().__init__(f"Server '{server_name}' not found")

class ConnectionError(DevOpsError):
    """Raised when connection fails"""
    def __init__(self, host, port):
        self.host = host
        self.port = port
        super().__init__(f"Cannot connect to {host}:{port}")

def connect_to_server(server_name, port):
    servers = {"web01": "192.168.1.10", "db01": "192.168.1.20"}
    
    if server_name not in servers:
        raise ServerNotFoundError(server_name)
    
    # Simulate connection failure
    if port > 10000:
        raise ConnectionError(servers[server_name], port)
    
    return f"Connected to {server_name} ({servers[server_name]}:{port})"

try:
    print(connect_to_server("web01", 8080))
    print(connect_to_server("unknown", 8080))
except ServerNotFoundError as e:
    print(f"Server error: {e}")
except ConnectionError as e:
    print(f"Connection error: {e}")
print()

# ===== 6. CONTEXT MANAGERS FOR CLEANUP =====
print("=== 6. Context Managers ===")

class ServerConnection:
    def __init__(self, server_name):
        self.server_name = server_name
        self.connected = False
    
    def __enter__(self):
        print(f"Connecting to {self.server_name}...")
        self.connected = True
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        print(f"Disconnecting from {self.server_name}...")
        self.connected = False
        if exc_type is not None:
            print(f"Error occurred: {exc_val}")
        return False  # Don't suppress exceptions

with ServerConnection("web-server-01") as conn:
    print(f"Connected: {conn.connected}")
    print("Performing operations...")
print()

# ===== 7. LOGGING ERRORS =====
print("=== 7. Error Logging ===")

import logging

# Configure logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

def process_server(server_name):
    try:
        if not server_name:
            raise ValueError("Server name cannot be empty")
        
        logger.info(f"Processing server: {server_name}")
        # Simulate processing
        logger.debug("Server processed successfully")
        return True
    except ValueError as e:
        logger.error(f"Validation error: {e}")
        return False
    except Exception as e:
        logger.critical(f"Unexpected error: {e}")
        raise

process_server("web01")
process_server("")
print()

# ===== 8. RETRY PATTERN =====
print("=== 8. Retry Pattern ===")

import random
import time

def unreliable_operation():
    """Simulates an operation that fails randomly"""
    if random.random() < 0.7:  # 70% failure rate
        raise Exception("Operation failed")
    return "Success"

def retry_operation(func, max_retries=3, delay=1):
    """Retry a function with exponential backoff"""
    for attempt in range(1, max_retries + 1):
        try:
            result = func()
            print(f"  Attempt {attempt}: {result}")
            return result
        except Exception as e:
            print(f"  Attempt {attempt}: Failed - {e}")
            if attempt < max_retries:
                wait_time = delay * (2 ** (attempt - 1))
                print(f"  Retrying in {wait_time}s...")
                time.sleep(wait_time)
    
    raise Exception(f"All {max_retries} attempts failed")

try:
    retry_operation(unreliable_operation, max_retries=5, delay=0.1)
except Exception as e:
    print(f"Final failure: {e}")
print()

print("=" * 60)
print("           DEMO COMPLETE")
print("=" * 60)
```

---

### Using Python for File Management

Create `file_manager.py`:

```python
#!/usr/bin/env python3
"""
File Management Utilities for DevOps
"""

import os
import shutil
import glob
from datetime import datetime, timedelta

print("=" * 60)
print("           FILE MANAGEMENT UTILITIES")
print("=" * 60)
print()

# Create test environment
TEST_DIR = "file_manager_demo"
os.makedirs(TEST_DIR, exist_ok=True)
os.chdir(TEST_DIR)

# ===== 1. FIND FILES BY PATTERN =====
print("=== 1. Find Files by Pattern ===")

# Create test files
extensions = [".txt", ".log", ".json", ".py"]
for i in range(3):
    for ext in extensions:
        filename = f"file_{i}{ext}"
        with open(filename, "w") as f:
            f.write(f"Content of {filename}")

# Find using glob
print("Finding *.txt files:")
for file in glob.glob("*.txt"):
    print(f"  {file}")

print("\nFinding all files:")
for file in glob.glob("*.*"):
    print(f"  {file}")
print()

# ===== 2. FILE SIZE ANALYSIS =====
print("=== 2. File Size Analysis ===")

def get_file_size(filepath):
    """Get file size in human-readable format"""
    size = os.path.getsize(filepath)
    for unit in ['B', 'KB', 'MB', 'GB']:
        if size < 1024:
            return f"{size:.2f} {unit}"
        size /= 1024
    return f"{size:.2f} TB"

print("File sizes:")
for file in glob.glob("*.*"):
    print(f"  {file}: {get_file_size(file)}")
print()

# ===== 3. ORGANIZE FILES BY EXTENSION =====
print("=== 3. Organize Files by Extension ===")

def organize_by_extension():
    """Organize files into folders by extension"""
    for file in glob.glob("*.*"):
        if os.path.isfile(file):
            ext = os.path.splitext(file)[1].lstrip(".")
            target_dir = f"{ext}_files"
            os.makedirs(target_dir, exist_ok=True)
            shutil.move(file, os.path.join(target_dir, file))
            print(f"  Moved {file} to {target_dir}/")

organize_by_extension()

print("\nOrganized structure:")
for item in os.listdir("."):
    if os.path.isdir(item):
        files = os.listdir(item)
        print(f"  {item}/: {len(files)} files")
print()

# ===== 4. FIND OLD FILES =====
print("=== 4. Find Old Files ===")

# Recreate test files with different timestamps
for folder in glob.glob("*_files"):
    shutil.rmtree(folder)

for i, days_old in enumerate([1, 7, 30, 60]):
    filename = f"log_{days_old}days.txt"
    with open(filename, "w") as f:
        f.write(f"Log from {days_old} days ago")
    
    # Set modification time
    mod_time = datetime.now() - timedelta(days=days_old)
    os.utime(filename, (mod_time.timestamp(), mod_time.timestamp()))

def find_old_files(directory, days):
    """Find files older than specified days"""
    old_files = []
    cutoff = datetime.now() - timedelta(days=days)
    
    for file in os.listdir(directory):
        filepath = os.path.join(directory, file)
        if os.path.isfile(filepath):
            mtime = datetime.fromtimestamp(os.path.getmtime(filepath))
            if mtime < cutoff:
                old_files.append((file, mtime))
    
    return old_files

print("Files older than 7 days:")
for file, mtime in find_old_files(".", 7):
    print(f"  {file}: {mtime.strftime('%Y-%m-%d')}")
print()

# ===== 5. LOG ROTATION =====
print("=== 5. Log Rotation ===")

def rotate_log(log_file, max_backups=3):
    """Rotate log file with numbered backups"""
    if not os.path.exists(log_file):
        print(f"  No log file to rotate: {log_file}")
        return
    
    # Remove oldest backup if exists
    oldest = f"{log_file}.{max_backups}"
    if os.path.exists(oldest):
        os.remove(oldest)
        print(f"  Removed oldest: {oldest}")
    
    # Rotate existing backups
    for i in range(max_backups - 1, 0, -1):
        old_name = f"{log_file}.{i}"
        new_name = f"{log_file}.{i + 1}"
        if os.path.exists(old_name):
            os.rename(old_name, new_name)
            print(f"  Rotated: {old_name} -> {new_name}")
    
    # Rotate current log
    os.rename(log_file, f"{log_file}.1")
    print(f"  Rotated: {log_file} -> {log_file}.1")
    
    # Create new log file
    with open(log_file, "w") as f:
        f.write(f"Log created at {datetime.now()}\n")
    print(f"  Created new: {log_file}")

# Create log file and rotate multiple times
with open("app.log", "w") as f:
    f.write("Original log content\n")

for i in range(4):
    print(f"\nRotation {i + 1}:")
    with open("app.log", "a") as f:
        f.write(f"Log entry {i}\n")
    rotate_log("app.log")
print()

# ===== 6. DISK USAGE ANALYSIS =====
print("=== 6. Disk Usage Analysis ===")

def get_directory_size(directory):
    """Get total size of directory"""
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(directory):
        for filename in filenames:
            filepath = os.path.join(dirpath, filename)
            if os.path.exists(filepath):
                total_size += os.path.getsize(filepath)
    return total_size

print(f"Current directory size: {get_directory_size('.')}")
print()

# ===== CLEANUP =====
print("=== Cleanup ===")
os.chdir("..")
shutil.rmtree(TEST_DIR)
print(f"Removed {TEST_DIR}/")
print()

print("=" * 60)
print("           DEMO COMPLETE")
print("=" * 60)
```

---

### Practical: Automating Server Management with Python

Create `server_manager.py`:

```python
#!/usr/bin/env python3
"""
Server Management Automation Script
Demonstrates file handling, subprocess, and error handling
"""

import os
import json
import subprocess
import shutil
from datetime import datetime
from pathlib import Path

print("=" * 60)
print("        SERVER MANAGEMENT AUTOMATION")
print("=" * 60)
print()

# Configuration
CONFIG_DIR = "server_config"
LOG_DIR = "server_logs"
BACKUP_DIR = "server_backups"


class ServerManager:
    """Manages server operations with proper error handling"""
    
    def __init__(self):
        self.servers = {}
        self._setup_directories()
        self._load_servers()
    
    def _setup_directories(self):
        """Create necessary directories"""
        for directory in [CONFIG_DIR, LOG_DIR, BACKUP_DIR]:
            os.makedirs(directory, exist_ok=True)
    
    def _load_servers(self):
        """Load server configuration from file"""
        config_file = os.path.join(CONFIG_DIR, "servers.json")
        
        if os.path.exists(config_file):
            try:
                with open(config_file, "r") as f:
                    self.servers = json.load(f)
                print(f"Loaded {len(self.servers)} servers from config")
            except json.JSONDecodeError as e:
                print(f"Error loading config: {e}")
                self.servers = {}
        else:
            # Create sample servers
            self.servers = {
                "web01": {
                    "ip": "192.168.1.10",
                    "port": 8080,
                    "environment": "production",
                    "services": ["nginx", "app"]
                },
                "web02": {
                    "ip": "192.168.1.11",
                    "port": 8080,
                    "environment": "production",
                    "services": ["nginx", "app"]
                },
                "db01": {
                    "ip": "192.168.1.20",
                    "port": 5432,
                    "environment": "production",
                    "services": ["postgresql"]
                }
            }
            self._save_servers()
            print(f"Created default configuration with {len(self.servers)} servers")
    
    def _save_servers(self):
        """Save server configuration to file"""
        config_file = os.path.join(CONFIG_DIR, "servers.json")
        try:
            with open(config_file, "w") as f:
                json.dump(self.servers, f, indent=2)
        except IOError as e:
            print(f"Error saving config: {e}")
    
    def _log(self, message, level="INFO"):
        """Log message to file"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_entry = f"[{timestamp}] [{level}] {message}\n"
        
        log_file = os.path.join(LOG_DIR, f"server_manager_{datetime.now().strftime('%Y%m%d')}.log")
        
        try:
            with open(log_file, "a") as f:
                f.write(log_entry)
        except IOError:
            pass
        
        print(log_entry.strip())
    
    def list_servers(self):
        """List all servers"""
        self._log("Listing all servers")
        
        print("\n=== Server List ===")
        for name, config in self.servers.items():
            print(f"\n{name}:")
            print(f"  IP: {config['ip']}")
            print(f"  Port: {config['port']}")
            print(f"  Environment: {config['environment']}")
            print(f"  Services: {', '.join(config['services'])}")
    
    def add_server(self, name, ip, port, environment, services):
        """Add a new server"""
        if name in self.servers:
            self._log(f"Server '{name}' already exists", "WARNING")
            return False
        
        self.servers[name] = {
            "ip": ip,
            "port": port,
            "environment": environment,
            "services": services
        }
        
        self._save_servers()
        self._log(f"Added server: {name}")
        return True
    
    def remove_server(self, name):
        """Remove a server"""
        if name not in self.servers:
            self._log(f"Server '{name}' not found", "WARNING")
            return False
        
        del self.servers[name]
        self._save_servers()
        self._log(f"Removed server: {name}")
        return True
    
    def check_server_status(self, name):
        """Check server status (simulated)"""
        if name not in self.servers:
            self._log(f"Server '{name}' not found", "ERROR")
            return None
        
        server = self.servers[name]
        
        # Simulate status check using ping
        self._log(f"Checking status of {name}")
        
        # Use subprocess to check if server is reachable
        try:
            result = subprocess.run(
                ["ping", "-c", "1", "-W", "1", server["ip"]],
                capture_output=True,
                text=True,
                timeout=5
            )
            reachable = result.returncode == 0
        except (subprocess.TimeoutExpired, Exception):
            reachable = False
        
        status = {
            "name": name,
            "ip": server["ip"],
            "reachable": reachable,
            "checked_at": datetime.now().isoformat()
        }
        
        level = "INFO" if reachable else "ERROR"
        self._log(f"Server {name} is {'UP' if reachable else 'DOWN'}", level)
        
        return status
    
    def backup_configs(self):
        """Backup all configurations"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_file = os.path.join(BACKUP_DIR, f"config_backup_{timestamp}.json")
        
        try:
            with open(backup_file, "w") as f:
                json.dump({
                    "timestamp": timestamp,
                    "servers": self.servers
                }, f, indent=2)
            
            self._log(f"Created backup: {backup_file}")
            
            # Keep only last 5 backups
            backups = sorted(Path(BACKUP_DIR).glob("config_backup_*.json"))
            if len(backups) > 5:
                for old_backup in backups[:-5]:
                    os.remove(old_backup)
                    self._log(f"Removed old backup: {old_backup}")
            
            return backup_file
        except IOError as e:
            self._log(f"Backup failed: {e}", "ERROR")
            return None
    
    def generate_report(self):
        """Generate server status report"""
        report_file = os.path.join(LOG_DIR, f"report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        
        report_lines = [
            "=" * 60,
            "         SERVER STATUS REPORT",
            "=" * 60,
            f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
            f"Total Servers: {len(self.servers)}",
            "",
            "=== Server Details ==="
        ]
        
        for name, config in self.servers.items():
            status = self.check_server_status(name)
            report_lines.extend([
                f"\n{name}:",
                f"  IP: {config['ip']}:{config['port']}",
                f"  Environment: {config['environment']}",
                f"  Services: {', '.join(config['services'])}",
                f"  Status: {'UP' if status and status['reachable'] else 'DOWN'}"
            ])
        
        report_lines.extend([
            "",
            "=" * 60,
            "         END OF REPORT",
            "=" * 60
        ])
        
        report_content = "\n".join(report_lines)
        
        try:
            with open(report_file, "w") as f:
                f.write(report_content)
            self._log(f"Report saved to: {report_file}")
        except IOError as e:
            self._log(f"Failed to save report: {e}", "ERROR")
        
        return report_content


def cleanup():
    """Clean up demo files"""
    for directory in [CONFIG_DIR, LOG_DIR, BACKUP_DIR]:
        if os.path.exists(directory):
            shutil.rmtree(directory)


def main():
    """Main execution"""
    try:
        manager = ServerManager()
        
        print("\n" + "=" * 40)
        print("  Demo: Server Management Operations")
        print("=" * 40)
        
        # List current servers
        manager.list_servers()
        print()
        
        # Add a new server
        print("\n--- Adding new server ---")
        manager.add_server(
            "cache01",
            "192.168.1.30",
            6379,
            "production",
            ["redis"]
        )
        
        # Check server status
        print("\n--- Checking server status ---")
        manager.check_server_status("web01")
        
        # Create backup
        print("\n--- Creating backup ---")
        manager.backup_configs()
        
        # Generate report
        print("\n--- Generating report ---")
        report = manager.generate_report()
        print(report)
        
    except Exception as e:
        print(f"\nError: {e}")
    finally:
        # Cleanup
        print("\n--- Cleanup ---")
        cleanup()
        print("Demo files cleaned up")


if __name__ == "__main__":
    main()
```

---

### Wrap-up & Q&A

#### Summary & Key Takeaways

**Recap:**
```
What We Learned Today:
  1. File handling (reading, writing, appending)
  2. OS module for system operations
  3. Subprocess for running system commands
  4. Error handling with try-except
  5. Building file management utilities
  6. Server management automation

Skills Gained:
  - Reading and writing various file formats
  - Navigating filesystem with Python
  - Executing and capturing system commands
  - Robust error handling patterns
  - Building production-ready automation scripts
```

---

#### Homework Assignment

**Assignment:**
```python
# Create a "Log Analyzer and Rotator" script that:
# 1. Parses log files to extract errors and warnings
# 2. Generates daily/weekly summary reports
# 3. Rotates logs based on size or age
# 4. Archives old logs with compression
# 5. Sends alerts for critical errors
# 6. Includes proper error handling

# Bonus: Add email notifications
# Bonus: Support multiple log formats
# Bonus: Create visualization of error trends
```

**Resources to Share:**
```
Learning Resources:
- Python os module: https://docs.python.org/3/library/os.html
- Subprocess: https://docs.python.org/3/library/subprocess.html
- File handling: https://realpython.com/working-with-files-in-python/
- Error handling: https://realpython.com/python-exceptions/
- https://realpython.com/python-virtual-environments-a-primer/

Next Class Preview:
- Working with APIs
- HTTP requests
- JSON processing
- API automation for DevOps
```

---

## Message

```
"Excellent work on Class 07!

You've mastered the essential Python skills for system 
administration - file handling, OS operations, subprocess,
and error handling. These are the building blocks of
production automation scripts.

The scripts you write now can handle real-world challenges:
file management, log rotation, server monitoring, and
system automation. Always remember to handle errors
gracefully - it separates amateur scripts from 
production-grade automation.

Ready for Class 08? We'll explore Python's power in
working with APIs and web services!"
```

---

**Keep automating and building!**
