#!/bin/bash

# Check if SCOPE is defined
if [ -z "$SCOPE" ]; then
    echo "Error: SCOPE is not defined"
    exit 1
fi

# Check if server.js exists
if [ ! -f "/app/server.js" ]; then
    echo "Error: Not found server.js"
    exit 1
fi

echo "Starting application: $SCOPE"
exec node "server.js" 