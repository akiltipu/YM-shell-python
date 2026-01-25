import json
import random
from datetime import datetime

print("=" * 60)
print("       NETWORK MONITORING TOOL")
print("=" * 60)
print()


class NetworkMonitor:
    """Monitors network devices and performance"""
    
    def __init__(self):
        self.devices = []
        self.alerts = []
        self.metrics_history = []
    
    def add_device(self, name, ip, device_type):
        """Add device to monitoring"""
        self.devices.append({
            "name": name,
            "ip": ip,
            "type": device_type,
            "status": "unknown",
            "last_check": None
        })
    
    def check_device(self, device):
        """Check device status (simulated)"""
        # Simulate ping/health check
        latency = random.randint(1, 50)
        is_up = random.random() > 0.1  # 90% uptime
        
        device["status"] = "up" if is_up else "down"
        device["latency"] = latency if is_up else None
        device["last_check"] = datetime.now().isoformat()
        
        # Generate alert if down
        if not is_up:
            self.alerts.append({
                "device": device["name"],
                "type": "DOWN",
                "timestamp": device["last_check"],
                "message": f"{device['name']} is unreachable"
            })
        
        return device
    
    def run_check(self):
        """Check all devices"""
        print("=== Running Health Check ===")
        
        for device in self.devices:
            print(f"Checking {device['name']} ({device['ip']})...", end=" ")
            self.check_device(device)
            
            if device["status"] == "up":
                print(f"✓ UP (latency: {device['latency']}ms)")
            else:
                print("✗ DOWN")
        
        return self.devices
    
    def get_alerts(self):
        """Get all alerts"""
        return self.alerts
    
    def clear_alerts(self):
        """Clear all alerts"""
        self.alerts = []
    
    def generate_report(self):
        """Generate monitoring report"""
        up_count = sum(1 for d in self.devices if d["status"] == "up")
        down_count = sum(1 for d in self.devices if d["status"] == "down")
        
        report = {
            "timestamp": datetime.now().isoformat(),
            "summary": {
                "total_devices": len(self.devices),
                "up": up_count,
                "down": down_count,
                "uptime_percentage": (up_count / len(self.devices) * 100) if self.devices else 0
            },
            "devices": self.devices,
            "alerts": self.alerts
        }
        
        return report


def main():
    monitor = NetworkMonitor()
    
    # Add devices to monitor
    print("=== Adding Devices ===")
    devices_to_add = [
        ("router-main", "192.168.1.1", "router"),
        ("switch-core", "192.168.1.2", "switch"),
        ("firewall-edge", "192.168.1.3", "firewall"),
        ("server-web01", "192.168.1.10", "server"),
        ("server-db01", "192.168.1.20", "server"),
    ]
    
    for name, ip, dtype in devices_to_add:
        monitor.add_device(name, ip, dtype)
        print(f"  Added: {name} ({ip})")
    print()
    
    # Run health check
    monitor.run_check()
    print()
    
    # Check alerts
    alerts = monitor.get_alerts()
    if alerts:
        print("=== Alerts ===")
        for alert in alerts:
            print(f"  ⚠ {alert['device']}: {alert['message']}")
    else:
        print("=== No Alerts ===")
    print()
    
    # Generate report
    print("=== Monitoring Report ===")
    report = monitor.generate_report()
    
    print(f"Timestamp: {report['timestamp']}")
    print(f"Total Devices: {report['summary']['total_devices']}")
    print(f"Up: {report['summary']['up']}")
    print(f"Down: {report['summary']['down']}")
    print(f"Uptime: {report['summary']['uptime_percentage']:.1f}%")


if __name__ == "__main__":
    main()
    print("\n" + "=" * 60)
    print("           DEMO COMPLETE")
    print("=" * 60)