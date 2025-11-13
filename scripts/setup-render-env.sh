#!/bin/bash

# Script to set environment variables on Render using their API
# Usage: ./scripts/setup-render-env.sh

set -e

RENDER_API_KEY="${RENDER_API_KEY:-}"
SERVICE_NAME="demand-letter-generator"

if [ -z "$RENDER_API_KEY" ]; then
  echo "❌ Error: RENDER_API_KEY environment variable not set"
  echo "Usage: export RENDER_API_KEY='your-key' && ./scripts/setup-render-env.sh"
  exit 1
fi

echo "🔧 Setting up Render environment variables for: $SERVICE_NAME"
echo ""

# Get service ID
echo "📡 Fetching service information..."
SERVICE_RESPONSE=$(curl -s -X GET \
  "https://api.render.com/v1/services?name=$SERVICE_NAME" \
  -H "Authorization: Bearer $RENDER_API_KEY")

SERVICE_ID=$(echo "$SERVICE_RESPONSE" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4)

if [ -z "$SERVICE_ID" ]; then
  echo "❌ Error: Could not find service '$SERVICE_NAME'"
  echo "Please create the service first via Render dashboard or Blueprint"
  exit 1
fi

echo "✅ Found service ID: $SERVICE_ID"
echo ""

# Prompt for missing credentials
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  read -p "Enter AWS_ACCESS_KEY_ID: " AWS_ACCESS_KEY_ID
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  read -sp "Enter AWS_SECRET_ACCESS_KEY: " AWS_SECRET_ACCESS_KEY
  echo ""
fi

if [ -z "$AWS_REGION" ]; then
  AWS_REGION="us-east-1"
  echo "Using default AWS_REGION: $AWS_REGION"
fi

if [ -z "$AWS_S3_BUCKET" ]; then
  AWS_S3_BUCKET="alexho-demand-letters"
  echo "Using default AWS_S3_BUCKET: $AWS_S3_BUCKET"
fi

# Set environment variables
echo ""
echo "🔐 Setting environment variables..."

ENV_VARS=(
  "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
  "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
  "AWS_REGION=$AWS_REGION"
  "AWS_S3_BUCKET=$AWS_S3_BUCKET"
)

for env_var in "${ENV_VARS[@]}"; do
  KEY=$(echo "$env_var" | cut -d'=' -f1)
  VALUE=$(echo "$env_var" | cut -d'=' -f2-)
  
  echo "Setting $KEY..."
  
  RESPONSE=$(curl -s -X POST \
    "https://api.render.com/v1/services/$SERVICE_ID/env-vars" \
    -H "Authorization: Bearer $RENDER_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{
      \"key\": \"$KEY\",
      \"value\": \"$VALUE\"
    }")
  
  if echo "$RESPONSE" | grep -q "error"; then
    echo "⚠️  Warning: Failed to set $KEY"
    echo "$RESPONSE" | grep -o '"message":"[^"]*' | cut -d'"' -f4 || echo "$RESPONSE"
  else
    echo "✅ Set $KEY"
  fi
done

echo ""
echo "✅ Environment variables configured!"
echo ""
echo "📝 Note: You may still need to set OPENROUTER_API_KEY and OPENROUTER_DEFAULT_MODEL"
echo "   if you want AI generation features."
echo ""
echo "🔗 View your service: https://dashboard.render.com/web/$SERVICE_ID"

