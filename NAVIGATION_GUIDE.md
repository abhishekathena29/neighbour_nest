# NearWise - Complete Navigation Guide

## 🎯 Navigation Overview

All navigation has been implemented and tested. The app uses GoRouter for declarative routing with proper authentication guards.

---

## 🗺️ Complete Route Map

### Public Routes (No Authentication Required)

| Route | Screen | Purpose | Can Navigate To |
|-------|--------|---------|-----------------|
| `/splash` | Splash Screen | App initialization | `/welcome` or `/dashboard` |
| `/welcome` | Welcome Screen | Onboarding entry point | `/user-type-selection`, `/login` |
| `/user-type-selection` | User Type Selection | Choose offer/find skills | `/share-skills-form`, `/almost-there` |
| `/almost-there` | Quick Form | Fast signup for finding skills | `/contributors-list` |
| `/share-skills-form` | Skills Form | Full signup for offering skills | `/skill-requests` |
| `/contributors-list` | Contributors List | Browse available contributors | Back navigation |
| `/skill-requests` | Skill Requests | View requests (empty state) | Back navigation |
| `/login` | Login Screen (Old) | Existing user login | `/dashboard`, `/signup` |
| `/signup` | Signup Screen (Old) | Traditional signup | `/dashboard`, `/login` |
| `/forgot-password` | Password Recovery | Reset password | Back to `/login` |

### Protected Routes (Authentication Required)

| Route | Screen | Purpose |
|-------|--------|---------|
| `/dashboard` | Dashboard Screen | Main dashboard |
| `/dashboard/contributor` | Contributor Dashboard | For service providers |
| `/dashboard/customer` | Customer Dashboard | For service seekers |

---

## 🔄 Complete User Flows

### Flow 1: New User - Want to Find Skills (Learning)

```
1. App Launches
   → Splash Screen (2 seconds)
   
2. Auto-Navigate
   → Welcome Screen
   Route: /welcome
   
3. User Action: Tap "Join Community"
   → User Type Selection Screen
   Route: /user-type-selection
   
4. User Action: Tap "I want to find skills" card
   → Almost There Screen
   Route: /almost-there
   
5. User Action: Fill name and phone, tap "Browse Skills"
   → Contributors List Screen
   Route: /contributors-list
   Shows: Alex Thompson, Maria Garcia profiles
   
6. User Action: Tap "Contact Alex" (or any contributor)
   → [Future: Opens contact/messaging]
   Current: Shows contact action
   
7. User Action: Tap back arrow
   → Can navigate back through the flow
```

### Flow 2: New User - Want to Offer Skills (Teaching)

```
1. App Launches
   → Splash Screen (2 seconds)
   
2. Auto-Navigate
   → Welcome Screen
   Route: /welcome
   
3. User Action: Tap "Join Community"
   → User Type Selection Screen
   Route: /user-type-selection
   
4. User Action: Tap "I want to offer skills" card
   → Share Skills Form Screen
   Route: /share-skills-form
   
5. User Action: Fill form (name, phone, category, specific skill), tap "Continue"
   → Skill Requests Screen
   Route: /skill-requests
   Shows: Empty state with "You're All Set!" message
   
6. User Action: Can filter skills with chips
   → Toggles between "Creative Arts" and "Guitar Lessons"
   
7. User Action: Tap back arrow
   → Can navigate back through the flow
```

### Flow 3: Existing User - Quick Login

```
1. App Launches
   → Splash Screen (2 seconds)
   
2. Auto-Navigate
   → Welcome Screen
   Route: /welcome
   
3. User Action: Tap "Sign In" link
   → Login Screen
   Route: /login
   
4. User Action: Enter credentials, tap "Sign In"
   → Dashboard Screen
   Route: /dashboard
   [Requires authentication]
   
5. Alternative: Tap "Forgot Password?"
   → Forgot Password Screen
   Route: /forgot-password
```

### Flow 4: Direct Signup (Traditional)

```
1. From Welcome Screen or Login Screen
   → User Action: Tap "Sign Up"
   → Signup Screen
   Route: /signup
   
2. User Action: Fill complete form, tap "Sign Up"
   → Dashboard Screen
   Route: /dashboard
   [Creates account and authenticates]
```

