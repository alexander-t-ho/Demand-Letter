#!/bin/bash

# Script to set up Prisma schema on Render
# Run this via Render Shell after deployment
# Usage: In Render Shell, run: ./scripts/setup-render-schema.sh

set -e

echo "🚀 Setting up Prisma schema on Render..."
echo ""

# Check if DATABASE_URL is set
if [ -z "$DATABASE_URL" ]; then
    echo "❌ DATABASE_URL environment variable is not set"
    echo "This should be automatically set in Render"
    exit 1
fi

echo "✅ DATABASE_URL is set"
echo ""

# Generate Prisma Client
echo "📦 Generating Prisma Client..."
npx prisma generate

echo ""
echo "🗄️  Pushing database schema..."
npx prisma db push --accept-data-loss

echo ""
echo "✅ Database schema setup complete!"
echo ""
echo "Your application should now work correctly."

