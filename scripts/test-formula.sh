#!/bin/bash

# Script to test Homebrew formula locally
# This verifies the formula syntax and tests installation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Testing Homebrew formula...${NC}"

# Check if we're in the tap repository
if [ ! -f "Formula/traverse.rb" ]; then
    echo -e "${RED}Error: Must run from homebrew-tap repository root${NC}"
    exit 1
fi

# Check formula syntax
echo -e "${YELLOW}Checking formula syntax...${NC}"
if brew style --formula Formula/traverse.rb; then
    echo -e "${GREEN}Formula syntax is valid${NC}"
else
    echo -e "${YELLOW}Formula has style warnings (non-critical)${NC}"
fi

# Test formula installation
echo -e "${YELLOW}Testing formula installation...${NC}"
echo "This will:"
echo "  1. Uninstall traverse if already installed"
echo "  2. Install traverse from this tap"
echo "  3. Run basic tests"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Uninstall if exists
    brew uninstall traverse 2>/dev/null || true
    
    # Reinstall from tap
    echo -e "${GREEN}Installing traverse...${NC}"
    if brew install calltrace/tap/traverse; then
        echo -e "${GREEN}Installation successful!${NC}"
        
        # Test binaries
        echo -e "${GREEN}Testing installed binaries...${NC}"
        for binary in sol2cg sol2test sol2bnd sol-storage-analyzer storage-trace; do
            if command -v "$binary" > /dev/null; then
                echo -e "${GREEN}✓ $binary installed${NC}"
                $binary --version || true
            else
                echo -e "${RED}✗ $binary not found${NC}"
                exit 1
            fi
        done
        
        # Run formula test
        echo -e "${YELLOW}Running formula test block...${NC}"
        brew test traverse
        
        echo -e "${GREEN}All tests passed!${NC}"
    else
        echo -e "${RED}Installation failed${NC}"
        exit 1
    fi
else
    echo "Test cancelled"
fi