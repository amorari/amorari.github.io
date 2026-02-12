#!/bin/bash
# ==============================================
# Deploy alessandromorari.com to GitHub Pages
# Run this script once from the project root
# ==============================================

set -e

REPO_NAME="alessandromorari.github.io"
echo ""
echo "🚀 Deploying alessandromorari.com to GitHub Pages"
echo "================================================="
echo ""

# Step 1: Check gh CLI auth
echo "Step 1: Checking GitHub CLI authentication..."
if ! gh auth status &>/dev/null; then
  echo "  → Not authenticated. Running 'gh auth login'..."
  gh auth login
fi
echo "  ✓ Authenticated"
echo ""

# Step 2: Create the GitHub repo (user site)
echo "Step 2: Creating GitHub repository '$REPO_NAME'..."
if gh repo view "$REPO_NAME" &>/dev/null; then
  echo "  → Repository already exists, skipping creation"
else
  gh repo create "$REPO_NAME" --public --description "Professional website of Dr. Alessandro Morari — AI Systems Leader at NVIDIA"
  echo "  ✓ Repository created"
fi
echo ""

# Step 3: Initialize git and push
echo "Step 3: Initializing git and pushing..."
git init
git branch -M main
git add -A
git commit -m "Initial commit: Hugo site for alessandromorari.com

Professional website with custom theme, SEO, responsive design,
and GitHub Actions deployment workflow."

GITHUB_USER=$(gh api user --jq '.login')
git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git" 2>/dev/null || git remote set-url origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
git push -u origin main
echo "  ✓ Code pushed to GitHub"
echo ""

# Step 4: Enable GitHub Pages via Actions
echo "Step 4: Enabling GitHub Pages..."
gh api repos/$GITHUB_USER/$REPO_NAME/pages \
  --method POST \
  --field "build_type=workflow" 2>/dev/null || \
gh api repos/$GITHUB_USER/$REPO_NAME/pages \
  --method PUT \
  --field "build_type=workflow" 2>/dev/null || \
echo "  → Note: You may need to enable Pages manually in Settings → Pages → Source → GitHub Actions"
echo ""

echo "================================================="
echo "✓ Done! Your site will be live at:"
echo "  https://$GITHUB_USER.github.io"
echo ""
echo "To use your custom domain (alessandromorari.com):"
echo "  1. Add a CNAME record pointing to $GITHUB_USER.github.io"
echo "  2. In repo Settings → Pages → Custom domain, enter: alessandromorari.com"
echo "================================================="
