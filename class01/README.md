# Class `01`
# Introduction to Shell Scripting and Fundamentals




#### History and Importance


**The Story of Shell:**
```
1970s: Unix Shell created by Ken Thompson
1977: Bourne Shell (sh) - the foundation
1989: Bash (Bourne Again Shell) - most popular today
2000s+: Shell scripting becomes DevOps essential
```
### When not to use shell scripts
- **Resource-intensive tasks**, especially where speed is a factor (e.g., sorting, hashing, etc.)
- **Procedures involving heavy-duty math operations**, especially floating-point arithmetic, arbitrary precision calculations, or complex numbers (use C++, Fortran, etc., instead)
- **Cross-platform portability required** (use C, Java, or other portable languages instead)
- **Complex applications** where structured programming is necessary (e.g., type-checking, function prototypes, etc.)
- **Mission-critical applications** upon which the success (or survival) of a company depends
- **Security-sensitive situations** where system integrity must be guaranteed and protected against intrusion, cracking, or vandalism
- **Projects with subcomponents and interlocking dependencies**
- **Extensive file operations** (Bash supports only serial, line-by-line file access, which is clumsy and inefficient)
- **Need for native support for multi-dimensional arrays**
- **Need for advanced data structures**, such as linked lists, trees, or graphs
- **Graphics or GUI generation/manipulation**
- **Direct access to system hardware**
- **Port or socket I/O requirements**
- **Integration with external libraries or legacy code**
- **Proprietary, closed-source applications** (shell scripts expose source code openly)

> *If any of the above apply, consider using a more powerful scripting language
> (e.g., Python, Perl, Ruby, Tcl) or a compiled language (e.g., C, C++, Java). 
> That said, prototyping in a shell script can still be a useful initial development step.*



**Why Shell Scripting Matters in DevOps:**

**Universal Availability:** Shell scripts run on virtually every Unix-like system without requiring additional software installations. When you SSH into a Linux server, the shell is already there, ready to execute your automation logic.

**Simplicity and Speed:** For straightforward automation tasks like file manipulation, process management, or system monitoring, shell scripts offer the fastest path from problem to solution. There's no compilation step, no complex setup, just write and execute.

**Integration Power:** Shell scripts excel at gluing together different tools and commands. In DevOps, where you might need to coordinate Git operations, Docker commands, AWS CLI calls, and database backups in a single workflow, shell scripting provides the connective tissue.

| Use Case | Example |
|----------|---------|
| **Automation** | Automated deployments, backups |
| **CI/CD Pipelines** | Jenkins, GitLab CI scripts |
| **Server Management** | Log rotation, monitoring |
| **Cloud Operations** | AWS CLI automation, resource provisioning |
| **Container Orchestration** | Docker startup scripts, K8s init containers |
| **Database** | Database init script |


**Real-World Example in DevOps:**

- Automated Deployment (CI/CD Pipelines)
- Auto-Scaling Based on Shopping Events
- Automated Load Testing Pipeline
- Automated Disaster Recovery Testing
- Real-Time Service Health Monitoring
- Automated SSL Certificate Renewal
- Multi-Region Disaster Recovery Orchestration
- Automated Code Coverage Enforcement
- Automated Database Migration Testing
- Compliance and Security Audit Automation
- Canary Deployment Automation
- IoT Device Fleet Management
- Automated Incident Response and Remediation
- Environment Configuration

---

### What Is a Shell?

A **shell** is a command-line interpreter that acts as an interface between the user and the operating system’s kernel. It reads commands from the user (or from a script), interprets them, and executes the corresponding programs. Common shells include **Bash**, **Zsh**, **Ksh**, and **sh**. The shell provides features like command history, tab completion, variables, and scripting capabilities, making it a powerful tool for system administration and automation.

---

### How Shell Scripts Work (and the Role of the Kernel)

A **shell script** is a plain text file containing a sequence of shell commands. When you run the script:

1. The system **invokes the shell** (e.g., `/bin/bash`) specified in the script’s shebang line (`#!/bin/bash`).
2. The shell **reads the script line by line**, parsing and interpreting each command.
3. For each command (e.g., `ls`, `cp`, `grep`), the shell **asks the kernel** to launch a new process by making a system call (typically `fork()` and `exec()`).
4. The **kernel**—the core of the OS—manages hardware, memory, and processes, and executes the requested programs securely and efficiently.
5. The shell **waits for each command to finish** (unless run in the background) and may use its output or exit status for conditional logic.

In essence, the shell acts as a **conductor**, orchestrating interactions between the user, scripts, and the kernel, while the **kernel** does the actual low-level work of running programs and managing system resources.

