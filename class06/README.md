# Class `06`
# Python Fundamentals for DevOps

#### Why Python is Essential for DevOps
Python has become a cornerstone in the DevOps ecosystem due to its versatility, ease of use, and extensive libraries. Here are some reasons why Python is essential for DevOps:
### Installing Python and Setting Up Your Environment

#### Python Installation

**Check if Python is Installed:**
```bash
# Check Python version
python3 --version

# Alternative command
python --version

# Check pip (package manager)
pip3 --version
```

**Installing Python on Different Systems:**

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip python3-venv

# CentOS/RHEL
sudo yum install python3 python3-pip

# macOS (using Homebrew)
brew install python3

# Windows
# Download from python.org and run installer
# Make sure to check "Add Python to PATH"
```

### Basic Syntax, Data Types, and Control Flow

#### Python Basic Syntax

**The Anatomy of a Python Script:**

```python
#!/usr/bin/env python3
"""
Script: hello_devops.py
Description: Introduction to Python syntax
Author: DevOps Engineer
Date: 2025-11-30
"""

# This is a single-line comment

"""
This is a
multi-line comment (docstring)
"""

# Print statement
print("Hello, DevOps World!")

# Variables (no type declaration needed)
name = "DevOps Engineer"
years_experience = 5
is_certified = True

# String formatting
print(f"Welcome, {name}!")
print(f"Experience: {years_experience} years")
print(f"Certified: {is_certified}")
```

**Key Differences from Shell Scripting:**

| Feature | Shell | Python |
|---------|-------|--------|
| Variables | `name="value"` | `name = "value"` |
| Comments | `# comment` | `# comment` |
| Print | `echo "text"` | `print("text")` |
| Indentation | Optional | Required (defines blocks) |
| Quotes | `"` or `'` | `"` or `'` (same behavior) |

---

#### Variables and Data Types

Create `variables_demo.py`:

```python
#!/usr/bin/env python3
"""
Variables and Data Types in Python
"""

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
```

---

#### Operators

```python
#!/usr/bin/env python3
"""
Python Operators Reference
"""

# Arithmetic Operators
print("=== Arithmetic Operators ===")
a, b = 10, 3
print(f"{a} + {b} = {a + b}")   # Addition
print(f"{a} - {b} = {a - b}")   # Subtraction
print(f"{a} * {b} = {a * b}")   # Multiplication
print(f"{a} / {b} = {a / b}")   # Division (float)
print(f"{a} // {b} = {a // b}") # Floor division
print(f"{a} % {b} = {a % b}")   # Modulo
print(f"{a} ** {b} = {a ** b}") # Exponentiation
print()

# Comparison Operators
print("=== Comparison Operators ===")
x, y = 5, 10
print(f"{x} == {y}: {x == y}")  # Equal
print(f"{x} != {y}: {x != y}")  # Not equal
print(f"{x} > {y}: {x > y}")    # Greater than
print(f"{x} < {y}: {x < y}")    # Less than
print(f"{x} >= {y}: {x >= y}")  # Greater or equal
print(f"{x} <= {y}: {x <= y}")  # Less or equal
print()

# Logical Operators
print("=== Logical Operators ===")
p, q = True, False
print(f"{p} and {q}: {p and q}")
print(f"{p} or {q}: {p or q}")
print(f"not {p}: {not p}")
print()

# Membership Operators
print("=== Membership Operators ===")
servers = ["web01", "db01", "cache01"]
print(f"'web01' in servers: {'web01' in servers}")
print(f"'app01' in servers: {'app01' in servers}")
print(f"'app01' not in servers: {'app01' not in servers}")
```

---

### Conditionals and Loops

#### Conditional Statements

Create `conditionals_demo.py`:

```python
#!/usr/bin/env python3
"""
Conditional Statements in Python
"""

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

# ===== 7. MATCH-CASE (Python 3.10+) =====
print("=== 7. Match-Case Statement (Python 3.10+) ===")

try:
    action = "deploy"
    
    match action:
        case "start":
            print("Starting service...")
        case "stop":
            print("Stopping service...")
        case "restart":
            print("Restarting service...")
        case "deploy":
            print("Deploying application...")
        case _:
            print("Unknown action")
except SyntaxError:
    print("Match-case requires Python 3.10+")
print()

print("=" * 50)
print("   CONDITIONALS DEMO COMPLETE")
print("=" * 50)
```

---

#### Loops

Create `loops_demo.py`:

