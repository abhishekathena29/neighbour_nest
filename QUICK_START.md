# NearWise - Quick Start Guide

## 🚀 Run the App

```bash
cd /Users/abhishek/Desktop/athena_pro/neighbour_nest
flutter pub get
flutter run
```

## 📱 Testing the New Design

### Test Flow 1: Find Skills Journey
1. App launches → **Splash Screen** (2 seconds)
2. Auto-navigates → **Welcome Screen**
3. Tap "Join Community"
4. On **User Type Selection**, tap "I want to find skills"
5. Fill form on **Almost There** screen
6. Tap "Browse Skills"
7. View **Contributors List** with sample profiles

### Test Flow 2: Offer Skills Journey
1. App launches → **Splash Screen** (2 seconds)
2. Auto-navigates → **Welcome Screen**
3. Tap "Join Community"
4. On **User Type Selection**, tap "I want to offer skills"
5. Fill form on **Share Skills Form** (select category & skill)
6. Tap "Continue"
7. View **Skill Requests** empty state

### Test Flow 3: Existing User
1. From **Welcome Screen**, tap "Sign In"
2. Redirects to existing **Login Screen**
3. (Login flow unchanged)

## 🎨 What You'll See

### New Branding
- App name: **NearWise** (not NeighbourNest)
- Logo: Share icon in teal circle
- Colors: Light mint background, teal/navy accents
- Modern, clean design

### New Screens (6 total)
1. ✅ Welcome/Onboarding
2. ✅ User Type Selection
3. ✅ Almost There Form
4. ✅ Share Skills Form
5. ✅ Contributors List
6. ✅ Skill Requests (Empty State)

## 📂 Key Files

### New Screens Location
```
lib/features/auth/presentation/screens/
├── welcome_screen.dart
├── user_type_selection_screen.dart
├── almost_there_screen.dart
├── share_skills_form_screen.dart
├── contributors_list_screen.dart
└── skill_requests_screen.dart
```

### Updated Files
```
lib/main.dart - App title
lib/core/theme/app_theme.dart - Colors & theme
lib/core/constants/app_constants.dart - App name
lib/core/utils/app_router.dart - Routes
```

## 🎯 Routes Available

| Route | Screen | Access |
|-------|--------|--------|
| `/splash` | Splash | Auto |
| `/welcome` | Welcome | Public |
| `/user-type-selection` | User Type | Public |
| `/almost-there` | Quick Form | Public |
| `/share-skills-form` | Skills Form | Public |
| `/contributors-list` | Contributors | Public |
| `/skill-requests` | Requests | Public |
| `/login` | Login | Public |
| `/signup` | Sign Up | Public |
| `/dashboard` | Dashboard | Protected |

## 📖 Documentation

- **DESIGN_UPDATE.md** - Complete implementation details
- **SCREEN_FLOW.md** - Visual flow diagrams
- **IMPLEMENTATION_SUMMARY.md** - Summary & stats
- **QUICK_START.md** - This file!

## 🎨 Color Reference

```dart
Primary: #1E5F5A (Teal)
Navy: #2C4A5A
Green: #4CAF50
Background: #E8F4F4 (Light Mint)
Text: #1A3B47
```

## ✅ Verification Checklist

Run these to verify everything works:

```bash
# Check for errors
flutter analyze

# Run tests (if any)
flutter test

# Build for release
flutter build apk
```

## 🐛 Troubleshooting

### Issue: White screen after splash
- **Solution**: Wait 2 seconds, should auto-navigate

### Issue: Image not loading
- **Solution**: Check internet connection (hero image from Unsplash)

### Issue: Routes not working
- **Solution**: Run `flutter clean && flutter pub get`

## 📱 Screenshot Locations

All 6 new screens match the Figma designs:
- Light mint/blue backgrounds
- Teal/navy buttons
- Clean, modern UI
- Proper spacing and typography

## 🎉 You're All Set!

The app now has:
- ✅ Complete NearWise redesign
- ✅ 6 new onboarding screens
- ✅ Modern color scheme
- ✅ Professional UI
- ✅ All Figma designs implemented

**Ready to test!** 🚀

