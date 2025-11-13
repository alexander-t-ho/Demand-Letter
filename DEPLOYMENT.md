# Deployment Guide for Render

## Prerequisites

1. Render account: https://render.com
2. GitHub repository connected
3. Environment variables ready

## Step 1: Create PostgreSQL Database on Render

1. Go to https://dashboard.render.com
2. Click "New +" → "PostgreSQL"
3. Configure:
   - Name: `demand-letter-db`
   - Database: `demand_letter_generator`
   - User: `demand_letter_user`
   - Region: Choose closest to you
   - Plan: Free
4. Click "Create Database"
5. Wait for database to be ready
6. Copy the **Internal Database URL** (for use in your web service)

## Step 2: Create Web Service on Render

1. Go to https://dashboard.render.com
2. Click "New +" → "Web Service"
3. Connect your GitHub repository
4. Configure:
   - Name: `demand-letter-generator`
   - Environment: `Node`
   - Region: Same as database
   - Branch: `main`
   - Root Directory: (leave empty or `Demand Letter Generator 2` if in subdirectory)
   - Build Command: `npm install && npx prisma generate && npm run build`
   - Start Command: `npm start`
   - Plan: Free

## Step 3: Set Environment Variables

In your Render web service dashboard, go to "Environment" and add:

### Required Variables:

```bash
# Database (use Internal Database URL from your PostgreSQL service)
DATABASE_URL=postgresql://user:password@dpg-d4alibhr0fns73ecreu0-a.oregon-postgres.render.com:5432/database_name

# Authentication
JWT_SECRET=your-secret-key-change-in-production
NEXTAUTH_URL=https://your-app-name.onrender.com

# AWS S3
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
AWS_REGION=us-east-1
AWS_S3_BUCKET=alexho-demand-letters

# OpenRouter AI
OPENROUTER_API_KEY=your-openrouter-api-key
OPENROUTER_DEFAULT_MODEL=anthropic/claude-3.5-sonnet

# Node Environment
NODE_ENV=production
```

### Getting DATABASE_URL from Render:

1. Go to your PostgreSQL database dashboard
2. Under "Connections" section, you'll see:
   - **Internal Database URL** (use this for web service on Render)
   - **External Database URL** (for local development)
3. Copy the Internal Database URL

## Step 4: Run Database Migrations

After your web service is deployed, you need to run migrations:

### Option 1: Using Render Shell

1. Go to your web service dashboard
2. Click "Shell" tab
3. Run:
```bash
npx prisma migrate deploy
```

### Option 2: Using Local CLI

1. Set DATABASE_URL to your Render database (External URL)
2. Run:
```bash
export DATABASE_URL="your-external-database-url"
npx prisma migrate deploy
```

### Option 3: Add to Build Command

Modify your build command in Render to:
```bash
npm install && npx prisma generate && npx prisma migrate deploy && npm run build
```

## Step 5: Seed Templates (Optional)

If you need to seed templates:

1. Use Render Shell or local CLI
2. Run:
```bash
npm run seed:templates
```

## Troubleshooting

### Database Connection Issues

- Make sure you're using the **Internal Database URL** for the web service
- Check that the database is in the same region as your web service
- Verify DATABASE_URL is set correctly in environment variables

### Build Failures

- Check build logs in Render dashboard
- Ensure all dependencies are in package.json
- Verify Node.js version (should be 18+)

### Migration Issues

- Run `npx prisma migrate deploy` manually via Shell
- Check database connection first with `npx prisma db pull`

## Render Free Tier Limits

- **Web Service**: Spins down after 15 minutes of inactivity (takes ~30s to wake up)
- **Database**: 90 days free, then requires paid plan
- **Bandwidth**: 100GB/month

## Production Considerations

For production, consider:
1. Upgrade to paid plan to avoid spin-down
2. Use connection pooling (Render provides this automatically)
3. Set up monitoring and alerts
4. Configure custom domain
5. Enable automatic backups for database
