#!/bin/bash

# Script to deploy viewer app (remove + create)
# Usage: ./deploy-viewer.sh [preview|production]

set -e

ENVIRONMENT="${1:-preview}"

if [ -z "$VERCEL_TOKEN" ]; then
    echo "Error: VERCEL_TOKEN environment variable is required"
    exit 1
fi

echo "🚀 Deploying viewer app..."
echo "Environment: $ENVIRONMENT"

# Remove existing deployments
./scripts/remove-deployments.sh viewer "$ENVIRONMENT"

# Create new deployment
if [ "$ENVIRONMENT" = "production" ]; then
    ./scripts/create-production.sh viewer
else
    ./scripts/create-preview.sh viewer
fi

echo "✅ Viewer deployment completed"
