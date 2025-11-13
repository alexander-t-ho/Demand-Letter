#!/bin/bash

# Setup script for Render backend deployment
# This script helps set up the database connection and run migrations

set -e

echo "🚀 Setting up Render backend..."

# Check if DATABASE_URL is set
if [ -z "$DATABASE_URL" ]; then
    echo "❌ DATABASE_URL environment variable is not set"
    echo ""
    echo "To get your Render database connection string:"
    echo "1. Go to your Render dashboard: https://dashboard.render.com"
    echo "2. Click on your PostgreSQL database"
    echo "3. Go to 'Connections' or 'Info' tab"
    echo "4. Copy the 'Internal Database URL' or 'External Database URL'"
    echo ""
    echo "The connection string format should be:"
    echo "postgresql://username:password@dpg-d4alibhr0fns73ecreu0-a.oregon-postgres.render.com:5432/database_name"
    echo ""
    read -p "Enter your DATABASE_URL: " db_url
    export DATABASE_URL="$db_url"
fi

echo "✅ DATABASE_URL is set"

# Generate Prisma Client
echo "📦 Generating Prisma Client..."
npx prisma generate

# Push schema to database (for development) or run migrations (for production)
echo "🗄️  Setting up database schema..."
read -p "Do you want to run migrations (recommended for production)? [y/N]: " run_migrations

if [[ $run_migrations =~ ^[Yy]$ ]]; then
    echo "Running migrations..."
    npx prisma migrate deploy
else
    echo "Pushing schema (development mode)..."
    npx prisma db push
fi

# Test database connection
echo "🔍 Testing database connection..."
npx tsx scripts/test-db.ts

echo "✅ Backend setup complete!"
echo ""
echo "Next steps:"
echo "1. Make sure all environment variables are set in Render dashboard"
echo "2. Deploy your application to Render"
echo "3. Your backend should be ready!"

