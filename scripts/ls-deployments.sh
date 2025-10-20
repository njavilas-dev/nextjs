#!/bin/bash

# Script to list deployments with metadata
# Usage: ./ls-deployments.sh <app>

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

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
echo "Current branch: $BRANCH"
echo "App: $APP"
echo ""

vercel list --meta branch="$BRANCH" --meta app="$APP" --token "$VERCEL_TOKEN" --cwd "apps/$APP"