```python
#!/usr/bin/env python3
"""
Loops in Python
"""

print("=" * 50)
print("   LOOPS IN PYTHON")
print("=" * 50)
print()

# ===== 1. FOR LOOP - BASIC =====
print("=== 1. For Loop - Basic ===")

servers = ["web01", "web02", "db01", "cache01"]

for server in servers:
    print(f"Processing: {server}")
print()

# ===== 2. FOR LOOP - WITH INDEX =====
print("=== 2. For Loop - With Index ===")

for index, server in enumerate(servers):
    print(f"  [{index}] {server}")
print()

# ===== 3. FOR LOOP - RANGE =====
print("=== 3. For Loop - Range ===")

print("Range(5):")
for i in range(5):
    print(f"  Iteration: {i}")

print("\nRange(1, 6):")
for i in range(1, 6):
    print(f"  Iteration: {i}")

print("\nRange(0, 10, 2):")
for i in range(0, 10, 2):
    print(f"  Iteration: {i}")
print()

# ===== 4. FOR LOOP - DICTIONARY =====
print("=== 4. For Loop - Dictionary ===")

server_config = {
    "name": "web-server-01",
    "ip": "192.168.1.10",
    "port": 8080,
    "status": "running"
}

# Keys only
print("Keys:")
for key in server_config:
    print(f"  {key}")

# Key-value pairs
print("\nKey-Value pairs:")
for key, value in server_config.items():
    print(f"  {key}: {value}")
print()

# ===== 5. WHILE LOOP =====
print("=== 5. While Loop ===")

retry_count = 0
max_retries = 3

while retry_count < max_retries:
    retry_count += 1
    print(f"  Attempt {retry_count} of {max_retries}")
    # Simulate check
    if retry_count == 3:
        print("  Connection successful!")
        break
print()

# ===== 6. LOOP CONTROL - BREAK & CONTINUE =====
print("=== 6. Loop Control - break & continue ===")

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

print("Skip even numbers (continue):")
for num in numbers:
    if num % 2 == 0:
        continue
    print(f"  {num}")

print("\nStop at 5 (break):")
for num in numbers:
    if num > 5:
        break
    print(f"  {num}")
print()

# ===== 7. LIST COMPREHENSION =====
print("=== 7. List Comprehension ===")

# Traditional loop
squares_traditional = []
for x in range(1, 6):
    squares_traditional.append(x ** 2)
print(f"Traditional: {squares_traditional}")

# List comprehension
squares_comprehension = [x ** 2 for x in range(1, 6)]
print(f"Comprehension: {squares_comprehension}")

# With condition
even_squares = [x ** 2 for x in range(1, 11) if x % 2 == 0]
print(f"Even squares: {even_squares}")
print()

# ===== 8. DICTIONARY COMPREHENSION =====
print("=== 8. Dictionary Comprehension ===")

servers = ["web01", "web02", "db01"]
server_ports = {server: 8080 + i for i, server in enumerate(servers)}
print(f"Server ports: {server_ports}")
print()

# ===== 9. NESTED LOOPS =====
print("=== 9. Nested Loops ===")

environments = ["dev", "staging", "prod"]
services = ["web", "api", "db"]

print("Environment-Service Matrix:")
for env in environments:
    for service in services:
        print(f"  {env}-{service}")
print()

# ===== 10. PRACTICAL EXAMPLE - SERVER HEALTH CHECK =====
print("=== 10. Practical Example - Server Health Check ===")

servers = [
    {"name": "web01", "status": "running", "cpu": 45},
    {"name": "web02", "status": "running", "cpu": 78},
    {"name": "db01", "status": "stopped", "cpu": 0},
    {"name": "cache01", "status": "running", "cpu": 92}
]

print("Server Health Report:")
for server in servers:
    name = server["name"]
    status = server["status"]
    cpu = server["cpu"]
    
    if status != "running":
        alert = "DOWN"
    elif cpu > 80:
        alert = "HIGH CPU"
    else:
        alert = "OK"
    
    print(f"  {name}: {status} (CPU: {cpu}%) - {alert}")
print()

print("=" * 50)
print("   LOOPS DEMO COMPLETE")
print("=" * 50)
```

---

### Practical: Writing and Running Simple Python Scripts

#### Practical 1: System Information Script

Create `system_info.py`:

