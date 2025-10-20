#!/bin/bash

# Script to create preview deployment
# Usage: ./create-preview.sh <app>

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

echo "🔍 Creating PREVIEW deployment..."
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
echo "Branch: $BRANCH"
echo "App: $APP"

vercel pull --yes --environment=preview --token "$VERCEL_TOKEN" --cwd "apps/$APP"
vercel build --token "$VERCEL_TOKEN" --cwd "apps/$APP"
vercel deploy --prebuilt --archive=tgz --token "$VERCEL_TOKEN" --cwd "apps/$APP" --meta "branch=$BRANCH" --meta "app=$APP" --meta "environment=preview"

echo "✅ Preview deployment completed"
