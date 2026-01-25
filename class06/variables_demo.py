
print("=" * 50)
print("   PYTHON DATA TYPES DEMO")
print("=" * 50)
print()

# ===== 1. STRINGS =====
print("=== 1. Strings ===")

name = "DevOps"
platform = 'AWS'
description = """This is a
multi-line string"""

print(f"Name: {name}")
print(f"Platform: {platform}")
print(f"Description: {description}")

# String operations
print(f"Uppercase: {name.upper()}")
print(f"Lowercase: {name.lower()}")
print(f"Length: {len(name)}")
print(f"Replace: {name.replace('Ops', 'Engineer')}")
print()

# ===== 2. NUMBERS =====
print("=== 2. Numbers ===")

# Integers
port = 8080
max_connections = 1000

# Floats
cpu_usage = 45.5
memory_percentage = 78.25

# Arithmetic operations
print(f"Port: {port}")
print(f"Port + 1: {port + 1}")
print(f"CPU Usage: {cpu_usage}%")
print(f"Total: {max_connections * 2}")
print(f"Division: {100 / 3:.2f}")  # Format to 2 decimal places
print(f"Integer Division: {100 // 3}")
print(f"Modulo: {100 % 3}")
print(f"Power: {2 ** 10}")
print()

# ===== 3. BOOLEANS =====
print("=== 3. Booleans ===")

is_active = True
is_maintenance = False

print(f"Server Active: {is_active}")
print(f"Maintenance Mode: {is_maintenance}")
print(f"NOT Active: {not is_active}")
print(f"Active AND Maintenance: {is_active and is_maintenance}")
print(f"Active OR Maintenance: {is_active or is_maintenance}")
print()

# ===== 4. LISTS =====
print("=== 4. Lists (Mutable Arrays) ===")

servers = ["web01", "web02", "db01", "cache01"]
ports = [80, 443, 3306, 6379]

print(f"Servers: {servers}")
print(f"First server: {servers[0]}")
print(f"Last server: {servers[-1]}")
print(f"First two: {servers[:2]}")

# List operations
servers.append("backup01")
print(f"After append: {servers}")

servers.remove("cache01")
print(f"After remove: {servers}")

print(f"Server count: {len(servers)}")
print()

# ===== 5. TUPLES =====
print("=== 5. Tuples (Immutable) ===")

# Tuples cannot be modified after creation
coordinates = (10, 20)
server_info = ("web01", "192.168.1.10", 8080)

print(f"Coordinates: {coordinates}")
print(f"Server Info: {server_info}")
print(f"Server Name: {server_info[0]}")
print(f"Server IP: {server_info[1]}")
print()

# ===== 6. DICTIONARIES =====
print("=== 6. Dictionaries (Key-Value Pairs) ===")

server = {
    "name": "web-server-01",
    "ip": "192.168.1.10",
    "port": 8080,
    "status": "running",
    "tags": ["production", "web"]
}

print(f"Server Dict: {server}")
print(f"Name: {server['name']}")
print(f"IP: {server.get('ip')}")
print(f"Status: {server.get('status')}")

# Add/modify
server["region"] = "us-east-1"
server["status"] = "stopped"
print(f"After update: {server}")

# Get all keys/values
print(f"Keys: {list(server.keys())}")
print(f"Values: {list(server.values())}")
print()

# ===== 7. SETS =====
print("=== 7. Sets (Unique Values) ===")

regions = {"us-east-1", "us-west-2", "eu-west-1", "us-east-1"}  # Duplicate removed
print(f"Regions: {regions}")

active_regions = {"us-east-1", "ap-south-1"}
print(f"Union: {regions | active_regions}")
print(f"Intersection: {regions & active_regions}")
print()

# ===== 8. NONE TYPE =====
print("=== 8. None Type ===")

result = None
print(f"Result: {result}")
print(f"Is None: {result is None}")
print()

# ===== 9. TYPE CHECKING =====
print("=== 9. Type Checking ===")

print(f"type('hello'): {type('hello')}")
print(f"type(42): {type(42)}")
print(f"type(3.14): {type(3.14)}")
print(f"type(True): {type(True)}")
print(f"type([]): {type([])}")
print(f"type({{}}): {type({})}")
print()

print("=" * 50)
print("   DEMO COMPLETE")
print("=" * 50)
