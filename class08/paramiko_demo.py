import time
from datetime import datetime

print("=" * 60)
print("           SSH AUTOMATION WITH PARAMIKO")
print("=" * 60)
print()

# Mock SSH Client for demonstration
class MockSSHClient:
    """Mock SSH client for demonstration"""
    
    def __init__(self):
        self.connected = False
        self.hostname = None
        self.username = None
    
    def connect(self, hostname, username, password=None, key_filename=None, timeout=30):
        """Simulate SSH connection"""
        print(f"Connecting to {hostname}...")
        time.sleep(0.5)
        self.connected = True
        self.hostname = hostname
        self.username = username
        print(f"Connected as {username}@{hostname}")
    
    def exec_command(self, command, timeout=30):
        """Simulate command execution"""
        print(f"Executing: {command}")
        time.sleep(0.3)
        
        # Simulated outputs
        outputs = {
            "hostname": (f"{self.hostname}\n", ""),
            "uptime": ("10:30:00 up 45 days, 3:22, 2 users, load average: 0.15, 0.10, 0.05\n", ""),
            "df -h": ("Filesystem      Size  Used Avail Use% Mounted on\n/dev/sda1       100G   45G   55G  45% /\n", ""),
            "free -h": ("              total        used        free\nMem:           16G         8G         8G\n", ""),
            "cat /etc/os-release": ('NAME="Ubuntu"\nVERSION="22.04 LTS"\n', ""),
        }
        
        stdout_data = outputs.get(command, (f"Output of: {command}\n", ""))[0]
        stderr_data = outputs.get(command, ("", ""))[1]
        
        class MockStdin:
            def write(self, data): pass
            def flush(self): pass
        
        class MockOutput:
            def __init__(self, data):
                self._data = data
            def read(self):
                return self._data.encode()
            def readlines(self):
                return [line.encode() for line in self._data.split('\n') if line]
        
        return MockStdin(), MockOutput(stdout_data), MockOutput(stderr_data)
    
    def close(self):
        """Close connection"""
        self.connected = False
        print(f"Disconnected from {self.hostname}")


# ===== 1. BASIC CONNECTION =====
print("=== 1. Basic SSH Connection ===")

ssh = MockSSHClient()

try:
    # Connect to server
    ssh.connect(
        hostname="192.168.1.10",
        username="admin",
        password="secure_password"  # In production, use key-based auth
    )
    
    # Execute command
    stdin, stdout, stderr = ssh.exec_command("hostname")
    output = stdout.read().decode().strip()
    print(f"Server hostname: {output}")
    
finally:
    ssh.close()
print()

# ===== 2. MULTIPLE COMMANDS =====
print("=== 2. Executing Multiple Commands ===")

ssh = MockSSHClient()

try:
    ssh.connect("192.168.1.10", "admin", password="password")
    
    commands = ["hostname", "uptime", "df -h", "free -h"]
    
    for cmd in commands:
        stdin, stdout, stderr = ssh.exec_command(cmd)
        output = stdout.read().decode().strip()
        print(f"\n[{cmd}]:")
        print(output)
    
finally:
    ssh.close()
print()

# ===== 3. ERROR HANDLING =====
print("=== 3. Error Handling ===")

def ssh_connect_with_retry(host, user, password, max_retries=3):
    """Connect with retry logic"""
    for attempt in range(1, max_retries + 1):
        try:
            ssh = MockSSHClient()
            ssh.connect(host, user, password=password)
            return ssh
        except Exception as e:
            print(f"Attempt {attempt} failed: {e}")
            if attempt < max_retries:
                time.sleep(2)
    return None

ssh = ssh_connect_with_retry("192.168.1.10", "admin", "password")
if ssh:
    print("Connection successful with retry!")
    ssh.close()
print()

# ===== 4. MULTI-SERVER EXECUTION =====
print("=== 4. Multi-Server Execution ===")

servers = [
    {"host": "192.168.1.10", "user": "admin", "type": "web"},
    {"host": "192.168.1.11", "user": "admin", "type": "web"},
    {"host": "192.168.1.20", "user": "admin", "type": "db"},
]

def run_on_servers(servers, command):
    """Execute command on multiple servers"""
    results = []
    
    for server in servers:
        print(f"\nConnecting to {server['host']}...")
        ssh = MockSSHClient()
        
        try:
            ssh.connect(server['host'], server['user'], password="password")
            stdin, stdout, stderr = ssh.exec_command(command)
            output = stdout.read().decode().strip()
            
            results.append({
                "host": server['host'],
                "type": server['type'],
                "output": output,
                "success": True
            })
        except Exception as e:
            results.append({
                "host": server['host'],
                "type": server['type'],
                "error": str(e),
                "success": False
            })
        finally:
            ssh.close()
    
    return results

results = run_on_servers(servers, "uptime")
print("\n=== Results Summary ===")
for r in results:
    status = "✓" if r['success'] else "✗"
    print(f"{status} {r['host']} ({r['type']}): {r.get('output', r.get('error', 'N/A'))[:50]}")
print()

print("=" * 60)
print("           DEMO COMPLETE")
print("=" * 60)
