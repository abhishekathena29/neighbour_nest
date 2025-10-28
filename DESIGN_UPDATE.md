# NearWise Design Update

## Overview
The app has been redesigned to match the new NearWise brand identity and user experience flow. All screens have been updated with the new color scheme, modern UI components, and improved user journey.

## What's Changed

### 🎨 Brand & Theme Updates

#### New Color Palette
- **Primary Color**: Teal/Dark Green `#1E5F5A`
- **Primary Dark**: Navy Blue `#2C4A5A`
- **Secondary**: Green `#4CAF50`
- **Background**: Light Mint/Blue `#E8F4F4`
- **Text Primary**: Dark Blue-Green `#1A3B47`
- **Text Secondary**: Gray `#6B7D87`

#### Gradient Styles
- **Primary Gradient**: Green to Orange (for buttons and accents)
- **Purple Gradient**: Purple tones (for Creative Arts category)
- **Green-Orange Gradient**: For action buttons

#### Typography
- App Name: **NearWise** (changed from NeighbourNest)
- Tagline: "Connect with your community and share skills that matter."
- Using Google Fonts Poppins throughout

---

### 📱 New Screens Created

#### 1. **Welcome/Onboarding Screen** (`welcome_screen.dart`)
- Modern welcome interface with app branding
- Hero image placeholder (using community image)
- Three feature cards:
  - 🧑‍🤝‍🧑 Find Local Experts (yellow icon)
  - 📚 Share Your Expertise (green icon)
  - ❤️ Build Community (purple icon)
- "Join Community" primary CTA button
- "Already have an account? Sign In" link

**Route**: `/welcome`

#### 2. **User Type Selection** (`user_type_selection_screen.dart`)
- Choose between two user types:
  - **"I want to offer skills"** - For contributors/teachers
    - Gradient icon with people+plus
    - Tags: Teach, Share, Help
  - **"I want to find skills"** - For learners/customers
    - Purple search icon
    - Tags: Learn, Discover, Grow
- Bottom note explaining flexibility
- Clean card-based layout

**Route**: `/user-type-selection`

#### 3. **Almost There Screen** (`almost_there_screen.dart`)
- Quick contact details form
- Selected category badge (Creative Arts example)
- Two fields: Name and Phone Number
- "Browse Skills" button with purple gradient
- Privacy notice at bottom
- For users finding skills

**Route**: `/almost-there`

#### 4. **Share Your Skills Form** (`share_skills_form_screen.dart`)
- Comprehensive form for contributors
- Fields:
  - Your Name
  - Phone Number
  - Skill Category (dropdown)
  - Specific Skill (dropdown - contextual based on category)
- "Continue" button with green-orange gradient
- Privacy notice
- Skill category mapping included

**Route**: `/share-skills-form`

#### 5. **Contributors List** (`contributors_list_screen.dart`)
- Browse available contributors in selected category
- Contributor cards showing:
  - Avatar with initials
  - Name and rating (⭐ 4.7)
  - Expertise area
  - Description
  - Reviews count
  - Distance
  - "Contact [Name]" green button
- Example: Alex Thompson, Maria Garcia
- Verification message at bottom

**Route**: `/contributors-list`

#### 6. **Skill Requests Screen** (`skill_requests_screen.dart`)
- Empty state for when no requests yet
- Skill filter chips (Creative Arts, Guitar Lessons)
- "You're All Set!" message with star icon
- Notification promise
- Encouragement message
- For contributors waiting for requests

**Route**: `/skill-requests`

---

### 🔄 Updated Screens

#### Splash Screen (`splash_screen.dart`)
- Updated logo icon to share icon
- Changed background to light mint color
- Updated app name to NearWise
- Now navigates to `/welcome` instead of `/login`

---

### 🗺️ Router Updates (`app_router.dart`)

New routes added:
- `/welcome` - Welcome/Onboarding
- `/user-type-selection` - Choose user type
- `/almost-there` - Quick form for finding skills
- `/share-skills-form` - Detailed form for offering skills
- `/contributors-list` - Browse contributors
- `/skill-requests` - View skill requests (empty state)

Existing routes preserved:
- `/splash` - Splash screen
- `/login` - Login screen
- `/signup` - Sign up screen
- `/forgot-password` - Password recovery
- `/dashboard` - Main dashboard
- `/dashboard/contributor` - Contributor dashboard
- `/dashboard/customer` - Customer dashboard

