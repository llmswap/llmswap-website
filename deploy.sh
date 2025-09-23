#!/bin/bash

# llmswap Documentation Website Deployment Script

set -e  # Exit on any error

echo "🚀 Deploying llmswap documentation website..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    echo "Initialize with: git init && git remote add origin <your-repo-url>"
    exit 1
fi

# Check if bundle is available
if ! command -v bundle &> /dev/null; then
    echo "❌ Error: Bundle not found. Install with: gem install bundler"
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
bundle install

# Build site locally to check for errors
echo "🔨 Building site..."
bundle exec jekyll build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
else
    echo "❌ Build failed. Please fix errors before deploying."
    exit 1
fi

# Check if there are uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "📝 Adding uncommitted changes..."
    git add .
    
    # Prompt for commit message
    echo "Enter commit message (or press Enter for default):"
    read -r commit_message
    
    if [ -z "$commit_message" ]; then
        commit_message="Update documentation - $(date +%Y-%m-%d)"
    fi
    
    git commit -m "$commit_message"
fi

# Push to GitHub
echo "⬆️  Pushing to GitHub..."
git push origin main

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "📍 Your site will be available at:"
echo "   • GitHub Pages: https://$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^/]*\)\/\([^.]*\).*/\1.github.io\/\2/')/"
echo "   • Custom domain: Set up CNAME file and DNS settings"
echo ""
echo "⏱️  GitHub Pages typically takes 1-10 minutes to deploy"
echo "🔄 Check deployment status: Repository Settings → Pages"
echo ""
echo "📚 Next steps:"
echo "   1. Set up custom domain (llmswap.org)"
echo "   2. Configure Google Analytics" 
echo "   3. Add more tutorials and examples"
echo "   4. Test on mobile devices"
echo ""
echo "Happy documenting! 🚀"