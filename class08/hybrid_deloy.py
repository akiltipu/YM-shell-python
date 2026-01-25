import subprocess
import os
import json
from datetime import datetime

print("=" * 60)
print("       HYBRID DEPLOYMENT SYSTEM")
print("=" * 60)
print()


class HybridDeployer:
    """Deployment system using both Python and Shell"""
    
    def __init__(self, config):
        self.config = config
        self.log_entries = []
    
    def log(self, message, level="INFO"):
        """Log with timestamp"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        entry = f"[{timestamp}] [{level}] {message}"
        self.log_entries.append(entry)
        print(entry)
    
    def run_shell(self, command, check=True):
        """Execute shell command"""
        self.log(f"Running: {command}")
        result = subprocess.run(
            command,
            shell=True,
            capture_output=True,
            text=True
        )
        
        if check and result.returncode != 0:
            self.log(f"Command failed: {result.stderr}", "ERROR")
            raise Exception(f"Shell command failed: {command}")
        
        return result
    
    def check_prerequisites(self):
        """Check deployment prerequisites using shell"""
        self.log("Checking prerequisites...")
        
        # Check disk space
        result = self.run_shell("df -h / | tail -1 | awk '{print $5}' | sed 's/%//'")
        disk_usage = int(result.stdout.strip())
        
        if disk_usage > 90:
            raise Exception(f"Disk usage too high: {disk_usage}%")
        
        self.log(f"Disk usage: {disk_usage}% - OK")
        
        # Check required tools
        for tool in ["git", "python3"]:
            result = self.run_shell(f"which {tool}", check=False)
            if result.returncode != 0:
                raise Exception(f"Required tool not found: {tool}")
            self.log(f"Found {tool}: OK")
        
        return True
    
    def backup(self):
        """Create backup using shell"""
        self.log("Creating backup...")
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_dir = f"/tmp/backup_{timestamp}"
        
        self.run_shell(f"mkdir -p {backup_dir}")
        self.log(f"Backup created at: {backup_dir}")
        
        return backup_dir
    
    def deploy(self):
        """Main deployment process"""
        self.log("Starting deployment...")
        
        try:
            # Phase 1: Prerequisites
            self.check_prerequisites()
            
            # Phase 2: Backup
            backup_path = self.backup()
            
            # Phase 3: Deploy (simulated)
            self.log("Deploying application...")
            self.run_shell("echo 'Simulating deployment...'")
            
            # Phase 4: Verify
            self.log("Verifying deployment...")
            self.run_shell("echo 'Deployment verified'")
            
            self.log("Deployment completed successfully!", "SUCCESS")
            return True
            
        except Exception as e:
            self.log(f"Deployment failed: {e}", "ERROR")
            return False
    
    def generate_report(self):
        """Generate deployment report"""
        return {
            "timestamp": datetime.now().isoformat(),
            "config": self.config,
            "logs": self.log_entries,
            "status": "success" if any("SUCCESS" in log for log in self.log_entries) else "failed"
        }


def main():
    config = {
        "app_name": "myapp",
        "version": "2.0.0",
        "environment": "production"
    }
    
    deployer = HybridDeployer(config)
    
    print(f"Deploying {config['app_name']} v{config['version']} to {config['environment']}")
    print()
    
    success = deployer.deploy()
    
    print()
    print("=== Deployment Report ===")
    report = deployer.generate_report()
    print(json.dumps(report, indent=2, default=str))


if __name__ == "__main__":
    main()
    print("\n" + "=" * 60)
    print("           DEMO COMPLETE")
    print("=" * 60)
