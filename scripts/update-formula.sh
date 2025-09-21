#!/bin/bash

# Script to update Homebrew formula with SHA256 hashes from a GitHub release
# Usage: ./scripts/update-formula.sh <version>

set -e

VERSION="$1"

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 0.1.2"
    exit 1
fi

FORMULA_PATH="Formula/traverse.rb"
RELEASE_URL="https://github.com/calltrace/traverse/releases/download/v${VERSION}"

echo "Updating Homebrew formula for version ${VERSION}..."

# Function to calculate SHA256 for a URL
get_sha256() {
    local url="$1"
    local temp_file=$(mktemp)
    
    echo "Downloading $url..."
    if curl -L -s -o "$temp_file" "$url"; then
        local sha=$(shasum -a 256 "$temp_file" | cut -d' ' -f1)
        rm "$temp_file"
        echo "$sha"
    else
        rm "$temp_file"
        echo "Failed to download $url" >&2
        return 1
    fi
}

# Get SHA256 for each platform
echo "Calculating SHA256 hashes..."
SHA_MACOS_ARM64=$(get_sha256 "${RELEASE_URL}/traverse-macos-arm64.tar.gz")
SHA_MACOS_AMD64=$(get_sha256 "${RELEASE_URL}/traverse-macos-amd64.tar.gz")
SHA_LINUX_AMD64=$(get_sha256 "${RELEASE_URL}/traverse-linux-amd64.tar.gz")

echo "SHA256 for macOS ARM64: $SHA_MACOS_ARM64"
echo "SHA256 for macOS AMD64: $SHA_MACOS_AMD64"
echo "SHA256 for Linux AMD64: $SHA_LINUX_AMD64"

# Update the formula file
echo "Updating formula file..."

# Update version
sed -i '' "s/version \".*\"/version \"${VERSION}\"/" "$FORMULA_PATH"

# Update SHA256 hashes - handle both placeholder and existing hashes
if grep -q "PLACEHOLDER_SHA256" "$FORMULA_PATH"; then
    # First time setup with placeholders
    sed -i '' "s/sha256 \"PLACEHOLDER_SHA256_MACOS_ARM64\"/sha256 \"${SHA_MACOS_ARM64}\"/" "$FORMULA_PATH"
    sed -i '' "s/sha256 \"PLACEHOLDER_SHA256_MACOS_AMD64\"/sha256 \"${SHA_MACOS_AMD64}\"/" "$FORMULA_PATH"
    sed -i '' "s/sha256 \"PLACEHOLDER_SHA256_LINUX_AMD64\"/sha256 \"${SHA_LINUX_AMD64}\"/" "$FORMULA_PATH"
else
    # Update existing SHA256 hashes (match 64 hex characters)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS sed
        sed -i '' -E "s/sha256 \"[a-f0-9]{64}\"/sha256 \"${SHA_MACOS_ARM64}\"/" "$FORMULA_PATH" | head -1
        sed -i '' -E "s/sha256 \"[a-f0-9]{64}\"/sha256 \"${SHA_MACOS_AMD64}\"/" "$FORMULA_PATH" | head -2 | tail -1
        sed -i '' -E "s/sha256 \"[a-f0-9]{64}\"/sha256 \"${SHA_LINUX_AMD64}\"/" "$FORMULA_PATH" | tail -1
    else
        # GNU sed
        sed -i -E "0,/sha256 \"[a-f0-9]{64}\"/s//sha256 \"${SHA_MACOS_ARM64}\"/" "$FORMULA_PATH"
        sed -i -E "0,/sha256 \"[a-f0-9]{64}\"/s//sha256 \"${SHA_MACOS_AMD64}\"/" "$FORMULA_PATH"
        sed -i -E "0,/sha256 \"[a-f0-9]{64}\"/s//sha256 \"${SHA_LINUX_AMD64}\"/" "$FORMULA_PATH"
    fi
fi

echo "Formula updated successfully!"
echo ""
echo "To test the formula:"
echo "  brew upgrade traverse"
echo "  # or"
echo "  brew reinstall traverse"
echo ""
echo "To commit and push:"
echo "  git add Formula/traverse.rb"
echo "  git commit -m \"Update formula for v${VERSION}\""
echo "  git push"