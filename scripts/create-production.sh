#!/bin/bash

# Script to create production deployment
# Usage: ./create-production.sh <app>

set -e

APP="$1"

if [ -z "$APP" ]; then
    echo "Usage: $0 <app>"
    echo "Example: $0 builder"
    exit 1
fi

if [ -z "$VERCEL_TOKEN" ]; then
    echo "Error: VERCEL_TOKEN environment variable is required"
    exit 1
fi

echo "📦 Creating PRODUCTION deployment..."
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
echo "Branch: $BRANCH"
echo "App: $APP"

vercel pull --yes --environment=production --token "$VERCEL_TOKEN" --cwd "apps/$APP"
vercel build --prod --token "$VERCEL_TOKEN" --cwd "apps/$APP"
vercel deploy --prebuilt --archive=tgz --prod --token "$VERCEL_TOKEN" --cwd "apps/$APP" --meta "branch=develop" --meta "app=$APP" --meta "environment=production"

echo "✅ Production deployment completed"
