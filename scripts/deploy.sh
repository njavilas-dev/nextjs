#!/bin/bash

# Main deployment script
# Usage: ./deploy.sh <app> [environment]
# Examples:
#   ./deploy.sh builder preview
#   ./deploy.sh viewer production
#   ./deploy.sh builder  (defaults to preview)

set -e

APP="$1"
ENVIRONMENT="${2:-preview}"

if [ -z "$APP" ]; then
    echo "Usage: $0 <app> [environment]"
    echo ""
    echo "Apps:"
    echo "  builder  - Builder application"
    echo "  viewer   - Viewer application"
    echo ""
    echo "Environments:"
    echo "  preview     - Preview deployment (default)"
    echo "  production  - Production deployment"
    echo ""
    echo "Examples:"
    echo "  $0 builder preview"
    echo "  $0 viewer production"
    echo "  $0 builder"
    exit 1
fi

if [ -z "$VERCEL_TOKEN" ]; then
    echo "Error: VERCEL_TOKEN environment variable is required"
    exit 1
fi

case "$APP" in
    builder)
        ./scripts/deploy-builder.sh "$ENVIRONMENT"
        ;;
    viewer)
        ./scripts/deploy-viewer.sh "$ENVIRONMENT"
        ;;
    *)
        echo "Error: Unknown app '$APP'. Use 'builder' or 'viewer'"
        exit 1
        ;;
esac
