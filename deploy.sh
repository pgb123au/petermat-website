#!/bin/bash
# PeterMat Website Deployment Script
# Run: ./deploy.sh

set -e

echo "🏉 PeterMat Deployment"
echo "====================="
echo ""

# Check if gh is authenticated
if ! gh auth status &>/dev/null; then
    echo "📱 GitHub authentication required..."
    gh auth login
fi

# Create repo if it doesn't exist
if ! gh repo view petermat-website &>/dev/null; then
    echo "📦 Creating GitHub repository..."
    gh repo create petermat-website --public --source=. --push
else
    echo "📦 Repository exists, pushing updates..."
    git push origin main 2>/dev/null || git push -u origin main
fi

# Enable GitHub Pages
echo "🌐 Enabling GitHub Pages..."
gh api -X PUT repos/:owner/petermat-website/pages \
    -f source='{"branch":"main","path":"/"}' 2>/dev/null || \
gh api -X POST repos/:owner/petermat-website/pages \
    -f source='{"branch":"main","path":"/"}'

# Get the pages URL
PAGES_URL=$(gh api repos/:owner/petermat-website/pages --jq '.html_url' 2>/dev/null)

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🌍 Your site is live at:"
echo "   $PAGES_URL"
echo ""
echo "Note: It may take 1-2 minutes for the site to be available."