### Flow 5: Returning Authenticated User

```
1. App Launches
   → Splash Screen (2 seconds)
   
2. Auto-Navigate (Auth Check)
   → Dashboard Screen
   Route: /dashboard
   [Skips welcome flow entirely]
```

---

## 🎮 Interactive Navigation Elements

### Welcome Screen
- **"Join Community" Button** → `/user-type-selection`
- **"Sign In" Link** → `/login`
- **Back Button**: None (entry point)

### User Type Selection Screen
- **"I want to offer skills" Card** → `/share-skills-form`
- **"I want to find skills" Card** → `/almost-there`
- **Back Arrow** → `/welcome`

### Almost There Screen
- **"Browse Skills" Button** → `/contributors-list`
- **Back Arrow** → `/user-type-selection`

### Share Skills Form Screen
- **"Continue" Button** → `/skill-requests`
- **Back Arrow** → `/user-type-selection`

### Contributors List Screen
- **"Contact [Name]" Button** → Contact action (future messaging)
- **Back Arrow** → `/almost-there`

### Skill Requests Screen
- **Filter Chips** → Toggle selected skill
- **Back Arrow** → `/share-skills-form`

### Login Screen (Old Design)
- **"Sign In" Button** → `/dashboard` (on success)
- **"Forgot Password?" Link** → `/forgot-password`
- **"Sign Up" Link** → `/signup`
- **Back Arrow** → `/welcome`

### Signup Screen (Old Design)
- **"Sign Up" Button** → `/dashboard` (on success)
- **"Sign In" Link** → `/login`
- **Back Arrow** → `/welcome`

---

## 🔒 Authentication & Route Guards

### Public Access (No Auth Required)
All onboarding and auth screens are publicly accessible:
- Splash, Welcome, User Type Selection
- Almost There, Share Skills Form
- Contributors List, Skill Requests
- Login, Signup, Forgot Password

### Protected Access (Auth Required)
Dashboard and related screens require authentication:
- Dashboard
- Contributor Dashboard
- Customer Dashboard

### Redirect Logic
```dart
// If user tries to access protected route without auth
→ Redirects to /welcome

// If authenticated user opens app
→ Goes directly to /dashboard from splash

// All public routes remain accessible regardless of auth state
```

---

## 📱 Responsive Design

All screens are fully responsive and work on:
- ✅ Small phones (320px width)
- ✅ Standard phones (375px - 414px width)
- ✅ Large phones (428px+ width)
- ✅ Tablets (600px+ width) with max-width constraints

### Responsive Features
- **Dynamic Padding**: Adjusts based on screen size
- **Max Width Constraint**: 600px on tablets to prevent stretching
- **Flexible Layouts**: All content scales appropriately
- **Touch-Friendly**: All interactive elements are properly sized

---

## 🧪 Navigation Testing Checklist

### ✅ Forward Navigation
- [x] Splash → Welcome (auto after 2s)
- [x] Welcome → User Type Selection (tap Join Community)
- [x] Welcome → Login (tap Sign In)
- [x] User Type → Almost There (tap Find Skills)
- [x] User Type → Share Skills (tap Offer Skills)
- [x] Almost There → Contributors List (tap Browse)
- [x] Share Skills → Skill Requests (tap Continue)
- [x] Login → Dashboard (successful login)
- [x] Signup → Dashboard (successful signup)

### ✅ Back Navigation
- [x] User Type → Welcome (back button)
- [x] Almost There → User Type (back button)
- [x] Share Skills → User Type (back button)
- [x] Contributors → Almost There (back button)
- [x] Skill Requests → Share Skills (back button)
- [x] Login → Welcome (back button)
- [x] Signup → Welcome (back button)

### ✅ Cross Navigation
- [x] Login ↔ Signup (links work bidirectionally)
- [x] Login → Forgot Password (tap link)
- [x] Forgot Password → Login (back button)

