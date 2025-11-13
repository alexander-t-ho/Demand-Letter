#!/bin/bash

# Complete setup and deployment script for Render
# This script helps set workspace and deploy

set -e

echo "🚀 Render Setup and Deployment"
echo "==============================="
echo ""

# Check if Render CLI is installed
if ! command -v render &> /dev/null; then
    echo "❌ Render CLI not found. Installing..."
    brew install render
fi

# Check if logged in
if ! render whoami &>/dev/null 2>&1; then
    echo "🔐 Not logged in. Logging in..."
    render login
fi

echo "✅ Logged in to Render"
echo ""

# Try to get workspace info
echo "📋 Setting up workspace..."
echo ""

# List available workspaces (this might require interactive mode)
echo "Available workspaces:"
echo ""

# Try to set workspace - user will need to select
echo "Please select your workspace:"
echo "Run this command to see available workspaces and set one:"
echo "  render workspace set"
echo ""

# Check if workspace is already set
if render workspace current &>/dev/null 2>&1; then
    echo "✅ Workspace is already set!"
    WORKSPACE=$(render workspace current -o json 2>&1 | grep -o '"name":"[^"]*' | cut -d'"' -f4 || echo "")
    echo "   Current workspace: $WORKSPACE"
    echo ""
    
    # Now deploy
    echo "🚀 Deploying..."
    ./scripts/deploy-to-render.sh
else
    echo "⚠️  Workspace not set. Please set it first:"
    echo ""
    echo "Option 1: Set workspace interactively"
    echo "  render workspace set"
    echo ""
    echo "Option 2: Use Render API (requires API key)"
    echo "  1. Get API key from: https://dashboard.render.com/account/api-keys"
    echo "  2. Run: export RENDER_API_KEY='your-key'"
    echo "  3. Run: ./scripts/deploy-to-render.sh"
    echo ""
    echo "Option 3: Deploy via Blueprint (Recommended for first-time setup)"
    echo "  1. Go to https://dashboard.render.com"
    echo "  2. Click 'New +' → 'Blueprint'"
    echo "  3. Connect your GitHub repository"
    echo "  4. Render will auto-detect render.yaml and create services"
    echo ""
    echo "The render.yaml file has been fixed and is ready to use!"
fi

