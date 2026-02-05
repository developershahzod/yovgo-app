# YuvGO Flutter App - Pixel-Perfect Redesign

## Overview
Complete pixel-perfect redesign of the YuvGO car wash mobile app based on Figma designs. The app now features a modern, clean UI with improved UX and visual consistency.

## Design System

### Colors
- **Primary Cyan**: `#00C3FF` - Main brand color
- **Dark Navy**: `#0A1628` - Secondary color, buttons
- **Light Background**: `#F8F9FA` - Screen backgrounds
- **White**: `#FFFFFF` - Cards, surfaces
- **Text Colors**: Primary `#1A1A1A`, Secondary `#6B7280`, Tertiary `#9CA3AF`
- **Accent Colors**: Yellow `#FFD700`, Green `#10B981`, Red `#EF4444`

### Typography
- **Font Family**: Inter (via Google Fonts)
- **Display Large**: 32px, Bold
- **Display Medium**: 28px, Bold
- **Display Small**: 24px, Bold
- **Headline**: 18-20px, SemiBold
- **Body**: 14-16px, Regular
- **Caption**: 12px, Regular

### Spacing & Layout
- **Card Border Radius**: 12-20px
- **Button Border Radius**: 12px
- **Padding**: 16-20px standard
- **Shadows**: Subtle elevation with 4-8px blur

## Implemented Screens

### 1. Splash Screen (`/screens/splash/splash_screen.dart`)
- Animated wave background using CustomPainter
- YuvGO logo with brand colors (YUV in cyan, GO in navy)
- Auto-navigates to onboarding after 3 seconds
- Smooth wave animations

### 2. Onboarding Screen (`/screens/onboarding/onboarding_screen.dart`)
- Language selector with flag icons
- Page carousel with 3 onboarding pages
- Premium features showcase
- Page indicators
- "Boshlash" (Start) button to begin

### 3. Home Screen (`/screens/home/home_screen.dart`)
**Features:**
- Premium subscription card with gradient background
- Weather widget with 7-day forecast
- Wash quality rating (92%)
- Premium car washes horizontal scroll
- Nearest car washes list view
- Car wash cards with ratings, distance, and status badges
- Bookmark and notification icons in header

### 4. Car Wash Detail Screen (`/screens/car_wash/car_wash_detail_screen.dart`)
**Features:**
- Image carousel with page indicators
- Premium and 24/7 status badges
- Rating and wash time info cards
- Phone number with call action
- Amenities list (waiting room, games, shop)
- Bottom action buttons (Route, QR Scan)
- Back, bookmark, and share buttons

### 5. Search Screen (`/screens/search/search_screen.dart`)
**Features:**
- Search input with cyan border
- Search history with timestamps
- Search suggestions
- Clean, minimal design
- Close button to dismiss

### 6. Profile Screen (`/screens/profile/profile_screen.dart`)
**Features:**
- User avatar and info
- Stats cards (Car Washes, Visits, Savings)
- Menu items with icons:
  - My Cars
  - Visit History
  - My Cards
  - Settings
  - Privacy Policy
  - Telegram
  - Support Center

### 7. Checkout Screen (`/screens/checkout/checkout_screen.dart`)
**Features:**
- Subscription package display with discount
- Date picker for activation
- Promo code input
- Payment method selection (Cards, Saved Cards, Installments)
- Price breakdown with discounts
- Success dialog on completion
- Yellow CTA button

## Navigation

### Bottom Navigation Bar
- **Asosiy** (Home) - Home icon
- **Xarita** (Map) - Map icon
- **QR Scanner** - Center floating button with cyan background
- **Obuna** (Subscription) - Camera icon
- **Profil** (Profile) - Person icon

Active state: Cyan color
Inactive state: Gray color

## Routes Configuration

```dart
'/': SplashScreen
'/onboarding': OnboardingScreen
'/main': MainNavigation (Home)
'/home': MainNavigation (Home)
'/map': MainNavigation (Map)
'/qr': MainNavigation (QR Scanner)
'/subscriptions': MainNavigation (Subscriptions)
'/profile': MainNavigation (Profile)
'/car-wash-detail': CarWashDetailScreen
'/search': SearchScreen
'/checkout': CheckoutScreen
```

## Key Components

### AppTheme (`/config/app_theme.dart`)
- Centralized theme configuration
- Material 3 design
- Google Fonts integration
- Consistent shadows and elevations
- Input decoration themes
- Button styles

### MainNavigation (`/screens/main_navigation.dart`)
- IndexedStack for screen management
- Custom bottom navigation bar
- Floating QR scanner button
- Smooth transitions

## Design Patterns

### Card Design
- White background
- 12-16px border radius
- Subtle shadow (4px offset, 12px blur)
- 16-20px padding

### Buttons
- Primary: Dark navy background, white text
- Secondary: Yellow background, dark text
- Height: 48-56px
- Border radius: 12px

### Status Badges
- Small pills with colored backgrounds
- 10-12px font size
- Bold weight
- Color-coded (green for open, red for closed)

## Assets Required

The app expects the following asset structure:
```
assets/
  images/
    (car wash photos, logos)
  icons/
    (custom icons if needed)
```

## Dependencies

Key packages used:
- `google_fonts: ^6.1.0` - Typography
- `provider: ^6.1.1` - State management
- `google_maps_flutter: ^2.5.0` - Maps
- `qr_code_scanner: ^1.0.1` - QR scanning
- `intl: ^0.18.1` - Internationalization

## Running the App

```bash
# Get dependencies
flutter pub get

# Run on device/emulator
flutter run

# Build release
flutter build apk --release
```

## Design Principles Applied

1. **Consistency**: Unified spacing, colors, and typography throughout
2. **Hierarchy**: Clear visual hierarchy with size and weight variations
3. **Accessibility**: Sufficient color contrast and touch targets
4. **Modern UI**: Rounded corners, subtle shadows, clean layouts
5. **Brand Identity**: Cyan and navy color scheme with YuvGO branding
6. **User Experience**: Intuitive navigation, clear CTAs, smooth animations

## Next Steps

To complete the implementation:
1. Connect to backend API endpoints
2. Implement map functionality with Google Maps
3. Add QR scanner functionality
4. Implement payment gateway integration
5. Add localization for multiple languages
6. Test on various screen sizes
7. Add loading states and error handling
8. Implement offline functionality

## Notes

- All screens are designed to match the Figma designs pixel-perfectly
- The app uses Material Design 3 principles
- Responsive design considerations for different screen sizes
- Smooth animations and transitions throughout
- Clean, maintainable code structure with separation of concerns
