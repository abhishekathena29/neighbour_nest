# NearWise App - Screen Flow Diagram

## App Navigation Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                        SPLASH SCREEN                             │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  [NearWise Logo - Share Icon]                            │   │
│  │  NearWise                                                │   │
│  │  Connect with your community                             │   │
│  │  [Loading Spinner]                                       │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
│  Checks authentication status after 2 seconds                    │
│  - If authenticated → Dashboard                                  │
│  - If not authenticated → Welcome Screen                         │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                       WELCOME SCREEN                             │
│                                                                   │
│  [Logo] NearWise                                                │
│  "Connect with your community and share skills that matter."     │
│                                                                   │
│  [Community Hero Image - Placeholder]                           │
│                                                                   │
│  Your Skills, Your Community                                     │
│  Share what you know and learn what you need.                   │
│                                                                   │
│  ┌────────────────────────────────────────────────┐            │
│  │ 🧑‍🤝‍🧑 Find Local Experts                          │            │
│  │    Discover skilled neighbors...                │            │
│  └────────────────────────────────────────────────┘            │
│                                                                   │
│  ┌────────────────────────────────────────────────┐            │
│  │ 📚 Share Your Expertise                         │            │
│  │    Turn your skills into community value.      │            │
│  └────────────────────────────────────────────────┘            │
│                                                                   │
│  ┌────────────────────────────────────────────────┐            │
│  │ ❤️ Build Community                              │            │
│  │    Strengthen local bonds...                   │            │
│  └────────────────────────────────────────────────┘            │
│                                                                   │
│  [Join Community Button - Navy]                                 │
│  Already have an account? [Sign In]                             │
└─────────────────────────────────────────────────────────────────┘
              ↓                                    ↓
    (Join Community)                         (Sign In)
              ↓                                    ↓
┌─────────────────────────────┐      ┌────────────────────────┐
│ USER TYPE SELECTION         │      │   LOGIN SCREEN         │
│                             │      │   (Existing)           │
│ [Logo] NearWise            │      │                        │
│                             │      │   Email               │
│ What brings you to          │      │   Password            │
│ NearWise?                   │      │   [Sign In Button]    │
│                             │      │                        │
│ ┌─────────────────────┐    │      │   Don't have account? │
│ │ 🧑‍🤝‍🧑                 │    │      │   [Sign Up]           │
│ │ I want to offer     │    │      └────────────────────────┘
│ │ skills              │    │
│ │                     │    │
│ │ Teach Share Help    │    │
│ └─────────────────────┘    │
│                             │
│ ┌─────────────────────┐    │
│ │ 🔍                  │    │
│ │ I want to find      │    │
│ │ skills              │    │
│ │                     │    │
│ │ Learn Discover Grow │    │
│ └─────────────────────┘    │
│                             │
│ Don't worry, you can        │
│ always do both!             │
└─────────────────────────────┘
      ↓              ↓
 (Offer)         (Find)
      ↓              ↓
┌──────────┐  ┌──────────────┐
│ SHARE    │  │ ALMOST THERE │
│ SKILLS   │  │              │
│ FORM     │  │ [Logo]       │
│          │  │ NearWise     │
│ [Logo]   │  │              │
│ NearWise │  │ [Creative    │
│          │  │  Arts Badge] │
│ Share    │  │              │
│ Your     │  │ Almost There!│
│ Skills   │  │              │
│          │  │ Enter your   │
│ Name:    │  │ details...   │
│ [Input]  │  │              │
│          │  │ Your Name:   │
│ Phone:   │  │ [Input]      │
│ [Input]  │  │              │
│          │  │ Phone:       │
│ Category:│  │ [Input]      │
│ [Select] │  │              │
│          │  │ [Browse      │
│ Skill:   │  │  Skills]     │
│ [Select] │  │              │
│          │  │ Your contact │
│ [Continue│  │ info helps...│
│  Button] │  └──────────────┘
│          │         ↓
│ Your info│    (Browse Skills)
│ will only│         ↓
│ be shared│  ┌──────────────┐
└──────────┘  │ CONTRIBUTORS │
      ↓       │ LIST         │
 (Continue)   │              │
      ↓       │ [Logo]       │
