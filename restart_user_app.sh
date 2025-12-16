#!/bin/bash

echo "🔄 Перезапуск User App..."

# Kill existing process on port 3003
echo "Останавливаем процесс на порту 3003..."
lsof -ti:3003 | xargs kill -9 2>/dev/null || echo "Порт 3003 свободен"

# Navigate to user-app directory
cd "$(dirname "$0")/frontend/user-app" || exit

# Install dependencies if needed
echo "Проверка зависимостей..."
npm install jsqr 2>/dev/null || echo "jsqr уже установлен"

# Start dev server
echo "Запуск dev сервера на порту 3003..."
PORT=3003 npm start

echo "✅ User App запущен на http://localhost:3003"
