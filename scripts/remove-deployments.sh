#!/bin/bash

# Script to remove existing deployments with same metadata
# Usage: ./remove-deployments.sh <app> <environment>

set -e

APP="$1"
ENVIRONMENT="$2"

if [ -z "$APP" ] || [ -z "$ENVIRONMENT" ]; then
    echo "Usage: $0 <app> <environment>"
    echo "Example: $0 builder preview"
    exit 1
fi

if [ -z "$VERCEL_TOKEN" ]; then
    echo "Error: VERCEL_TOKEN environment variable is required"
    exit 1
fi

echo "🗑️  Removing existing deployments..."
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
echo "Current branch: $BRANCH"
echo "App: $APP"
echo "Environment: $ENVIRONMENT"

vercel list --meta branch="$BRANCH" --meta app="$APP" --meta environment="$ENVIRONMENT" --token "$VERCEL_TOKEN" --cwd "apps/$APP" 2>/dev/null | grep -o "https://[^ ]*\.vercel\.app" | while read url; do
    echo "   Removing: $url"
    vercel remove "$url" --token "$VERCEL_TOKEN" --yes 2>/dev/null || true
done

echo "✅ Cleanup completed"
