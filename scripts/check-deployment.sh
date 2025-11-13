#!/bin/bash

# Check Render deployment status
# Usage: ./scripts/check-deployment.sh

SERVICE_ID="srv-d4ap9b3e5dus73f2v600"
API_KEY="rnd_EY47zDNQvEjIxQS12Nl31T32gPmF"

echo "🔍 Checking deployment status..."
echo ""

# Get latest deployment
LATEST_DEPLOY=$(curl -s -X GET \
    "https://api.render.com/v1/services/$SERVICE_ID/deploys?limit=1" \
    -H "Authorization: Bearer $API_KEY" | python3 -m json.tool 2>/dev/null)

DEPLOY_ID=$(echo "$LATEST_DEPLOY" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4)
STATUS=$(echo "$LATEST_DEPLOY" | grep -o '"status":"[^"]*' | head -1 | cut -d'"' -f4)
COMMIT_MSG=$(echo "$LATEST_DEPLOY" | grep -A2 '"commit"' | grep '"message"' | cut -d'"' -f4)

echo "📊 Deployment Status:"
echo "   ID: $DEPLOY_ID"
echo "   Status: $STATUS"
echo "   Commit: $COMMIT_MSG"
echo ""
echo "🔗 View deployment: https://dashboard.render.com/web/$SERVICE_ID/deploys/$DEPLOY_ID"
echo "🌐 App URL: https://demand-letter-szag.onrender.com"
echo ""

if [ "$STATUS" = "live" ]; then
    echo "✅ Deployment is live!"
elif [ "$STATUS" = "build_in_progress" ] || [ "$STATUS" = "update_in_progress" ]; then
    echo "⏳ Deployment in progress..."
    echo "   View logs: https://dashboard.render.com/web/$SERVICE_ID/logs"
else
    echo "⚠️  Deployment status: $STATUS"
    echo "   Check logs for details: https://dashboard.render.com/web/$SERVICE_ID/logs"
fi

