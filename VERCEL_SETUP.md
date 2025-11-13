# Vercel Frontend Setup Guide

This guide explains how to connect your Vercel frontend to the Render backend.

## Overview

- **Backend (Render)**: Full Next.js app with API routes at `https://demand-letter-szag.onrender.com`
- **Frontend (Vercel)**: Next.js frontend that calls the Render backend API

## Quick Setup

Run the setup script to see required environment variables:
```bash
./scripts/setup-vercel-env.sh
```

## Step 1: Deploy to Vercel

1. Go to https://vercel.com and sign in
2. Click "Add New" → "Project"
3. Import your GitHub repository: `alexander-t-ho/Demand-Letter`
4. Configure the project:
   - **Framework Preset**: Next.js (auto-detected)
   - **Root Directory**: `./` (or leave empty)
   - **Build Command**: `npm ci --include=dev && npx prisma generate && npx next build`
   - **Output Directory**: `.next` (default)
   - **Install Command**: `npm install`

## Step 2: Set Environment Variables in Vercel

In your Vercel project settings, go to **Settings** → **Environment Variables** and add:

### Required Variable:

```bash
NEXT_PUBLIC_API_URL=https://demand-letter-szag.onrender.com
```

This tells the Vercel frontend where to find the Render backend API.

## Step 3: Update Render Backend CORS Settings

After deploying to Vercel, update the Render backend to allow your Vercel domain:

1. Go to Render dashboard: https://dashboard.render.com/web/srv-d4ap9b3e5dus73f2v600
2. Go to **Environment** tab
3. Add/Update: `NEXT_PUBLIC_FRONTEND_URL` = `https://your-vercel-app.vercel.app`
4. This allows CORS to work properly

## Step 4: Deploy

1. Push your code to GitHub (already done)
2. Vercel will automatically deploy
3. Your frontend will be available at `https://your-project.vercel.app`

## How It Works

- **CORS Middleware**: Automatically added to all `/api/*` routes on Render backend
- **API Client**: Frontend uses `NEXT_PUBLIC_API_URL` to call Render backend
- **Authentication**: Cookies work across domains with proper CORS configuration

## Testing

1. Visit your Vercel deployment URL
2. Try logging in - it should call the Render backend
3. Check browser console for any CORS errors
4. Verify API calls are going to Render backend in Network tab

## Troubleshooting

### CORS Errors

The middleware should handle CORS automatically. If you still see errors:
1. Verify `NEXT_PUBLIC_FRONTEND_URL` is set in Render with your Vercel URL
2. Check that the middleware is deployed (it's in `middleware.ts`)
3. Ensure `credentials: 'include'` is in fetch calls (already added)

### Authentication Issues

- Cookies work across domains with `Access-Control-Allow-Credentials: true` (already configured)
- Ensure `credentials: 'include'` is in all fetch calls
- Check that JWT_SECRET matches between environments if using server-side auth

## Architecture

```
Vercel Frontend (https://your-app.vercel.app)
    ↓ (API calls via NEXT_PUBLIC_API_URL)
Render Backend (https://demand-letter-szag.onrender.com)
    ↓ (Database queries)
Render PostgreSQL Database
```
