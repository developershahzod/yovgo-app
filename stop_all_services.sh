#!/bin/bash

echo "🛑 Stopping All YuvGo Services..."
echo "=================================="

# Kill all processes
lsof -ti:8000 | xargs kill -9 2>/dev/null && echo "✓ Stopped User Service (8000)" || echo "Port 8000 is free"
lsof -ti:8001 | xargs kill -9 2>/dev/null && echo "✓ Stopped Admin Service (8001)" || echo "Port 8001 is free"
lsof -ti:8002 | xargs kill -9 2>/dev/null && echo "✓ Stopped Subscription Service (8002)" || echo "Port 8002 is free"
lsof -ti:8003 | xargs kill -9 2>/dev/null && echo "✓ Stopped Partner Service (8003)" || echo "Port 8003 is free"
lsof -ti:3000 | xargs kill -9 2>/dev/null && echo "✓ Stopped Admin Dashboard (3000)" || echo "Port 3000 is free"
lsof -ti:3001 | xargs kill -9 2>/dev/null && echo "✓ Stopped Merchant Dashboard (3001)" || echo "Port 3001 is free"
lsof -ti:3003 | xargs kill -9 2>/dev/null && echo "✓ Stopped User App (3003)" || echo "Port 3003 is free"

echo ""
echo "✅ All services stopped!"
