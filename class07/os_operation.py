import os
import shutil
from datetime import datetime

print("=" * 60)
print("     OS MODULE OPERATIONS")
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
    if not item.startswith('.') and (item.endswith('.txt') or item == test_dir):
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