#### Types of Shells

```bash
# Show current shell
echo $SHELL

# List available shells
cat /etc/shells
```

**Common Shells Overview:**

| Shell | Symbol | Best For | DevOps Usage |
|-------|--------|----------|--------------|
| **Bash** | `#!/bin/bash` | General automation | 90% of scripts |
| **ZSH** | `#!/bin/zsh` | Interactive use | macOS default |
| **SH** | `#!/bin/sh` | POSIX compliance | Universal scripts |
| **Fish** | `#!/bin/fish` | User-friendly | Personal productivity |

**Bash version:**
```bash
# Show Bash version
bash --version

# Show you're in bash
ps -p $$
```
*"For this course, we'll use Bash - it's everywhere!"*

---

### Shell Script Fundamentals

#### Basic Syntax & Structure 
**Anatomy of a Shell Script:**

```bash
#!/bin/bash
# This is the shebang - tells system which interpreter to use

# Comments start with #
# Good scripts have lots of comments!

# Script metadata (best practice)
# Author: Akil Tipu
# Date: 2025-11-23
# Purpose: Demonstrate shell script structure

# Main script logic starts here
echo "Hello, DevOps World!"
```

**Explanation of Each Part:**

1. **Shebang (`#!/bin/bash`)**: 
   - Must be first line
   - Tells OS which interpreter to use
   - Without it, script may run in wrong shell

2. **Comments (`#`)**:
   - Document your code

3. **Commands**:
   - Regular Linux commands work here
   - Each command on new line (usually)

---

#### Creating & Running First Script

**Step by Step:**

**Step 1: Create the script**
```bash
# Create a directory for our class
mkdir ~/shell-class-01
cd ~/shell-class-01

# Create first script
vim hello.sh
# Or use: nano hello.sh
# Or use: code hello.sh
```

**Step 2: Write the script**
```bash
#!/bin/bash
# My First Shell Script
# Author: [Akil Tipu]
# Date: November 23, 2025

echo "================================"
echo "   Welcome to Shell Scripting   "
echo "================================"
echo ""
echo "Hello, DevOps Engineer!"
echo "Today's date is: $(date)"
echo "Current user: $(whoami)"
echo "Current directory: $(pwd)"
```

**Step 3: Save and exit**
- vim: `Esc`, then `:wq`
- VS Code: `Ctrl + S`

### **Step 4: Make It Executable** 

By default, a newly created script file has only **read and write** permissions for the owner, and **read-only** for others—**not executable**. To run it as a program, you must give it **execute permission**.

```bash
# Check current permissions
ls -l hello.sh

# Add execute permission for owner, group, and others
chmod +x hello.sh

# Verify the permissions changed
ls -l hello.sh
```

#### **Understanding the Permissions**

**Before (`chmod +x`):**
```
-rw-r--r--   ← Not executable
```

**After (`chmod +x`):**
```
-rwxr-xr-x   ← Now executable
```

The `x` (execute) bits are added as follows:

```
-rwxr-xr-x
 ^^^ ^ ^ 
 ||| | |
 ||| | +-- Others (everyone else) can execute
 ||| +---- Group members can execute
 ||+------ Owner (user) can execute
```

> 💡 **A Better Way to Set Permissions Explicitly**  
While `chmod +x` works, it adds execute permission for **all** classes (user/group/others). For better control and security, you can specify exactly who should get execute access:

```bash
# Only allow the owner to execute (recommended for personal scripts)
chmod u+x hello.sh

# Allow owner and group to execute
chmod ug+x hello.sh

# Set precise permissions using octal notation (e.g., 755 = rwxr-xr-x)
chmod 755 hello.sh
```

This ensures your script is executable **only by those who need to run it**, following the principle of least privilege.


**Step 5: Run the script**
```bash
# Method 1: Using ./
./hello.sh

# Method 2: Using bash directly
bash hello.sh

# Method 3: Using full path
/home/username/shell-class-01/hello.sh
```

---

### Variables & Data Handling

#### 3.1 Variable Declaration & Usage

**Variables Naming conventions**

```bash
# Variable naming rules:
# Can contain: letters, numbers, underscores
# Must start with: letter or underscore
# Case sensitive: name ≠ NAME
# No spaces around =
# No special characters (except _)
```


Create `variables_demo.sh`:

