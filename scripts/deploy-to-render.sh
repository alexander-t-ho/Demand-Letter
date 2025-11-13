#!/bin/bash

# Deploy to Render Production
# This script deploys the application to Render using the CLI or API

set -e

echo "🚀 Deploying to Render Production"
echo "=================================="
echo ""

# Method 1: Try using Render CLI with workspace
echo "Method 1: Using Render CLI..."
echo ""

# Check if workspace is set
if render workspace current &>/dev/null; then
    echo "✅ Workspace is set"
    WORKSPACE_INFO=$(render workspace current -o json 2>&1 || echo "")
    
    # List services
    echo "📋 Listing services..."
    SERVICES=$(render services list -o json 2>&1 || echo "[]")
    
    # Find demand-letter-generator service
    SERVICE_ID=$(echo "$SERVICES" | grep -B5 -A5 "demand-letter-generator" | grep '"id"' | head -1 | cut -d'"' -f4 || echo "")
    
    if [ -n "$SERVICE_ID" ]; then
        echo "✅ Found service: demand-letter-generator"
        echo "🚀 Triggering deployment..."
        
        DEPLOY_OUTPUT=$(render deploys create "$SERVICE_ID" -o json 2>&1 || echo "")
        DEPLOY_ID=$(echo "$DEPLOY_OUTPUT" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4 || echo "")
        
        if [ -n "$DEPLOY_ID" ]; then
            echo "✅ Deployment triggered successfully!"
            echo "   Deploy ID: $DEPLOY_ID"
            echo "   View at: https://dashboard.render.com"
            exit 0
        fi
    else
        echo "⚠️  Service not found. You may need to create it first via Blueprint."
    fi
else
    echo "⚠️  Workspace not set. Trying alternative methods..."
fi

echo ""
echo "Method 2: Using Render API..."
echo ""

# Check for API key
if [ -z "$RENDER_API_KEY" ]; then
    echo "📝 To use the API method, you need a Render API key:"
    echo "   1. Go to https://dashboard.render.com/account/api-keys"
    echo "   2. Create a new API key"
    echo "   3. Run: export RENDER_API_KEY='your-key'"
    echo "   4. Then run this script again"
    echo ""
    echo "Or set workspace manually:"
    echo "   render workspace set"
    echo ""
    exit 1
fi

echo "✅ Using Render API key..."

# Get services via API
SERVICES_RESPONSE=$(curl -s -X GET \
    "https://api.render.com/v1/services" \
    -H "Authorization: Bearer $RENDER_API_KEY")

# Find service
SERVICE_ID=$(echo "$SERVICES_RESPONSE" | grep -B10 "demand-letter-generator" | grep '"id"' | head -1 | cut -d'"' -f4 || echo "")

if [ -z "$SERVICE_ID" ]; then
    echo "⚠️  Service 'demand-letter-generator' not found via API"
    echo ""
    echo "💡 Deploy via Blueprint (Recommended):"
    echo "   1. Go to https://dashboard.render.com"
    echo "   2. Click 'New +' → 'Blueprint'"
    echo "   3. Connect your GitHub repository"
    echo "   4. Render will auto-detect render.yaml and create services"
    echo ""
    echo "   The render.yaml file has been fixed and is ready to use!"
    exit 0
fi

echo "✅ Found service ID: $SERVICE_ID"
echo "🚀 Triggering deployment..."

# Trigger deployment
DEPLOY_RESPONSE=$(curl -s -X POST \
    "https://api.render.com/v1/services/$SERVICE_ID/deploys" \
    -H "Authorization: Bearer $RENDER_API_KEY" \
    -H "Content-Type: application/json")

DEPLOY_ID=$(echo "$DEPLOY_RESPONSE" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4 || echo "")

if [ -n "$DEPLOY_ID" ]; then
    echo "✅ Deployment triggered successfully!"
    echo "   Deploy ID: $DEPLOY_ID"
    echo "   Service: https://dashboard.render.com/web/$SERVICE_ID"
    echo "   App URL: https://demand-letter-generator.onrender.com"
else
    echo "❌ Failed to trigger deployment"
    echo "Response: $DEPLOY_RESPONSE"
    exit 1
fi

