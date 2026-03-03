#!/bin/bash
# BIAS Backend Startup Script
# Run this from the bias/ root folder: bash start_backend.sh

set -e
cd "$(dirname "$0")/backend"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  BIAS Backend — Starting up"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
  echo "→ Creating virtual environment..."
  python3 -m venv venv
fi

# Activate
source venv/bin/activate

# Install dependencies
echo "→ Installing dependencies..."
pip install -q -r requirements.txt

echo ""
echo "✓ Backend running at http://localhost:8000"
echo "✓ API docs at    http://localhost:8000/api/docs"
echo ""

# Start server
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
