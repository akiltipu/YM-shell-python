#!/usr/bin/env python3

print("=" * 50)
print("   CONDITIONALS IN PYTHON")
print("=" * 50)
print()

# ===== 1. BASIC IF-ELSE =====
print("=== 1. Basic if-else ===")

cpu_usage = 75

if cpu_usage < 50:
    print(f"CPU Usage: {cpu_usage}% - NORMAL")
elif cpu_usage < 80:
    print(f"CPU Usage: {cpu_usage}% - WARNING")
else:
    print(f"CPU Usage: {cpu_usage}% - CRITICAL")
print()

# ===== 2. MULTIPLE CONDITIONS =====
print("=== 2. Multiple Conditions ===")

memory_usage = 85
disk_usage = 60

if memory_usage > 80 and disk_usage > 80:
    print("ALERT: Both memory and disk are critical!")
elif memory_usage > 80 or disk_usage > 80:
    print("WARNING: One resource is running high")
else:
    print("All systems normal")
print()

# ===== 3. NESTED CONDITIONS =====
print("=== 3. Nested Conditions ===")

server_status = "running"
environment = "production"

if server_status == "running":
    if environment == "production":
        print("Production server is running - DO NOT RESTART")
    else:
        print("Non-production server is running")
else:
    print("Server is not running")
print()

# ===== 4. TERNARY OPERATOR =====
print("=== 4. Ternary Operator (Inline if-else) ===")

port = 443
protocol = "HTTPS" if port == 443 else "HTTP"
print(f"Port {port} uses {protocol}")
print()

# ===== 5. CHECKING NONE AND EMPTY VALUES =====
print("=== 5. Checking None and Empty Values ===")

config = None
servers = []
name = ""

# Check None
if config is None:
    print("Config is not set")

# Check empty list
if not servers:
    print("No servers defined")

# Check empty string
if not name:
    print("Name is empty")
print()

# ===== 6. ENVIRONMENT-BASED CONFIG =====
print("=== 6. Environment-Based Configuration ===")

env = "production"

if env == "development":
    config = {
        "debug": True,
        "db_host": "localhost",
        "log_level": "DEBUG"
    }
elif env == "staging":
    config = {
        "debug": True,
        "db_host": "staging-db.company.com",
        "log_level": "INFO"
    }
elif env == "production":
    config = {
        "debug": False,
        "db_host": "prod-db.company.com",
        "log_level": "ERROR"
    }
else:
    config = {"debug": True, "db_host": "localhost", "log_level": "DEBUG"}

print(f"Environment: {env}")
print(f"Config: {config}")
print()

# ===== 7. STRING COMPARISONS =====
print("=== 7. String Comparisons ===")

status = "running"

if status == "running":
    print("Service is UP")
elif status == "stopped":
    print("Service is DOWN")
elif status == "starting":
    print("Service is STARTING")
else:
    print(f"Unknown status: {status}")
print()

# ===== 8. MEMBERSHIP TESTING =====
print("=== 8. Membership Testing ===")

allowed_environments = ["dev", "staging", "prod"]
current_env = "prod"

if current_env in allowed_environments:
    print(f"'{current_env}' is a valid environment")
else:
    print(f"'{current_env}' is NOT a valid environment")
print()

# ===== 9. TYPE CHECKING =====
print("=== 9. Type Checking in Conditions ===")

value = 42

if isinstance(value, int):
    print(f"{value} is an integer")
elif isinstance(value, str):
    print(f"{value} is a string")
elif isinstance(value, list):
    print(f"{value} is a list")
print()

# ===== 10. PRACTICAL EXAMPLE - SERVER VALIDATION =====
print("=== 10. Practical Example - Server Validation ===")

server_config = {
    "name": "web-server-01",
    "ip": "192.168.1.10",
    "port": 8080,
    "ssl_enabled": True
}

errors = []

# Validate name
if not server_config.get("name"):
    errors.append("Server name is required")

# Validate IP
ip = server_config.get("ip", "")
if not ip or len(ip.split(".")) != 4:
    errors.append("Invalid IP address")

# Validate port
port = server_config.get("port", 0)
if not isinstance(port, int) or port < 1 or port > 65535:
    errors.append("Port must be between 1 and 65535")

# Report results
if errors:
    print("Validation FAILED:")
    for error in errors:
        print(f"  - {error}")
else:
    print("Validation PASSED ✓")
    print(f"Server: {server_config['name']} ({server_config['ip']}:{server_config['port']})")
print()

print("=" * 50)
print("   CONDITIONALS DEMO COMPLETE")
print("=" * 50)