```bash
#!/bin/bash
# Variables Demonstration Script

# 1. Basic Variable Declaration
echo "=== Basic Variables ==="
name="John Doe"
age=30
role="DevOps Engineer"

echo "Name: $name"
echo "Age: $age"
echo "Role: $role"
echo ""

# 2. Different ways to reference variables
echo "=== Variable Referencing ==="
echo "Using \$name: $name"
echo "Using \${name}: ${name}"
echo "Combined: ${name} is ${age} years old"
echo ""

# 3. Command Substitution
echo "=== Command Substitution ==="
current_date=$(date +%Y-%m-%d)
server_name=$(hostname)
user_name=$(whoami)
file_count=$(ls -1 | wc -l)

echo "Today: $current_date"
echo "Server: $server_name"
echo "User: $user_name"
echo "Files in directory: $file_count"
echo ""

# 4. Environment Variables
echo "=== Environment Variables ==="
echo "Home Directory: $HOME"
echo "Current User: $USER"
echo "Shell: $SHELL"
echo "Path: $PATH"
echo ""

# 5. Read-only Variables
echo "=== Constants (Read-only) ==="
readonly PI=3.14159
readonly APP_NAME="DevOps Automation"

echo "PI: $PI"
echo "App: $APP_NAME"

# Try to change (this will error)
# PI=3.14  # Uncomment to see error
echo ""

# 6. Arithmetic Operations
echo "=== Arithmetic ==="
num1=10
num2=5

sum=$((num1 + num2))
diff=$((num1 - num2))
product=$((num1 * num2))
quotient=$((num1 / num2))

echo "$num1 + $num2 = $sum"
echo "$num1 - $num2 = $diff"
echo "$num1 × $num2 = $product"
echo "$num1 ÷ $num2 = $quotient"
echo ""

# 7. String Operations
echo "=== String Operations ==="
firstname="Jane"
lastname="Smith"
fullname="$firstname $lastname"

echo "Full name: $fullname"
echo "Length: ${#fullname}"
echo "Uppercase: ${fullname^^}"
echo "Lowercase: ${fullname,,}"
```

**Run and Explain Output:**
```bash
chmod +x variables_demo.sh
./variables_demo.sh
```

**Key Points:**
- No spaces around `=` in assignment
- Use `$` to reference variables
- `${}` for clarity and complex operations
- `$()` for command substitution
- Arithmetic needs `$(())`

---

#### User Input

**Interactive Script Example:**

Create `user_input.sh`:

```bash
#!/bin/bash
# User Input Demonstration

echo "==============================="
echo "  DevOps Profile Generator"
echo "==============================="
echo ""

# Basic input
echo "What's your name?"
read name

echo "What's your role?"
read role

echo "Years of experience?"
read experience

# Silent input (for passwords)
echo "Enter your GitHub username:"
read github

echo "Enter password (hidden):"
read -s password
echo ""  # New line after hidden input

# Input with prompt on same line
read -p "Favorite programming language: " language

# Input with default value
read -p "Preferred OS [Linux]: " os
os=${os:-Linux}  # Use Linux if empty

# Multiple values
echo "Enter your skills (space-separated):"
read skill1 skill2 skill3

# Display profile
echo ""
echo "================================"
echo "       YOUR PROFILE"
echo "================================"
echo "Name: $name"
echo "Role: $role"
echo "Experience: $experience years"
echo "GitHub: @$github"
echo "Password length: ${#password} characters"
echo "Favorite Language: $language"
echo "Preferred OS: $os"
echo "Top 3 Skills: $skill1, $skill2, $skill3"
echo "================================"
```

**Run Interactively:**
```bash
chmod +x user_input.sh
./user_input.sh
```
---

### Control Structures

#### Conditionals (If-Else)

**Syntax Overview:**
```bash
if [ condition ]; then
    # code
elif [ condition ]; then
    # code
else
    # code
fi
```

**Common Test Operators:**

| Operator | Meaning | Example |
|----------|---------|---------|
| `-eq` | Equal | `[ $a -eq $b ]` |
| `-ne` | Not equal | `[ $a -ne $b ]` |
| `-gt` | Greater than | `[ $a -gt $b ]` |
| `-lt` | Less than | `[ $a -lt $b ]` |
| `-ge` | Greater or equal | `[ $a -ge $b ]` |
| `-le` | Less or equal | `[ $a -le $b ]` |
| `=` | String equal | `[ "$s1" = "$s2" ]` |
| `!=` | String not equal | `[ "$s1" != "$s2" ]` |
| `-z` | String empty | `[ -z "$s" ]` |
| `-n` | String not empty | `[ -n "$s" ]` |
| `-f` | File exists | `[ -f "file.txt" ]` |
| `-d` | Directory exists | `[ -d "dir" ]` |

