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
