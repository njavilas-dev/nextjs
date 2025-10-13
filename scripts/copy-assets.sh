#!/bin/bash

SCOPE=$1

echo "Copying assets for scope: $SCOPE"

# Create directories
mkdir -p ./apps/$SCOPE/.next/static
mkdir -p ./apps/$SCOPE/public

# Copy static files if they exist
if [ -d "./apps/$SCOPE/.next/static" ] && [ "$(ls -A ./apps/$SCOPE/.next/static)" ]; then
    echo "Copying static files..."
    cp -r ./apps/$SCOPE/.next/static/* ./apps/$SCOPE/.next/static/
else
    echo "No static files found, creating empty directory"
fi

# Copy public files if they exist
if [ -d "./apps/$SCOPE/public" ] && [ "$(ls -A ./apps/$SCOPE/public)" ]; then
    echo "Copying public files..."
    cp -r ./apps/$SCOPE/public/* ./apps/$SCOPE/public/
else
    echo "No public files found, creating empty directory"
fi

echo "Assets copy completed"
