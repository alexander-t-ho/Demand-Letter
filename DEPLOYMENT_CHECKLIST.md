# Production Deployment Checklist

## Pre-Deployment

- [x] Code is committed and pushed to GitHub main branch
- [x] All tests pass (if applicable)
- [x] Environment variables documented
- [x] Database migrations are ready

## Step 1: Create Render Account & Connect GitHub

1. Go to https://render.com and sign up/login
2. Connect your GitHub account
3. Authorize Render to access your repositories

## Step 2: Create PostgreSQL Database

1. In Render dashboard, click **"New +"** → **"PostgreSQL"**
2. Configure:
   - **Name**: `demand-letter-db`
   - **Database**: `demand_letter_generator`
   - **User**: `demand_letter_user`
   - **Region**: Choose closest to you (e.g., `Oregon (US West)`)
   - **Plan**: Free (or paid for production)
3. Click **"Create Database"**
4. Wait for database to be ready (~2-3 minutes)
5. **IMPORTANT**: Copy the **Internal Database URL** (you'll need this for the web service)

## Step 3: Create Web Service

1. In Render dashboard, click **"New +"** → **"Web Service"**
2. Connect your GitHub repository: `alexander-t-ho/Demand-Letter`
3. Configure:
   - **Name**: `demand-letter-generator`
   - **Environment**: `Node`
   - **Region**: Same as database
   - **Branch**: `main`
   - **Root Directory**: (leave empty - code is in root)
   - **Build Command**: `npm install && npx prisma generate && npx prisma migrate deploy && npm run build`
   - **Start Command**: `npm start`
   - **Plan**: Free (or paid for production)
4. Click **"Create Web Service"**

## Step 4: Set Environment Variables

In your web service dashboard, go to **"Environment"** tab and add:

### Required Variables:

```bash
# Database (use Internal Database URL from PostgreSQL dashboard)
DATABASE_URL=postgresql://user:password@dpg-xxxxx-a.oregon-postgres.render.com:5432/database_name

# Authentication
JWT_SECRET=<generate-a-secure-random-string>
NEXTAUTH_URL=https://demand-letter-generator.onrender.com

# AWS S3 (for file uploads)
AWS_ACCESS_KEY_ID=<your-aws-access-key>
AWS_SECRET_ACCESS_KEY=<your-aws-secret-key>
AWS_REGION=us-east-1
AWS_S3_BUCKET=alexho-demand-letters

# OpenRouter AI
OPENROUTER_API_KEY=<your-openrouter-api-key>
OPENROUTER_DEFAULT_MODEL=anthropic/claude-3.5-sonnet

# Node Environment
NODE_ENV=production
```

### How to Get Values:

1. **DATABASE_URL**: 
   - Go to your PostgreSQL dashboard
   - Under "Connections" → Copy **Internal Database URL**
   
2. **JWT_SECRET**: 
   - Generate a secure random string: `openssl rand -base64 32`
   - Or use: https://generate-secret.vercel.app/32

3. **AWS Credentials**: 
   - Get from AWS IAM console
   - Ensure S3 bucket exists: `alexho-demand-letters`

4. **OPENROUTER_API_KEY**: 
   - Get from https://openrouter.ai/keys
   - Format: `sk-or-v1-...`

5. **NEXTAUTH_URL**: 
   - Update after deployment with your actual Render URL
   - Format: `https://your-app-name.onrender.com`

## Step 5: Deploy

1. After setting environment variables, Render will automatically start building
2. Monitor the build logs in the "Logs" tab
3. Wait for deployment to complete (~5-10 minutes)

## Step 6: Verify Deployment

1. Check build logs for any errors
2. Visit your app URL: `https://demand-letter-generator.onrender.com`
3. Test login functionality
4. Verify database connection works

## Step 7: Seed Templates (Optional)

If you need to seed default templates:

1. Go to your web service dashboard
2. Click **"Shell"** tab
3. Run:
```bash
npm run seed:templates
```

## Post-Deployment

- [ ] App is accessible at Render URL
- [ ] Database migrations ran successfully
- [ ] Environment variables are set correctly
- [ ] Login functionality works
- [ ] File uploads work (if using S3)
- [ ] AI generation works (if using OpenRouter)

## Troubleshooting

### Build Fails

- Check build logs for specific errors
- Verify all dependencies are in `package.json`
- Ensure Node.js version is 18+ (Render auto-detects)

### Database Connection Issues

- Verify `DATABASE_URL` uses **Internal Database URL** (not External)
- Ensure database and web service are in same region
- Check database is running (not paused)

### Migration Errors

- Run migrations manually via Shell:
  ```bash
  npx prisma migrate deploy
  ```

### Environment Variable Issues

- Double-check all variables are set (no typos)
- Ensure no extra spaces or quotes
- Verify secrets are correct

## Production Considerations

### Free Tier Limitations:
- Web service spins down after 15 min inactivity (~30s wake time)
- Database free for 90 days, then requires paid plan
- 100GB bandwidth/month

### For Production:
- [ ] Upgrade to paid plan (no spin-down)
- [ ] Set up custom domain
- [ ] Enable database backups
- [ ] Set up monitoring/alerts
- [ ] Configure CDN (if needed)

## Quick Deploy Script

You can also use the `render.yaml` file for Blueprint deployment:

1. In Render dashboard, click **"New +"** → **"Blueprint"**
2. Connect your GitHub repository
3. Render will auto-detect `render.yaml` and create services
4. You'll still need to add environment variables manually

## Support

- Render Docs: https://render.com/docs
- Render Status: https://status.render.com
- Project Issues: GitHub repository issues

