#!/bin/bash

# Script to generate environment variables for Vercel deployment
# Usage: ./scripts/setup-vercel-env.sh

echo "🔧 Vercel Environment Variables Setup"
echo "======================================"
echo ""
echo "Add these environment variables in your Vercel project settings:"
echo "https://vercel.com/your-project/settings/environment-variables"
echo ""
echo "---"
echo ""

# Render backend URL
RENDER_BACKEND_URL="https://demand-letter-szag.onrender.com"

echo "# Backend API URL (Render backend)"
echo "NEXT_PUBLIC_API_URL=$RENDER_BACKEND_URL"
echo ""

echo "# Optional: If you need server-side features, also add:"
echo "# DATABASE_URL=postgresql://... (External Database URL from Render)"
echo "# JWT_SECRET=your-jwt-secret"
echo "# AWS_ACCESS_KEY_ID=your-aws-access-key"
echo "# AWS_SECRET_ACCESS_KEY=your-aws-secret-key"
echo "# AWS_REGION=us-east-1"
echo "# AWS_S3_BUCKET=alexho-demand-letters"
echo "# OPENROUTER_API_KEY=your-openrouter-api-key"
echo "# OPENROUTER_DEFAULT_MODEL=anthropic/claude-3.5-sonnet"
echo ""

echo "---"
echo ""
echo "⚠️  IMPORTANT:"
echo "1. Set NEXT_PUBLIC_API_URL to your Render backend URL: $RENDER_BACKEND_URL"
echo "2. After deploying to Vercel, update NEXT_PUBLIC_FRONTEND_URL in Render with your Vercel URL"
echo "3. This allows CORS to work properly between Vercel frontend and Render backend"