┌──────────┐  │ NearWise     │
│ SKILL    │  │              │
│ REQUESTS │  │ Creative Arts│
│          │  │ 2 skilled    │
│ [Logo]   │  │ contributors │
│ NearWise │  │              │
│          │  │ ┌──────────┐ │
│ [Creative│  │ │ AT       │ │
│  Arts]   │  │ │ Alex     │ │
│ [Guitar  │  │ │ Thompson │ │
│  Lessons]│  │ │ ⭐ 4.7   │ │
│          │  │ │ General  │ │
│ People   │  │ │ expertise│ │
│ Looking  │  │ │          │ │
│ for Your │  │ │ 💬 15    │ │
│ Skills   │  │ │ 📍 2.0mi │ │
│          │  │ │          │ │
│ No active│  │ │ [Contact]│ │
│ requests │  │ └──────────┘ │
│ yet.     │  │              │
│          │  │ ┌──────────┐ │
│ ┌──────┐ │  │ │ MG       │ │
│ │  ⭐  │ │  │ │ Maria    │ │
│ │      │ │  │ │ Garcia   │ │
│ │You're│ │  │ │ ⭐ 4.8   │ │
│ │All   │ │  │ │ Teaching │ │
│ │Set!  │ │  │ │          │ │
│ │      │ │  │ │ 💬 19    │ │
│ │We'll │ │  │ │ 📍 1.6mi │ │
│ │notify│ │  │ │          │ │
│ │you...│ │  │ │ [Contact]│ │
│ └──────┘ │  │ └──────────┘ │
│          │  │              │
│ Keep your│  │ All contrib. │
│ profile  │  │ are verified │
│ active...│  └──────────────┘
└──────────┘
```

## Route Mapping

### Public Routes (No Authentication Required)
- `/splash` - Splash Screen
- `/welcome` - Welcome/Onboarding
- `/user-type-selection` - Choose user type
- `/almost-there` - Quick form (finding skills)
- `/share-skills-form` - Detailed form (offering skills)
- `/contributors-list` - Browse contributors
- `/skill-requests` - View requests (empty state)
- `/login` - Login (existing)
- `/signup` - Sign up (existing)
- `/forgot-password` - Password recovery (existing)

### Protected Routes (Authentication Required)
- `/dashboard` - Main dashboard
- `/dashboard/contributor` - Contributor dashboard
- `/dashboard/customer` - Customer dashboard

## User Journey Paths

### Path 1: First-time User (Want to Learn)
```
Splash → Welcome → User Type → Almost There → Contributors List → (Contact) → Dashboard
  (2s)    (intro)   (find)      (form)         (browse)
```

### Path 2: First-time User (Want to Teach)
```
Splash → Welcome → User Type → Share Skills → Skill Requests → Dashboard
  (2s)    (intro)   (offer)      (form)         (waiting)
```

### Path 3: Returning User
```
Splash → Welcome → Sign In → Login → Dashboard
  (2s)    (intro)   (link)   (auth)
```

### Path 4: Returning User (Direct Login)
```
Splash → Dashboard
  (2s)   (if already authenticated)
```

## Screen Characteristics

| Screen | Type | Primary Action | Secondary Action |
|--------|------|----------------|------------------|
| Splash | Loading | Auto-navigate | - |
| Welcome | Onboarding | Join Community | Sign In |
| User Type | Selection | Select type | Back |
| Almost There | Form | Browse Skills | Back |
| Share Skills | Form | Continue | Back |
| Contributors | List | Contact | Back |
| Skill Requests | Status | - | Back |
| Login | Auth | Sign In | Sign Up |

## Design Components Used

### Buttons
- **Primary**: Navy blue (#2C4A5A) - "Join Community"
- **Gradient**: Purple - "Browse Skills"
- **Gradient**: Green-Orange - "Continue"
- **Green**: Green (#4CAF50) - "Contact [Name]"

### Cards
- **Feature Cards**: White background, colored icons
- **User Type Cards**: White, gradient icons, tags
- **Contributor Cards**: White, avatar, rating badge
- **Empty State Card**: White, large icon, message

### Forms
- **Text Fields**: White background, rounded corners
- **Dropdowns**: Same styling as text fields
- **Labels**: Bold, dark text

### Badges/Chips
- **Category Badge**: Gradient background, white text
- **Filter Chips**: Selected (gradient) / Unselected (outlined)
- **Tag Chips**: Colored background matching icon

## Color Usage by Screen

- **Welcome**: Light mint bg, navy button, colored icons
- **User Type**: Light mint bg, gradient icons, colored tags
- **Almost There**: Light mint bg, purple gradient button
- **Share Skills**: Light mint bg, green-orange gradient button
- **Contributors**: Light mint bg, green contact buttons
- **Skill Requests**: Light mint bg, gradient filter chips

All screens maintain consistent:
- Background: Light mint/blue (#E8F4F4)
- Text Primary: Dark blue-green (#1A3B47)
- Text Secondary: Gray (#6B7D87)
- NearWise branding and logo

