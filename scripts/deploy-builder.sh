#!/bin/bash

# Script to deploy builder app (remove + create)
# Usage: ./deploy-builder.sh [preview|production]

set -e

ENVIRONMENT="${1:-preview}"

if [ -z "$VERCEL_TOKEN" ]; then
    echo "Error: VERCEL_TOKEN environment variable is required"
    exit 1
fi

echo "🚀 Deploying builder app..."
echo "Environment: $ENVIRONMENT"

# Remove existing deployments
./scripts/remove-deployments.sh builder "$ENVIRONMENT"

# Create new deployment
if [ "$ENVIRONMENT" = "production" ]; then
    ./scripts/create-production.sh builder
else
    ./scripts/create-preview.sh builder
fi

echo "✅ Builder deployment completed"
