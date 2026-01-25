
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
