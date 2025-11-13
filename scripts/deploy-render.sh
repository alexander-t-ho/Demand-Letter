#!/bin/bash

# Deploy to Render using CLI or API
# This script handles workspace setup and deployment

set -e

echo "🚀 Render Deployment Script"
echo "============================"
echo ""

# Check if Render CLI is installed
if ! command -v render &> /dev/null; then
    echo "❌ Render CLI not found. Installing..."
    brew install render
fi

# Check if logged in
if ! render whoami &>/dev/null; then
    echo "🔐 Not logged in. Please login..."
    render login
fi

# Try to get or set workspace
echo "📋 Checking workspace..."
WORKSPACE_SET=$(render workspace current 2>&1 || echo "not set")

if echo "$WORKSPACE_SET" | grep -q "no workspace set"; then
    echo "⚠️  No workspace set. Please set it manually:"
    echo "   Run: render workspace set"
    echo ""
    echo "Or provide your Render API key to use API deployment:"
    read -p "Enter Render API Key (or press Enter to skip): " RENDER_API_KEY
    
    if [ -z "$RENDER_API_KEY" ]; then
        echo "❌ Cannot proceed without workspace or API key"
        echo "Please run: render workspace set"
        exit 1
    fi
else
    echo "✅ Workspace is set"
    WORKSPACE_ID=$(echo "$WORKSPACE_SET" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4 || echo "")
fi

# Check if services exist
echo ""
echo "🔍 Checking existing services..."

if [ -n "$RENDER_API_KEY" ]; then
    # Use API
    echo "Using Render API..."
    SERVICES=$(curl -s -X GET \
        "https://api.render.com/v1/services" \
        -H "Authorization: Bearer $RENDER_API_KEY")
    
    SERVICE_ID=$(echo "$SERVICES" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4 || echo "")
    SERVICE_NAME=$(echo "$SERVICES" | grep -o '"name":"[^"]*demand-letter-generator[^"]*' | head -1 | cut -d'"' -f4 || echo "")
else
    # Use CLI
    echo "Using Render CLI..."
    SERVICES=$(render services list -o json 2>&1 || echo "[]")
    SERVICE_ID=$(echo "$SERVICES" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4 || echo "")
fi

if [ -z "$SERVICE_ID" ]; then
    echo "⚠️  No existing service found. Deploying via Blueprint..."
    echo ""
    echo "To deploy via Blueprint:"
    echo "1. Go to https://dashboard.render.com"
    echo "2. Click 'New +' → 'Blueprint'"
    echo "3. Connect your GitHub repository"
    echo "4. Render will auto-detect render.yaml and create services"
    echo ""
    echo "Or create services manually and run this script again."
    exit 0
else
    echo "✅ Found service: $SERVICE_NAME (ID: $SERVICE_ID)"
fi

# Trigger deployment
echo ""
echo "🚀 Triggering deployment..."

if [ -n "$RENDER_API_KEY" ]; then
    # Use API
    DEPLOY_RESPONSE=$(curl -s -X POST \
        "https://api.render.com/v1/services/$SERVICE_ID/deploys" \
        -H "Authorization: Bearer $RENDER_API_KEY" \
        -H "Content-Type: application/json")
    
    DEPLOY_ID=$(echo "$DEPLOY_RESPONSE" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4 || echo "")
    
    if [ -n "$DEPLOY_ID" ]; then
        echo "✅ Deployment triggered! Deploy ID: $DEPLOY_ID"
        echo "🔗 View deployment: https://dashboard.render.com/web/$SERVICE_ID/deploys/$DEPLOY_ID"
    else
        echo "❌ Failed to trigger deployment"
        echo "$DEPLOY_RESPONSE"
        exit 1
    fi
else
    # Use CLI
    DEPLOY_ID=$(render deploys create "$SERVICE_ID" -o json 2>&1 | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4 || echo "")
    
    if [ -n "$DEPLOY_ID" ]; then
        echo "✅ Deployment triggered! Deploy ID: $DEPLOY_ID"
    else
        echo "❌ Failed to trigger deployment"
        exit 1
    fi
fi

echo ""
echo "📊 Monitoring deployment..."
echo "View logs at: https://dashboard.render.com/web/$SERVICE_ID/logs"
echo ""
echo "✅ Deployment initiated successfully!"
echo "   Service: https://dashboard.render.com/web/$SERVICE_ID"
echo "   App URL: https://demand-letter-generator.onrender.com"

