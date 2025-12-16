#!/bin/bash

echo "🚀 Creating YuvGo Flutter App"
echo "=============================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed!"
    echo ""
    echo "Please install Flutter first:"
    echo "https://docs.flutter.dev/get-started/install"
    echo ""
    echo "Or use Homebrew:"
    echo "brew install --cask flutter"
    exit 1
fi

# Create Flutter project
echo "📦 Creating Flutter project..."
flutter create --org com.yuvgo --project-name yuvgo_app flutter_app

cd flutter_app

# Update pubspec.yaml
echo "📝 Updating dependencies..."
cat > pubspec.yaml << 'EOF'
name: yuvgo_app
description: YuvGo - Car Wash Subscription App
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # UI
  cupertino_icons: ^1.0.6
  google_fonts: ^6.1.0
  
  # State Management
  provider: ^6.1.1
  
  # HTTP & API
  http: ^1.1.0
  dio: ^5.4.0
  
  # Storage
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  
  # QR Code
  qr_code_scanner: ^1.0.1
  qr_flutter: ^4.1.0
  
  # Maps
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  
  # Utils
  intl: ^0.18.1
  url_launcher: ^6.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
EOF

# Install dependencies
echo "📥 Installing dependencies..."
flutter pub get

echo ""
echo "✅ Flutter app created successfully!"
echo ""
echo "📁 Location: flutter_app/"
echo ""
echo "🚀 To run the app:"
echo "   cd flutter_app"
echo "   flutter run"
echo ""
echo "📱 Available platforms:"
echo "   - iOS: flutter run -d ios"
echo "   - Android: flutter run -d android"
echo "   - Web: flutter run -d chrome"
echo ""
