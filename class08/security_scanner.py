import re
import json
from datetime import datetime

print("=" * 60)
print("       SECURITY SCANNING AUTOMATION")
print("=" * 60)
print()


class SASTScanner:
    """Static Application Security Testing Scanner"""
    
    def __init__(self):
        self.vulnerabilities = []
        self.patterns = {
            "hardcoded_password": r'password\s*=\s*["\'][^"\']+["\']',
            "hardcoded_api_key": r'api_key\s*=\s*["\'][^"\']+["\']',
            "sql_injection": r'execute\s*\([^)]*\+[^)]*\)',
            "command_injection": r'os\.system\s*\([^)]*\+[^)]*\)',
            "insecure_hash": r'md5\s*\(|sha1\s*\(',
            "eval_usage": r'\beval\s*\(',
            "exec_usage": r'\bexec\s*\(',
        }
    
    def scan_code(self, code, filename="code.py"):
        """Scan code for vulnerabilities"""
        findings = []
        lines = code.split('\n')
        
        for line_num, line in enumerate(lines, 1):
            for vuln_type, pattern in self.patterns.items():
                if re.search(pattern, line, re.IGNORECASE):
                    findings.append({
                        "type": vuln_type,
                        "file": filename,
                        "line": line_num,
                        "code": line.strip(),
                        "severity": self._get_severity(vuln_type)
                    })
        
        self.vulnerabilities.extend(findings)
        return findings
    
    def _get_severity(self, vuln_type):
        """Get severity level for vulnerability type"""
        high = ["hardcoded_password", "sql_injection", "command_injection"]
        medium = ["hardcoded_api_key", "eval_usage", "exec_usage"]
        
        if vuln_type in high:
            return "HIGH"
        elif vuln_type in medium:
            return "MEDIUM"
        return "LOW"
    
    def get_report(self):
        """Generate scan report"""
        return {
            "scan_type": "SAST",
            "timestamp": datetime.now().isoformat(),
            "total_findings": len(self.vulnerabilities),
            "by_severity": {
                "HIGH": len([v for v in self.vulnerabilities if v["severity"] == "HIGH"]),
                "MEDIUM": len([v for v in self.vulnerabilities if v["severity"] == "MEDIUM"]),
                "LOW": len([v for v in self.vulnerabilities if v["severity"] == "LOW"])
            },
            "findings": self.vulnerabilities
        }


class DASTScanner:
    """Dynamic Application Security Testing Scanner (Simulated)"""
    
    def __init__(self, target_url):
        self.target_url = target_url
        self.findings = []
    
    def check_headers(self):
        """Check security headers (simulated)"""
        missing_headers = [
            {"header": "X-Frame-Options", "severity": "MEDIUM"},
            {"header": "Content-Security-Policy", "severity": "HIGH"},
            {"header": "X-Content-Type-Options", "severity": "LOW"},
        ]
        
        for h in missing_headers:
            self.findings.append({
                "type": "missing_security_header",
                "header": h["header"],
                "severity": h["severity"],
                "url": self.target_url
            })
    
    def check_ssl(self):
        """Check SSL/TLS configuration (simulated)"""
        self.findings.append({
            "type": "ssl_check",
            "issue": "TLS 1.0 enabled",
            "severity": "HIGH",
            "url": self.target_url
        })
    
    def scan(self):
        """Run all DAST checks"""
        self.check_headers()
        self.check_ssl()
        return self.findings
    
    def get_report(self):
        """Generate DAST report"""
        return {
            "scan_type": "DAST",
            "target": self.target_url,
            "timestamp": datetime.now().isoformat(),
            "total_findings": len(self.findings),
            "findings": self.findings
        }


def main():
    # ===== SAST DEMO =====
    print("=== SAST Scanning ===\n")
    
    vulnerable_code = '''
# Example vulnerable code
password = "admin123"
api_key = "sk-secret-key-12345"

def get_user(user_id):
    query = "SELECT * FROM users WHERE id = " + user_id
    cursor.execute(query)
    
def run_command(cmd):
    os.system("ls " + cmd)
    
hash_value = md5(password)
result = eval(user_input)
'''
    
    sast = SASTScanner()
    findings = sast.scan_code(vulnerable_code, "vulnerable_app.py")
    
    print("SAST Findings:")
    for f in findings:
        print(f"  [{f['severity']}] {f['type']} at line {f['line']}")
    
    print("\n" + "="*40)
    sast_report = sast.get_report()
    print(f"Total Findings: {sast_report['total_findings']}")
    print(f"High: {sast_report['by_severity']['HIGH']}")
    print(f"Medium: {sast_report['by_severity']['MEDIUM']}")
    print(f"Low: {sast_report['by_severity']['LOW']}")
    
    # ===== DAST DEMO =====
    print("\n\n=== DAST Scanning ===\n")
    
    dast = DASTScanner("https://example.com")
    dast.scan()
    
    dast_report = dast.get_report()
    print(f"Target: {dast_report['target']}")
    print(f"Findings: {dast_report['total_findings']}")
    
    for f in dast_report['findings']:
        print(f"  [{f['severity']}] {f['type']}: {f.get('header', f.get('issue', 'N/A'))}")


if __name__ == "__main__":
    main()
    print("\n" + "=" * 60)
    print("           DEMO COMPLETE")
    print("=" * 60)