**Practical Example:**

Create `conditional_demo.sh`:

```bash
#!/bin/bash
# Conditional Statements Demo

echo "=== Server Health Check Script ==="
echo ""

# 1. Number comparison
echo "Enter server load (0-100):"
read load

if [ $load -lt 50 ]; then
    echo "Server load: NORMAL ($load%)"
elif [ $load -lt 80 ]; then
    echo "Server load: MODERATE ($load%)"
else
    echo "Server load: HIGH ($load%) - Action needed!"
fi
echo ""

# 2. String comparison
echo "Enter environment (dev/staging/prod):"
read env

if [ "$env" = "prod" ]; then
    echo "PRODUCTION - Extra caution required!"
elif [ "$env" = "staging" ]; then
    echo "STAGING - Testing environment"
elif [ "$env" = "dev" ]; then
    echo "DEVELOPMENT - Safe to experiment"
else
    echo "Unknown environment!"
fi
echo ""

# 3. File checking
config_file="config.txt"

if [ -f "$config_file" ]; then
    echo "✓ Config file found: $config_file"
else
    echo "✗ Config file missing: $config_file"
    echo "Creating default config..."
    touch "$config_file"
    echo "✓ Config file created"
fi
echo ""

# 4. Multiple conditions (AND, OR)
read -p "Enter username: " username
read -p "Enter age: " age

if [ -n "$username" ] && [ $age -ge 18 ]; then
    echo "Access granted to $username"
elif [ -z "$username" ]; then
    echo "Username cannot be empty"
elif [ $age -lt 18 ]; then
    echo "Must be 18 or older"
fi
echo ""

# 5. Advanced: Check disk space
disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ $disk_usage -gt 90 ]; then
    echo "CRITICAL: Disk usage at ${disk_usage}%"
elif [ $disk_usage -gt 70 ]; then
    echo "WARNING: Disk usage at ${disk_usage}%"
else
    echo "Disk usage normal: ${disk_usage}%"
fi
```

**Important Notes to Emphasize:**
- Always quote string variables: `"$var"`
- Spaces inside `[ ]` are required
- `=` for strings, `-eq` for numbers
- Use `&&` for AND, `||` for OR

---

#### Loops 

**Three Types of Loops:**

Create `loops_demo.sh`:

```bash
#!/bin/bash
# Loops Demonstration

echo "======================================="
echo "       SHELL SCRIPTING LOOPS"
echo "======================================="
echo ""

# ===== 1. FOR LOOP =====
echo "=== 1. FOR LOOP - Simple Range ==="
for i in 1 2 3 4 5
do
    echo "Iteration: $i"
done
echo ""

# FOR loop - Range with seq
echo "=== 2. FOR LOOP - Using seq ==="
for i in $(seq 1 5)
do
    echo "Number: $i"
done
echo ""

# FOR loop - C-style
echo "=== 3. FOR LOOP - C-style ==="
for ((i=1; i<=5; i++))
do
    echo "Count: $i"
done
echo ""

# FOR loop - Array iteration
echo "=== 4. FOR LOOP - Array ==="
servers=("web01" "web02" "db01" "cache01")
for server in "${servers[@]}"
do
    echo "Processing server: $server"
done
echo ""

# FOR loop - File iteration
echo "=== 5. FOR LOOP - Files ==="
echo "Files in current directory:"
for file in *.sh
do
    echo "  - $file"
done
echo ""

# ===== 2. WHILE LOOP =====
echo "=== 6. WHILE LOOP - Counter ==="
counter=1
while [ $counter -le 5 ]
do
    echo "While iteration: $counter"
    ((counter++))
done
echo ""

# WHILE loop - Reading file
echo "=== 7. WHILE LOOP - Reading file ==="
echo "Creating sample log..."
cat > sample.log << EOF
2025-01-15 ERROR: Connection failed
2025-01-15 INFO: Service started
2025-01-15 WARN: High memory usage
2025-01-15 ERROR: Timeout occurred
EOF

echo "Processing log file:"
while IFS= read -r line
do
    if [[ $line == *"ERROR"* ]]; then
        echo "$line"
    elif [[ $line == *"WARN"* ]]; then
        echo "$line"
    else
        echo "$line"
    fi
done < sample.log
echo ""

# ===== 3. UNTIL LOOP =====
echo "=== UNTIL LOOP - Countdown ==="
countdown=5
until [ $countdown -eq 0 ]
do
    echo "Countdown: $countdown"
    ((countdown--))
done
echo "Liftoff!"
echo ""

# ===== PRACTICAL DEVOPS EXAMPLE =====
echo "=== PRACTICAL - Service Health Check ==="
services=("nginx" "ssh" "cron")

for service in "${services[@]}"
do
    # Simulate check (replace with actual systemctl)
    if command -v $service &> /dev/null; then
        echo "$service is available"
    else
        echo "$service is not available"
    fi
done
echo ""

# ===== LOOP CONTROL =====
echo "=== LOOP CONTROL - break & continue ==="
for i in {1..10}
do
    if [ $i -eq 3 ]; then
        echo "  Skipping 3"
        continue
    fi
    if [ $i -eq 7 ]; then
        echo "  Breaking at 7"
        break
    fi
    echo "  Processing: $i"
done
echo ""

echo "======================================="
echo "          LOOPS DEMO COMPLETE"
echo "======================================="
```