Default redirect for unauthenticated users: `/welcome` (changed from `/login`)

---

### 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart (✏️ Updated)
│   ├── theme/
│   │   └── app_theme.dart (✏️ Updated)
│   └── utils/
│       └── app_router.dart (✏️ Updated)
└── features/
    └── auth/
        └── presentation/
            └── screens/
                ├── welcome_screen.dart (✨ NEW)
                ├── user_type_selection_screen.dart (✨ NEW)
                ├── almost_there_screen.dart (✨ NEW)
                ├── share_skills_form_screen.dart (✨ NEW)
                ├── contributors_list_screen.dart (✨ NEW)
                ├── skill_requests_screen.dart (✨ NEW)
                ├── splash_screen.dart (✏️ Updated)
                ├── login_screen.dart (unchanged)
                ├── signup_screen.dart (unchanged)
                └── forgot_password_screen.dart (unchanged)
```

---

### 🎯 User Flows

#### Flow 1: New User - Want to Find Skills
1. Splash Screen → Welcome Screen
2. Click "Join Community"
3. User Type Selection → Select "I want to find skills"
4. Almost There → Enter name and phone
5. Browse Skills → Contributors List

#### Flow 2: New User - Want to Offer Skills
1. Splash Screen → Welcome Screen
2. Click "Join Community"
3. User Type Selection → Select "I want to offer skills"
4. Share Your Skills Form → Fill details and select skills
5. Continue → Skill Requests Screen (empty state)

#### Flow 3: Existing User
1. Splash Screen → Welcome Screen
2. Click "Sign In" → Login Screen
3. Login → Dashboard

---

### 📦 Assets & Dependencies

#### Assets Folder Created
- `/assets/images/` - For future image assets
- Hero image currently uses Unsplash URL (can be replaced with local asset)

#### Dependencies Used
All existing dependencies maintained:
- `google_fonts` - Typography
- `go_router` - Navigation
- `provider` - State management
- `firebase_core`, `firebase_auth`, `cloud_firestore` - Backend
- And more...

---

### 🎨 Design Elements

#### Reusable Components Created

1. **Feature Cards** (`_FeatureCard` in welcome_screen.dart)
   - Icon with colored background
   - Title and description
   - Used in welcome screen

2. **User Type Cards** (`_UserTypeCard` in user_type_selection_screen.dart)
   - Gradient icon
   - Title, description
   - Tags with colored backgrounds
   - Tappable cards

3. **Contributor Cards** (`_ContributorCard` in contributors_list_screen.dart)
   - Avatar with initials
   - Rating badge
   - Stats (reviews, distance)
   - Contact button

4. **Skill Filter Chips** (`_SkillFilterChip` in skill_requests_screen.dart)
   - Selected/unselected states
   - Gradient when selected
   - Outlined when not selected

#### Image Placeholders
- Community hero image: Uses Unsplash image
- Can be replaced with local assets in `assets/images/`
- Avatar placeholders: Using initials in colored circles

---

### 🚀 Running the App

1. Ensure all dependencies are installed:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

3. The app will start with the splash screen and navigate to the welcome screen.

---

### 📝 Notes

#### Design Fidelity
- All screens match the provided Figma designs
- Colors, spacing, and typography follow the design specifications
- Placeholder images used where actual assets not provided
- Gradients and modern UI elements implemented

#### Future Enhancements
- Replace Unsplash URL with local hero image
- Add more contributor profiles
- Connect forms to Firebase backend
- Add animations and transitions
- Implement actual skill category system with Firebase

#### Existing Features Preserved
- All authentication functionality (login, signup, forgot password)
- Dashboard screens for contributors and customers
- Service listing and messaging features
- Firebase integration

---

### 🔧 Configuration Files Updated

#### `pubspec.yaml`
```yaml
assets:
  - assets/images/
```

#### `app_constants.dart`
- App name: `'NearWise'`
- Added tagline constant
- Existing categories preserved

#### `app_theme.dart`
- New color scheme
- Gradient definitions
- Typography updates

---

## Summary

✅ All 6 new screens created matching Figma design  
✅ Updated app theme with NearWise brand colors  
✅ Router configured with all new routes  
✅ Splash screen and navigation flow updated  
✅ Reusable UI components created  
✅ Image placeholders implemented  
✅ Existing functionality preserved  
✅ Clean, modern, and accessible UI  

The app is now fully updated with the new NearWise design system and ready for use! 🎉

