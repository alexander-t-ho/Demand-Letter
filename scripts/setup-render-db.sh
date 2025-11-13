#!/bin/bash

# Quick setup script for Render database
# Usage: ./scripts/setup-render-db.sh

set -e

echo "🚀 Render Database Setup"
echo "========================"
echo ""

# Check if DATABASE_URL is provided as argument
if [ -n "$1" ]; then
    export DATABASE_URL="$1"
    echo "✅ Using provided DATABASE_URL"
elif [ -n "$DATABASE_URL" ]; then
    echo "✅ Using DATABASE_URL from environment"
else
    echo "❌ DATABASE_URL not found"
    echo ""
    echo "To get your Render database connection string:"
    echo "1. Go to: https://dashboard.render.com"
    echo "2. Click on your PostgreSQL database"
    echo "3. Go to 'Connections' or 'Info' tab"
    echo "4. Copy the 'External Database URL' (for local setup)"
    echo ""
    echo "Then run:"
    echo "  export DATABASE_URL='your-connection-string'"
    echo "  ./scripts/setup-render-db.sh"
    echo ""
    echo "Or provide it directly:"
    echo "  ./scripts/setup-render-db.sh 'your-connection-string'"
    exit 1
fi

echo ""
echo "📦 Step 1: Generating Prisma Client..."
npx prisma generate

echo ""
echo "🗄️  Step 2: Pushing database schema..."
npx prisma db push --accept-data-loss

echo ""
echo "🔍 Step 3: Testing database connection..."
if npx tsx scripts/test-db.ts; then
    echo "✅ Database connection successful!"
else
    echo "❌ Database connection failed. Please check your DATABASE_URL"
    exit 1
fi

echo ""
echo "🌱 Step 4: Seeding templates (optional)..."
read -p "Do you want to seed templates? [y/N]: " seed_templates
if [[ $seed_templates =~ ^[Yy]$ ]]; then
    npm run seed:templates
    echo "✅ Templates seeded!"
fi

echo ""
echo "✅ Backend setup complete!"
echo ""
echo "Next steps:"
echo "1. Set DATABASE_URL in your Render web service environment variables"
echo "2. Use the 'Internal Database URL' from Render dashboard for the web service"
echo "3. Deploy your application to Render"
echo "4. Run migrations in production: npx prisma migrate deploy"