```python
#!/usr/bin/env python3
"""
System Information Script
Demonstrates basic Python scripting for DevOps
"""

import os
import platform
import datetime

print("=" * 60)
print("           SYSTEM INFORMATION REPORT")
print("=" * 60)
print()

# ===== SYSTEM DETAILS =====
print("=== System Details ===")
print(f"Hostname: {platform.node()}")
print(f"Operating System: {platform.system()}")
print(f"OS Release: {platform.release()}")
print(f"OS Version: {platform.version()}")
print(f"Architecture: {platform.machine()}")
print(f"Processor: {platform.processor()}")
print()

# ===== PYTHON ENVIRONMENT =====
print("=== Python Environment ===")
print(f"Python Version: {platform.python_version()}")
print(f"Python Implementation: {platform.python_implementation()}")
print(f"Python Compiler: {platform.python_compiler()}")
print()

# ===== USER INFORMATION =====
print("=== User Information ===")
print(f"Current User: {os.getenv('USER', 'unknown')}")
print(f"Home Directory: {os.path.expanduser('~')}")
print(f"Current Directory: {os.getcwd()}")
print()

# ===== ENVIRONMENT VARIABLES =====
print("=== Key Environment Variables ===")
env_vars = ['PATH', 'HOME', 'SHELL', 'LANG']
for var in env_vars:
    value = os.getenv(var, 'Not set')
    # Truncate long values
    if len(str(value)) > 50:
        value = str(value)[:50] + "..."
    print(f"  {var}: {value}")
print()

# ===== TIMESTAMP =====
print("=== Report Generated ===")
print(f"Date: {datetime.datetime.now().strftime('%Y-%m-%d')}")
print(f"Time: {datetime.datetime.now().strftime('%H:%M:%S')}")
print(f"Timezone: {datetime.datetime.now().astimezone().tzname()}")
print()

print("=" * 60)
print("           REPORT COMPLETE")
print("=" * 60)
```

---

#### Practical 2: Server Health Checker

Create `health_check.py`:

```python
#!/usr/bin/env python3
"""
Simple Server Health Check Script
Demonstrates conditionals, loops, and functions
"""

import random
from datetime import datetime

print("=" * 60)
print("           SERVER HEALTH CHECK")
print("=" * 60)
print()

# Simulated server data
servers = [
    {"name": "web-server-01", "ip": "192.168.1.10", "port": 8080},
    {"name": "web-server-02", "ip": "192.168.1.11", "port": 8080},
    {"name": "api-server-01", "ip": "192.168.1.20", "port": 3000},
    {"name": "db-server-01", "ip": "192.168.1.30", "port": 5432},
    {"name": "cache-server-01", "ip": "192.168.1.40", "port": 6379},
]


def check_server_status(server):
    """
    Simulate server health check
    Returns: tuple (is_healthy, response_time, cpu_usage, memory_usage)
    """
    # Simulate random health metrics
    is_healthy = random.choice([True, True, True, False])  # 75% healthy
    response_time = random.randint(5, 500) if is_healthy else -1
    cpu_usage = random.randint(10, 95)
    memory_usage = random.randint(20, 90)
    
    return is_healthy, response_time, cpu_usage, memory_usage


def get_status_color(status):
    """Return status indicator"""
    if status == "HEALTHY":
        return "✓"
    elif status == "WARNING":
        return "⚠"
    else:
        return "✗"


def generate_report():
    """Generate health report for all servers"""
    report = []
    healthy_count = 0
    warning_count = 0
    critical_count = 0
    
    for server in servers:
        is_healthy, response_time, cpu, memory = check_server_status(server)
        
        # Determine status
        if not is_healthy:
            status = "DOWN"
            critical_count += 1
        elif response_time > 200 or cpu > 80 or memory > 80:
            status = "WARNING"
            warning_count += 1
        else:
            status = "HEALTHY"
            healthy_count += 1
        
        report.append({
            "server": server,
            "status": status,
            "response_time": response_time,
            "cpu": cpu,
            "memory": memory
        })
    
    return report, healthy_count, warning_count, critical_count


# Generate and display report
print(f"Check Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
print()

report, healthy, warning, critical = generate_report()

print("=== Server Status ===")
print()

for entry in report:
    server = entry["server"]
    status = entry["status"]
    indicator = get_status_color(status)
    
    print(f"{indicator} {server['name']}")
    print(f"    IP: {server['ip']}:{server['port']}")
    print(f"    Status: {status}")
    
    if entry["response_time"] > 0:
        print(f"    Response Time: {entry['response_time']}ms")
        print(f"    CPU: {entry['cpu']}%")
        print(f"    Memory: {entry['memory']}%")
    else:
        print(f"    Response Time: N/A (Server Down)")
    print()

print("=== Summary ===")
print(f"Total Servers: {len(servers)}")
print(f"Healthy: {healthy}")
print(f"Warning: {warning}")
print(f"Critical: {critical}")
print()

# Determine overall status
if critical > 0:
    overall = "CRITICAL - Immediate action required!"
elif warning > 0:
    overall = "WARNING - Monitor closely"
else:
    overall = "ALL SYSTEMS OPERATIONAL"

print(f"Overall Status: {overall}")
print()

print("=" * 60)
print("           CHECK COMPLETE")
print("=" * 60)
```

---

#### Practical 3: Configuration File Generator

Create `config_generator.py`:

