
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

# ===== 11. ELSE WITH LOOPS =====
print("=== 11. Else with Loops ===")

target = 7
numbers = [1, 2, 3, 4, 5]

print(f"Searching for {target} in {numbers}:")
for num in numbers:
    if num == target:
        print(f"  Found {target}!")
        break
else:
    print(f"  {target} not found in list")
print()

# ===== 12. ENUMERATE WITH START INDEX =====
print("=== 12. Enumerate with Start Index ===")

tasks = ["Deploy app", "Run tests", "Notify team"]

print("Task List:")
for index, task in enumerate(tasks, start=1):
    print(f"  {index}. {task}")
print()

# ===== 13. ZIP - PARALLEL ITERATION =====
print("=== 13. Zip - Parallel Iteration ===")

server_names = ["web01", "web02", "db01"]
server_ips = ["192.168.1.10", "192.168.1.11", "192.168.1.20"]
server_ports = [8080, 8080, 5432]

print("Server Configuration:")
for name, ip, port in zip(server_names, server_ips, server_ports):
    print(f"  {name}: {ip}:{port}")
print()

print("=" * 50)
print("   LOOPS DEMO COMPLETE")
print("=" * 50)
