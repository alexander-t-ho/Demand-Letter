# Render Deployment Checklist

## ✅ Backend Setup Complete

- [x] Database connection established
- [x] Prisma Client generated
- [x] Database schema pushed
- [x] Database connection tested (✅ healthy, 654ms response time)
- [x] Templates seeded (12 templates created)

## 📋 Next Steps for Render Deployment

### Step 1: Create Web Service on Render

1. Go to https://dashboard.render.com
2. Click "New +" → "Web Service"
3. Connect your GitHub repository
4. Configure:
   - **Name**: `demand-letter-generator` (or your preferred name)
   - **Environment**: `Node`
   - **Region**: Same as your database (Oregon)
   - **Branch**: `main`
   - **Root Directory**: (leave empty, or `Demand Letter Generator 2` if repo is in subdirectory)
   - **Build Command**: `npm install && npx prisma generate && npm run build`
   - **Start Command**: `npm start`
   - **Plan**: Free

### Step 2: Add Environment Variables

Go to your Web Service → Environment tab and add:

```bash
# Database - IMPORTANT: Use Internal Database URL from Render PostgreSQL dashboard
DATABASE_URL=postgresql://steno_demand_letter_user:rfbWXsPp38jxhHU7mZhRNZsAqbjUZH5L@dpg-d4alibhr0fns73ecreu0-a.oregon-postgres.render.com/steno_demand_letter

# Authentication (generate a secure random secret)
JWT_SECRET=your-secure-jwt-secret-key

# AWS S3 (replace with your actual credentials)
AWS_ACCESS_KEY_ID=your-aws-access-key-id
AWS_SECRET_ACCESS_KEY=your-aws-secret-access-key
AWS_REGION=us-east-1
AWS_S3_BUCKET=alexho-demand-letters

# OpenRouter AI (replace with your actual API key)
OPENROUTER_API_KEY=your-openrouter-api-key
OPENROUTER_DEFAULT_MODEL=anthropic/claude-3.5-sonnet

# Node Environment
NODE_ENV=production

# Next.js URL (UPDATE THIS AFTER DEPLOYMENT)
NEXTAUTH_URL=https://your-app-name.onrender.com
```

**⚠️ IMPORTANT**: 
- For `DATABASE_URL`, use the **Internal Database URL** from your Render PostgreSQL dashboard (not the external one)
- Update `NEXTAUTH_URL` with your actual Render app URL after deployment

### Step 3: Deploy

1. Click "Create Web Service"
2. Wait for build to complete (~3-5 minutes)
3. Copy your app URL (e.g., `https://demand-letter-generator.onrender.com`)
4. Update `NEXTAUTH_URL` environment variable with your actual URL
5. Redeploy if needed

### Step 4: Verify Deployment

1. Visit your app URL
2. Test login/registration
3. Test document creation
4. Test PDF export
5. Check logs in Render dashboard for any errors

## 🔧 Troubleshooting

### Build Fails
- Check build logs in Render dashboard
- Verify all environment variables are set
- Ensure Node.js version is 18+

### Database Connection Issues
- Verify you're using **Internal Database URL** (not external)
- Check database is in same region as web service
- Verify DATABASE_URL is set correctly

### App Crashes
- Check logs in Render dashboard
- Verify all required environment variables are set
- Check database connection

## 📊 Current Database Status

- **Hostname**: `dpg-d4alibhr0fns73ecreu0-a.oregon-postgres.render.com`
- **Database**: `steno_demand_letter`
- **User**: `steno_demand_letter_user`
- **Status**: ✅ Connected and healthy
- **Templates**: 12 templates seeded

## 🚀 Quick Deploy Command Reference

```bash
# Test database connection locally
export DATABASE_URL="postgresql://steno_demand_letter_user:rfbWXsPp38jxhHU7mZhRNZsAqbjUZH5L@dpg-d4alibhr0fns73ecreu0-a.oregon-postgres.render.com/steno_demand_letter"
npx tsx scripts/test-db.ts

# Run migrations (if needed)
npx prisma migrate deploy

# View environment variables needed
./scripts/render-env-setup.sh
```