**Run and Explain:**
```bash
chmod +x loops_demo.sh
./loops_demo.sh
```

**Key Points:**
- `for` - when you know iteration count
- `while` - when condition-based
- `until` - opposite of while
- `break` - exit loop
- `continue` - skip to next iteration

---

### Practical Exercise

#### Hands-On Challenge

**Announce:** *"Time for your first real DevOps automation script!"*

**Challenge: Create a Server Monitoring Script**

Requirements:
```bash
#!/bin/bash
# server_monitor.sh
# Create a script that:
# 1. Takes server name as input
# 2. Checks if server is "up" or "down" (simulate with random)
# 3. If down, retry 3 times
# 4. Log all attempts with timestamp
# 5. Show final status
```

**Starter Template:**
```bash
#!/bin/bash
# Server Monitoring Script
# Author: [Your Name]

echo "=== Server Monitor ==="

# Get input
read -p "Enter server name: " server

# Your code here
# Hint: Use for loop for retries
# Hint: Use if-else for status check
# Hint: Use $(date) for timestamp

echo "Monitoring $server..."
# Complete the script
```

**Solution:**

```bash
#!/bin/bash
# Server Monitoring Script - Solution

echo "======================================="
echo "     SERVER MONITORING SYSTEM"
echo "======================================="
echo ""

read -p "Enter server name: " server
read -p "Max retry attempts [3]: " max_retries
max_retries=${max_retries:-3}

echo ""
echo "Monitoring: $server"
echo "Started at: $(date)"
echo "-----------------------------------"

attempt=1
while [ $attempt -le $max_retries ]
do
    echo "Attempt $attempt of $max_retries..."
    
    # Simulate server check (random 0 or 1)
    status=$((RANDOM % 2))
    
    if [ $status -eq 1 ]; then
        echo "✓ [$(date +%H:%M:%S)] $server is UP"
        echo ""
        echo "SUCCESS: Server is responding"
        exit 0
    else
        echo "✗ [$(date +%H:%M:%S)] $server is DOWN"
        
        if [ $attempt -lt $max_retries ]; then
            echo "  Retrying in 2 seconds..."
            sleep 2
        fi
    fi
    
    ((attempt++))
done

echo ""
echo "FAILED: Server did not respond after $max_retries attempts"
echo "Finished at: $(date)"
exit 1
```

---

### Wrap-up & Q&A

#### Summary & Key Takeaways

**Recap Slide:**
```
What We Learned Today:
  1. Shell scripting fundamentals & importance
  2. Bash syntax and structure
  3. Variables and user input
  4. Conditional statements (if/else)
  5. Loops (for/while/until)
  6. First automation script!

Skills Gained:
  - Writing executable shell scripts
  - Handling user input
  - Making decisions in code
  - Automating repetitive tasks
```

---

#### Homework Assignment

**Assignment:**
```bash
Create a "DevOps Daily Report" script that:
1. Shows system information (hostname, OS, uptime)
2. Displays disk usage
3. Shows memory usage
4. Lists running services (top 5 by CPU)
5. Creates a log file with timestamp
6. Emails or saves the report

Bonus: Add color coding for warnings
```

**Resources to Share:**
```
Learning Resources:
- Bash Manual: https://www.gnu.org/software/bash/manual/
- Shell Check (linter): https://www.shellcheck.net/
- Practice: https://www.hackerrank.com/domains/shell
- Cheat Sheet: https://devhints.io/bash


```

## Message

```
"Congratulations! You've written your first shell scripts!

Remember: Every DevOps engineer starts here.
The scripts you write today will evolve into 
powerful automation that saves hours of work.

Keep practicing, keep automating, and most importantly:
Never stop learning!

See you in Class 02!"
```

---

**Good luck with your class! You've got this!**