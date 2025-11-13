# Vercel Frontend Setup Guide

This guide explains how to connect your Vercel frontend to the Render backend.

## Overview

- **Backend (Render)**: Full Next.js app with API routes at `https://demand-letter-szag.onrender.com`
- **Frontend (Vercel)**: Next.js frontend that calls the Render backend API

## Step 1: Deploy to Vercel

1. Go to https://vercel.com and sign in
2. Click "Add New" → "Project"
3. Import your GitHub repository: `alexander-t-ho/Demand-Letter`
4. Configure the project:
   - **Framework Preset**: Next.js
   - **Root Directory**: `./` (or leave empty)
   - **Build Command**: `npm ci --include=dev && npx prisma generate && npx next build`
   - **Output Directory**: `.next` (default)
   - **Install Command**: `npm install`

## Step 2: Set Environment Variables in Vercel

In your Vercel project settings, go to **Settings** → **Environment Variables** and add:

### Required Variables:

```bash
# Backend API URL (Render backend)
NEXT_PUBLIC_API_URL=https://demand-letter-szag.onrender.com

# Note: These are only needed if you want to use server-side features
# For a pure frontend deployment, you only need NEXT_PUBLIC_API_URL
```

### Optional (if using server-side features):

```bash
# Database (if needed for server-side rendering)
DATABASE_URL=postgresql://... (External Database URL from Render)

# Authentication
JWT_SECRET=your-jwt-secret

# AWS S3
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
AWS_REGION=us-east-1
AWS_S3_BUCKET=alexho-demand-letters

# OpenRouter AI
OPENROUTER_API_KEY=your-openrouter-api-key
OPENROUTER_DEFAULT_MODEL=anthropic/claude-3.5-sonnet
```

## Step 3: Update Code to Use API Client

The codebase has been updated to use `apiFetch` utility which automatically handles:
- Same-origin requests (when frontend and backend are together)
- Cross-origin requests (when frontend is on Vercel and backend is on Render)

## Step 4: Configure CORS on Render Backend

The Render backend needs to allow requests from your Vercel domain. Update your Next.js API routes or add CORS middleware.

## Step 5: Deploy

1. Push your code to GitHub
2. Vercel will automatically deploy
3. Your frontend will be available at `https://your-project.vercel.app`

## Testing

1. Visit your Vercel deployment URL
2. Try logging in - it should call the Render backend
3. Check browser console for any CORS errors
4. If you see CORS errors, you'll need to add CORS headers to your Render backend API routes

## Troubleshooting

### CORS Errors

If you see CORS errors, add CORS headers to your API routes. You can create a middleware or update each route to include:

```typescript
headers: {
  'Access-Control-Allow-Origin': process.env.NEXT_PUBLIC_FRONTEND_URL || '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  'Access-Control-Allow-Credentials': 'true',
}
```

### Authentication Issues

Since cookies are used for authentication, ensure:
- `credentials: 'include'` is set in fetch calls (already done in `apiFetch`)
- CORS allows credentials
- Cookie domain is set correctly

