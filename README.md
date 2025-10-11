# NeighbourNest

A community-based skill sharing platform that connects neighbors to offer and find services within their residential communities.

## Features

### Core Features (Pre-Phase)
- **User Authentication**: Separate login/signup for Contributors and Customers
- **User Types**: 
  - Contributors: Residents who offer services and skills
  - Customers: Residents who seek services and help
- **Service Categories**: Academic tutoring, professional services, creative arts, health & wellness, technology, home services, lifestyle, and more
- **Dynamic Filtering**: Filter services by category, availability, and expertise
- **Basic Messaging**: Lightweight in-app chat system
- **Rating System**: Star ratings with optional comments
- **Modern UI**: Clean, intuitive design with Material Design 3

### Planned Features
- Emergency help alerts within specific categories
- Workshop and group session options
- Contributor discovery based on proximity and ratings
- Advanced search and filtering
- Push notifications
- Service booking and scheduling

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **State Management**: Provider
- **Navigation**: Go Router
- **UI**: Material Design 3 with custom theme
- **Icons**: Material Icons + Custom icons

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── services/           # Firebase and external services
│   ├── theme/              # App theme and styling
│   └── utils/              # Utility functions and helpers
├── features/
│   ├── auth/               # Authentication feature
│   │   ├── data/           # Data layer (repositories)
│   │   └── presentation/   # UI layer (screens, widgets, providers)
│   ├── dashboard/          # Dashboard feature
│   ├── services/           # Service listing and management
│   ├── messaging/          # In-app messaging
│   └── profile/            # User profile management
└── shared/
    ├── models/             # Data models
    └── widgets/            # Reusable UI components
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase project

### 1. Clone the Repository
```bash
git clone <repository-url>
cd neighbour_nest
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "neighbour-nest"
3. Enable Authentication (Email/Password)
4. Enable Firestore Database
5. Enable Storage

#### Configure Firebase for Flutter
1. Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

2. Configure Firebase for your project:
```bash
flutterfire configure
```

3. This will generate `lib/firebase_options.dart` with your project configuration.

### 4. Update Firebase Configuration
Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase project credentials.

### 5. Run the App
```bash
flutter run
```

## User Flow

### For Contributors
1. Sign up as a Contributor
2. Complete profile setup
3. Add services and skills
4. Manage service listings
5. Respond to customer requests
6. Track earnings and ratings

### For Customers
1. Sign up as a Customer
2. Browse available services
3. Filter by category and location
4. Contact contributors
5. Book services
6. Rate and review services

## Database Schema

### Users Collection
```json
{
  "id": "user_id",
  "email": "user@example.com",
  "name": "User Name",
  "phone": "+1234567890",
  "userType": "contributor|customer",
  "address": "User Address",
  "societyName": "Society Name",
  "profileImageUrl": "image_url",
  "isVerified": false,
  "rating": 4.5,
  "totalRatings": 10,
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Services Collection
```json
{
  "id": "service_id",
  "contributorId": "user_id",
  "title": "Service Title",
  "description": "Service Description",
  "category": "category_id",
  "tags": ["tag1", "tag2"],
  "serviceType": "oneTime|recurring|workshop",
  "status": "active|inactive|completed|cancelled",
  "price": 500,
  "currency": "INR",
  "location": "Service Location",
  "isOnline": false,
  "availableFrom": "timestamp",
  "availableTo": "timestamp",
  "images": ["image_url1", "image_url2"],
  "maxParticipants": 1,
  "currentParticipants": 0,
  "rating": 4.8,
  "totalRatings": 5,
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## Development

### Adding New Features
1. Create feature folder in `lib/features/`
2. Follow the data/domain/presentation structure
3. Add models to `lib/shared/models/`
4. Update routing in `lib/core/utils/app_router.dart`

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent indentation (2 spaces)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.