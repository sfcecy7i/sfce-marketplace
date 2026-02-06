#!/bin/bash
#
# Check dependencies for sfce-macos-notifier plugin
#

set -e

echo "Checking dependencies for sfce-macos-notifier..."

# Check terminal-notifier
if command -v terminal-notifier &> /dev/null; then
    echo "✓ terminal-notifier is installed"
else
    echo "✗ terminal-notifier is NOT installed"
    echo "  Install with: brew install terminal-notifier"
fi

# Check Python 3
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✓ python3 is installed ($PYTHON_VERSION)"
else
    echo "✗ python3 is NOT installed"
fi

# Check required Python packages
if command -v python3 &> /dev/null; then
    REQUIRED_PACKAGES=("yaml" "smtplib")
    MISSING_PACKAGES=()

    for package in "${REQUIRED_PACKAGES[@]}"; do
        if python3 -c "import $package" 2>/dev/null; then
            echo "✓ Python package '$package' is available"
        else
            echo "✗ Python package '$package' is NOT available"
            MISSING_PACKAGES+=("$package")
        fi
    done

    if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
        echo ""
        echo "Missing Python packages: ${MISSING_PACKAGES[*]}"
        echo "Install with: pip3 install pyyaml"
    fi
fi

echo ""
echo "Dependency check complete."
