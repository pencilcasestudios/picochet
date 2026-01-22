#!/usr/bin/env zsh

# export-and-prepare.sh
# Automates PICO-8 build preparation, versioning, and Git staging.

set -e

P8_FILE="picochet.p8"
HTML_EXPORT="picochet.html"
JS_EXPORT="picochet.js"
BUILD_DIR="build"
VERSION_FILE="$BUILD_DIR/version.txt"

echo "🚀 Starting Picochet build preparation..."

# 1. Check for PICO-8 export files
if [[ ! -f "$HTML_EXPORT" || ! -f "$JS_EXPORT" ]]; then
    echo "❌ Missing export files ($HTML_EXPORT or $JS_EXPORT)."
    echo "Please run 'export picochet.html' in PICO-8 first."
    exit 1
fi

# 2. Extract current version from .p8 file
# Assumes format: game_version = "0.0.7"
CURRENT_VERSION=$(grep -o 'game_version = "[^"]*"' "$P8_FILE" | cut -d'"' -f2)

if [[ -z "$CURRENT_VERSION" ]]; then
    echo "❌ Could not find game_version in $P8_FILE"
    exit 1
fi

echo "Current version: $CURRENT_VERSION"

# 3. Increment patch version (semver-like)
# Split version string into array
IFS='.' read -r major minor patch <<< "$CURRENT_VERSION"
NEW_PATCH=$((patch + 1))
NEW_VERSION="$major.$minor.$NEW_PATCH"

echo "Target version: $NEW_VERSION"

# 4. Update .p8 file with new version
# Use sed to replace the version line in place
# We use a temp file for safety across different sed versions
sed "s/game_version = \"$CURRENT_VERSION\"/game_version = \"$NEW_VERSION\"/" "$P8_FILE" > "${P8_FILE}.tmp" && mv "${P8_FILE}.tmp" "$P8_FILE"

# 5. Prepare build directory
mkdir -p "$BUILD_DIR"
cp "$HTML_EXPORT" "$BUILD_DIR/index.html"
cp "$JS_EXPORT" "$BUILD_DIR/"
echo "$NEW_VERSION" > "$VERSION_FILE"

echo "✅ Build files prepared in $BUILD_DIR/"
echo "   - index.html (from $HTML_EXPORT)"
# Using basename for clarity
echo "   - $(basename $JS_EXPORT)"
echo "   - version.txt ($NEW_VERSION)"

# 6. Git Operations
echo "\n--- Git Stage ---"
git add "$P8_FILE"
git add -f "$BUILD_DIR/"

echo "\nSummary of changes to be committed:"
git status -s

echo "\nDo you want to commit and tag as v$NEW_VERSION and push? (y/n)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    git commit -m "Build: Release v$NEW_VERSION"
    git tag -a "v$NEW_VERSION" -m "Release v$NEW_VERSION"

    echo "🚀 Pushing to origin..."
    git push origin main
    git push origin "v$NEW_VERSION"

    echo "\n🎉 Successfully committed, tagged, and pushed v$NEW_VERSION!"
    echo "GitHub Actions should take over the deployment to itch.io now."
else
    echo "\n⚠️ Push cancelled. Changes are staged but not committed."
fi