### ✅ Authentication Flow
- [x] Unauthenticated → Redirects to welcome for protected routes
- [x] Authenticated → Direct access to dashboard
- [x] Authenticated → Can still access public routes if needed

### ✅ Deep Linking
- [x] Can navigate directly to any public route
- [x] Protected routes redirect properly when not authenticated
- [x] URL state is maintained

---

## 🚀 How to Test Navigation

### Manual Testing

1. **Clean Install Test**
```bash
flutter clean
flutter pub get
flutter run
```
Expected: Splash → Welcome after 2 seconds

2. **Complete Onboarding Test (Find Skills)**
- Tap "Join Community"
- Tap "I want to find skills"
- Fill form, tap "Browse Skills"
- View contributors list
- Verify: All transitions smooth, data displays correctly

3. **Complete Onboarding Test (Offer Skills)**
- Tap "Join Community"
- Tap "I want to offer skills"
- Fill form, select category and skill
- Tap "Continue"
- Verify: Skill requests screen shows empty state

4. **Back Navigation Test**
- Navigate through any flow
- Use device back button or app back arrow
- Verify: Returns to previous screen correctly

5. **Login Flow Test**
- From welcome, tap "Sign In"
- Enter credentials
- Verify: Navigates to dashboard on success

### Automated Testing (Future)

```dart
// Example navigation test structure
testWidgets('Welcome to Contributors List flow', (WidgetTester tester) async {
  // Launch app
  await tester.pumpWidget(MyApp());
  
  // Wait for splash
  await tester.pumpAndSettle(Duration(seconds: 3));
  
  // Verify on welcome screen
  expect(find.text('NearWise'), findsOneWidget);
  
  // Tap Join Community
  await tester.tap(find.text('Join Community'));
  await tester.pumpAndSettle();
  
  // Tap Find Skills
  await tester.tap(find.text('I want to find skills'));
  await tester.pumpAndSettle();
  
  // Fill form and submit
  // ... test continues
});
```

---

## 📊 Navigation State Management

### Current Implementation
- Uses **GoRouter** for declarative routing
- Routes defined in `app_router.dart`
- Authentication state checked via **Provider**
- Redirects handled in `redirect` callback

### Route Configuration
```dart
GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    // Public routes always accessible
    if (publicRoutes.contains(state.uri.path)) {
      return null;
    }
    
    // Protected routes require auth
    if (!authProvider.isAuthenticated) {
      return '/welcome';
    }
    
    return null;
  },
  routes: [
    // All routes defined here
  ],
)
```

---

## 🔧 Troubleshooting Navigation Issues

### Issue: Navigation doesn't work
**Solution**: Check that route is defined in `app_router.dart`

### Issue: Stuck on splash screen
**Solution**: Verify `splash_screen.dart` navigation logic, check auth provider state

### Issue: Unexpected redirects
**Solution**: Review redirect logic in `app_router.dart`, check auth state

### Issue: Back button doesn't work
**Solution**: Ensure using `context.pop()` from go_router, not Navigator.pop()

### Issue: Deep link not working
**Solution**: Verify route path matches exactly, check public routes list

---

## 📝 Navigation Best Practices

### Do's ✅
- Use `context.go('/route')` for navigation
- Use `context.pop()` for back navigation
- Check auth state before protected navigation
- Use `ResponsiveWrapper` for all screens
- Test on multiple screen sizes

### Don'ts ❌
- Don't use `Navigator.push()` (use GoRouter instead)
- Don't hardcode screen transitions
- Don't skip authentication checks
- Don't forget to handle back button
- Don't nest navigators unnecessarily

---

## 🎯 Navigation Summary

**Total Routes**: 13 (10 public, 3 protected)  
**User Flows**: 5 complete flows  
**Screens**: 12 unique screens  
**Navigation Type**: Declarative (GoRouter)  
**Auth Integration**: ✅ Implemented  
**Responsive**: ✅ All screens  
**Back Navigation**: ✅ All screens  
**Testing**: ✅ Manual tested  

---

**All navigation is working correctly and has been tested! 🎉**

The app provides smooth, intuitive navigation between all screens with proper authentication guards and responsive design.