```python
#!/usr/bin/env python3
"""
Configuration File Generator
Generates environment-specific configuration files
"""

import json
import os
from datetime import datetime

print("=" * 60)
print("        CONFIGURATION FILE GENERATOR")
print("=" * 60)
print()

# Configuration templates
CONFIG_TEMPLATES = {
    "development": {
        "debug": True,
        "log_level": "DEBUG",
        "database": {
            "host": "localhost",
            "port": 5432,
            "name": "devops_dev",
            "pool_size": 5
        },
        "cache": {
            "host": "localhost",
            "port": 6379,
            "ttl": 300
        },
        "api": {
            "rate_limit": 1000,
            "timeout": 30
        }
    },
    "staging": {
        "debug": True,
        "log_level": "INFO",
        "database": {
            "host": "staging-db.company.com",
            "port": 5432,
            "name": "devops_staging",
            "pool_size": 10
        },
        "cache": {
            "host": "staging-cache.company.com",
            "port": 6379,
            "ttl": 600
        },
        "api": {
            "rate_limit": 500,
            "timeout": 30
        }
    },
    "production": {
        "debug": False,
        "log_level": "ERROR",
        "database": {
            "host": "prod-db.company.com",
            "port": 5432,
            "name": "devops_prod",
            "pool_size": 50
        },
        "cache": {
            "host": "prod-cache.company.com",
            "port": 6379,
            "ttl": 3600
        },
        "api": {
            "rate_limit": 100,
            "timeout": 15
        }
    }
}


def generate_config(environment):
    """Generate configuration for specified environment"""
    if environment not in CONFIG_TEMPLATES:
        print(f"Error: Unknown environment '{environment}'")
        print(f"Available environments: {list(CONFIG_TEMPLATES.keys())}")
        return None
    
    config = CONFIG_TEMPLATES[environment].copy()
    config["environment"] = environment
    config["generated_at"] = datetime.now().isoformat()
    config["version"] = "1.0.0"
    
    return config


def save_config(config, filename):
    """Save configuration to JSON file"""
    with open(filename, 'w') as f:
        json.dump(config, f, indent=2)
    print(f"✓ Configuration saved to: {filename}")


def display_config(config):
    """Display configuration in readable format"""
    print(json.dumps(config, indent=2))


# Main execution
environments = ["development", "staging", "production"]

print("Generating configurations for all environments...")
print()

for env in environments:
    print(f"=== {env.upper()} Configuration ===")
    
    config = generate_config(env)
    
    if config:
        # Display configuration
        display_config(config)
        
        # Save to file
        filename = f"config_{env}.json"
        save_config(config, filename)
    
    print()

# Cleanup generated files
print("=== Cleanup ===")
for env in environments:
    filename = f"config_{env}.json"
    if os.path.exists(filename):
        os.remove(filename)
        print(f"✓ Removed: {filename}")

print()
print("=" * 60)
print("        GENERATOR COMPLETE")
print("=" * 60)
```

---

### Wrap-up & Q&A

#### Summary & Key Takeaways

**Recap:**
```
What We Learned Today:
  1. Why Python is essential for DevOps
  2. Setting up Python environment
  3. Variables, data types, and operators
  4. Conditionals (if/elif/else)
  5. Loops (for/while) and comprehensions
  6. Writing practical DevOps scripts

Skills Gained:
  - Writing Python scripts for automation
  - Understanding Python data structures
  - Using conditionals and loops effectively
  - Building configuration generators
  - Creating health check scripts
```

---

#### Homework Assignment

**Assignment:**
```python
# Create a "DevOps Environment Manager" script that:
# 1. Manages server inventory (add, remove, list)
# 2. Generates configuration for different environments
# 3. Simulates health checks
# 4. Creates deployment manifests
# 5. Logs all operations with timestamps

# Bonus: Add input validation
# Bonus: Create a menu-driven interface
# Bonus: Save/load state from JSON file
```

**Resources to Share:**
```
Learning Resources:
- Python Documentation: https://docs.python.org/3/
- Real Python: https://realpython.com/
- Python for DevOps: https://www.pythonfordevops.com/
- Practice: https://www.hackerrank.com/domains/python

```

---

## Message

```
"Congratulations on completing Class 06!

You've taken the first step into Python for DevOps.
The fundamentals you learned today - variables, data types,
conditionals, and loops - are the building blocks of all
automation scripts you'll write.

Python's readability and power make it the perfect companion
to your shell scripting skills. Together, they give you
the ability to automate virtually anything.

Practice writing small scripts daily. Start by converting
some of your shell scripts to Python. Notice how the syntax
differs and where Python shines.

Ready for Class 07? We'll dive into file handling and
system administration with Python!"
```

---

**Keep coding and automating!**
