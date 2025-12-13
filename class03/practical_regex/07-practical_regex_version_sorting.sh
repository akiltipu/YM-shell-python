#!/bin/bash

# Practical Example 7: Version Number Sorting and Comparison
# Sort and compare semantic version numbers

echo "=== Version Number Handling with Regex ==="
echo ""

# Sample version data
cat > /tmp/versions.txt << 'EOF'
v1.2.3
v2.0.0
v1.10.5
v1.2.15
v1.9.0
v2.1.0-beta
v1.2.3-alpha
v3.0.0
EOF

echo "Unsorted versions:"
cat /tmp/versions.txt
echo ""

# Extract version numbers
echo "1. Extract version numbers:"
echo "───────────────────────────"
grep -oE '[0-9]+\.[0-9]+\.[0-9]+' /tmp/versions.txt
echo ""

# Sort versions (simple)
echo "2. Sort versions (semantic):"
echo "────────────────────────────"
sort -V /tmp/versions.txt
echo ""

# Compare two versions
echo "3. Version comparison function:"
echo "────────────────────────────────"

compare_versions() {
    local ver1=$1
    local ver2=$2
    
    # Extract numeric parts
    ver1_clean=$(echo "$ver1" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    ver2_clean=$(echo "$ver2" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    
    # Split into components
    IFS='.' read -ra v1_parts <<< "$ver1_clean"
    IFS='.' read -ra v2_parts <<< "$ver2_clean"
    
    # Compare major version
    if [ "${v1_parts[0]}" -gt "${v2_parts[0]}" ]; then
        echo "$ver1 > $ver2"
        return 1
    elif [ "${v1_parts[0]}" -lt "${v2_parts[0]}" ]; then
        echo "$ver1 < $ver2"
        return 2
    fi
    
    # Compare minor version
    if [ "${v1_parts[1]}" -gt "${v2_parts[1]}" ]; then
        echo "$ver1 > $ver2"
        return 1
    elif [ "${v1_parts[1]}" -lt "${v2_parts[1]}" ]; then
        echo "$ver1 < $ver2"
        return 2
    fi
    
    # Compare patch version
    if [ "${v1_parts[2]}" -gt "${v2_parts[2]}" ]; then
        echo "$ver1 > $ver2"
        return 1
    elif [ "${v1_parts[2]}" -lt "${v2_parts[2]}" ]; then
        echo "$ver1 < $ver2"
        return 2
    fi
    
    echo "$ver1 = $ver2"
    return 0
}

compare_versions "v1.2.3" "v1.2.15"
compare_versions "v2.0.0" "v1.10.5"
compare_versions "v1.5.0" "v1.5.0"
echo ""

# Find latest version
echo "4. Find latest version:"
echo "───────────────────────"
latest=$(sort -V /tmp/versions.txt | tail -n1)
echo "Latest version: $latest"
echo ""

# Filter versions by pattern
echo "5. Filter versions by major release:"
echo "─────────────────────────────────────"
echo "All v1.x.x versions:"
grep -E '^v1\.' /tmp/versions.txt
echo ""
echo "All v2.x.x versions:"
grep -E '^v2\.' /tmp/versions.txt
echo ""

# Extract pre-release tags
echo "6. Extract pre-release versions:"
echo "─────────────────────────────────"
grep -E '-(alpha|beta|rc)' /tmp/versions.txt
echo ""

# Validate version format
echo "7. Validate version format (semver):"
echo "─────────────────────────────────────"

validate_semver() {
    local version=$1
    
    if [[ $version =~ ^v?[0-9]+\.[0-9]+\.[0-9]+(-[a-z]+)?$ ]]; then
        echo "✓ $version (valid semver)"
        return 0
    else
        echo "✗ $version (invalid semver)"
        return 1
    fi
}

test_versions=(
    "v1.2.3"
    "v2.0.0-beta"
    "1.2"
    "v1.2.3.4"
    "v1.x.3"
)

for ver in "${test_versions[@]}"; do
    validate_semver "$ver"
done
echo ""

# Bump version
echo "8. Bump version numbers:"
echo "────────────────────────"

bump_version() {
    local version=$1
    local part=$2  # major, minor, or patch
    
    # Extract numbers
    if [[ $version =~ ^v?([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
        local major="${BASH_REMATCH[1]}"
        local minor="${BASH_REMATCH[2]}"
        local patch="${BASH_REMATCH[3]}"
        
        case $part in
            major)
                echo "v$((major + 1)).0.0"
                ;;
            minor)
                echo "v${major}.$((minor + 1)).0"
                ;;
            patch)
                echo "v${major}.${minor}.$((patch + 1))"
                ;;
        esac
    fi
}

current="v1.2.3"
echo "Current: $current"
echo "Bump major: $(bump_version "$current" major)"
echo "Bump minor: $(bump_version "$current" minor)"
echo "Bump patch: $(bump_version "$current" patch)"
echo ""

echo "💡 Version regex patterns:"
echo "   - Basic: [0-9]+\.[0-9]+\.[0-9]+"
echo "   - With prefix: ^v?[0-9]+\.[0-9]+\.[0-9]+"
echo "   - With pre-release: [0-9]+\.[0-9]+\.[0-9]+(-[a-z]+)?"
echo "   - Sort: sort -V (version-aware sorting)"

rm -f /tmp/versions.txt
