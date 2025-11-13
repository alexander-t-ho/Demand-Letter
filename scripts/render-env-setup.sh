#!/bin/bash

# Script to help set up environment variables for Render
# This outputs the environment variables you need to add to Render dashboard

echo "🔧 Render Environment Variables Setup"
echo "======================================"
echo ""
echo "Copy these environment variables to your Render Web Service dashboard:"
echo ""
echo "---"
echo ""

# Database URL (Internal - for Render services)
echo "# Database (use Internal Database URL from Render PostgreSQL dashboard)"
echo "DATABASE_URL=postgresql://user:password@host:5432/database_name"
echo ""

# Read from .env if it exists
if [ -f .env ]; then
    echo "# Authentication"
    grep "^JWT_SECRET=" .env || echo "JWT_SECRET=your-secret-key-change-in-production"
    echo ""
    
    echo "# AWS S3 (replace with your actual credentials)"
    echo "AWS_ACCESS_KEY_ID=your-aws-access-key-id"
    echo "AWS_SECRET_ACCESS_KEY=your-aws-secret-access-key"
    grep "^AWS_REGION=" .env || echo "AWS_REGION=us-east-1"
    grep "^AWS_S3_BUCKET=" .env || echo "AWS_S3_BUCKET=alexho-demand-letters"
    echo ""
    
    echo "# OpenRouter AI"
    grep "^OPENROUTER_API_KEY=" .env || echo "OPENROUTER_API_KEY=your-openrouter-api-key"
    grep "^OPENROUTER_DEFAULT_MODEL=" .env || echo "OPENROUTER_DEFAULT_MODEL=anthropic/claude-3.5-sonnet"
    echo ""
else
    echo "# Authentication"
    echo "JWT_SECRET=your-secret-key-change-in-production"
    echo ""
    echo "# AWS S3"
    echo "AWS_ACCESS_KEY_ID=your-aws-access-key"
    echo "AWS_SECRET_ACCESS_KEY=your-aws-secret-key"
    echo "AWS_REGION=us-east-1"
    echo "AWS_S3_BUCKET=alexho-demand-letters"
    echo ""
    echo "# OpenRouter AI"
    echo "OPENROUTER_API_KEY=your-openrouter-api-key"
    echo "OPENROUTER_DEFAULT_MODEL=anthropic/claude-3.5-sonnet"
    echo ""
fi

echo "# Node Environment"
echo "NODE_ENV=production"
echo ""
echo "# Next.js URL (update with your Render app URL after deployment)"
echo "NEXTAUTH_URL=https://your-app-name.onrender.com"
echo ""
echo "---"
echo ""
echo "⚠️  IMPORTANT:"
echo "1. For DATABASE_URL in Render, use the 'Internal Database URL' from your PostgreSQL dashboard"
echo "2. Update NEXTAUTH_URL with your actual Render app URL after deployment"
echo "3. Make sure all secrets are set correctly"

