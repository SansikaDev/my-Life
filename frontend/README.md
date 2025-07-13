# FitVibe - Modern Fitness Application

A comprehensive fitness application built with Flutter and Node.js, featuring personalized workouts, meal plans, and coach booking.

## 🏋️‍♂️ Features

### Frontend (Flutter)
- **Modern UI/UX** with gradient designs and smooth animations
- **User Authentication** with secure login/register
- **Dashboard** with stats tracking and quick actions
- **Exercise Library** with categorized workouts
- **Meal Planning** with nutrition tracking
- **Coach Booking** system
- **Progress Tracking** and analytics
- **Real-time Notifications**

### Backend (Node.js + MongoDB)
- **RESTful API** with Express.js
- **JWT Authentication** for secure access
- **MongoDB Database** with Mongoose ODM
- **File Upload** for images and videos
- **Real-time Features** with WebSocket
- **Email Notifications**

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Node.js (18 or higher)
- MongoDB (5.0 or higher)
- iOS Simulator or Android Emulator

### Frontend Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For iOS
   flutter run -d ios
   
   # For Android
   flutter run -d android
   
   # For Web
   flutter run -d chrome
   ```

### Backend Setup (Coming Soon)

1. **Navigate to backend directory**
   ```bash
   cd ../backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Start the server**
   ```bash
   npm run dev
   ```

## 📱 App Screenshots

### Splash Screen
- Beautiful gradient background
- Exercise animation using Lottie
- Smooth loading transitions

### Authentication
- Modern login/register forms
- Form validation
- Password visibility toggles
- User onboarding with fitness preferences

### Dashboard
- Stats cards (steps, calories, workouts)
- Today's workout preview
- Quick action buttons
- Recent activities feed

## 🎨 Design System

### Colors
- **Primary**: `#6366F1` (Indigo)
- **Secondary**: `#8B5CF6` (Purple)
- **Accent**: `#06B6D4` (Cyan)
- **Success**: `#10B981` (Green)
- **Warning**: `#F59E0B` (Amber)
- **Error**: `#EF4444` (Red)

### Typography
- **Font Family**: Poppins (Google Fonts)
- **Headings**: 32px, 24px, 20px
- **Body**: 16px, 14px
- **Caption**: 12px

### Components
- **Buttons**: Rounded corners (12px), gradient backgrounds
- **Cards**: Subtle shadows, 16px border radius
- **Input Fields**: Filled style with focus states
- **Navigation**: Bottom tab bar with icons

## 📊 Data Models

### User Model
```dart
class UserModel {
  final String id;
  final String email;
  final String name;
  final double? height;
  final double? weight;
  final String? fitnessGoal;
  final String? activityLevel;
  final List<String>? interests;
  final String? coachId;
  // ... more fields
}
```

### Exercise Model
```dart
class ExerciseModel {
  final String id;
  final String name;
  final String category;
  final String difficulty;
  final List<String> muscleGroups;
  final List<String> equipment;
  final int? duration;
  final int? sets;
  final int? reps;
  // ... more fields
}
```

### Meal Plan Model
```dart
class MealPlanModel {
  final String id;
  final String name;
  final String category;
  final int totalCalories;
  final List<MealModel> meals;
  final int duration;
  // ... more fields
}
```

## 🔧 Dependencies

### Frontend Dependencies
- `flutter_riverpod`: State management
- `dio`: HTTP client
- `lottie`: Animations
- `google_fonts`: Typography
- `cached_network_image`: Image caching
- `flutter_secure_storage`: Secure data storage
- `flutter_spinkit`: Loading indicators
- `intl`: Internationalization
- `flutter_svg`: SVG support
- `shimmer`: Loading placeholders
- `carousel_slider`: Image carousels
- `fl_chart`: Charts and graphs
- `image_picker`: Image selection
- `permission_handler`: Permissions
- `url_launcher`: URL handling
- `share_plus`: Social sharing
- `flutter_local_notifications`: Notifications
- `pedometer`: Step counting
- `sensors_plus`: Device sensors

## 🏗️ Project Structure

```
frontend/
├── lib/
│   ├── constants/
│   │   └── app_theme.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── coach_model.dart
│   │   ├── exercise_model.dart
│   │   └── meal_plan_model.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── dashboard_screen.dart
│   ├── services/
│   │   └── api_service.dart
│   ├── widgets/
│   │   └── custom_text_field.dart
│   └── main.dart
├── assets/
│   ├── animations/
│   ├── images/
│   ├── icons/
│   └── data/
└── pubspec.yaml
```

## 🚀 Deployment

### Frontend Deployment
1. **Build for production**
   ```bash
   flutter build apk --release  # Android
   flutter build ios --release  # iOS
   flutter build web --release  # Web
   ```

2. **Deploy to stores**
   - Android: Upload APK to Google Play Console
   - iOS: Upload to App Store Connect
   - Web: Deploy to Firebase Hosting or similar

### Backend Deployment
1. **Build and deploy to cloud platform**
   - Heroku
   - AWS
   - Google Cloud Platform
   - DigitalOcean

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

If you encounter any issues or have questions:
1. Check the documentation
2. Search existing issues
3. Create a new issue with detailed information

## 🎯 Roadmap

### Phase 1 (Current)
- ✅ Basic UI/UX design
- ✅ User authentication
- ✅ Dashboard layout
- ✅ Data models

### Phase 2 (Next)
- 🔄 Backend API development
- 🔄 Database integration
- 🔄 Real authentication
- 🔄 Exercise library

### Phase 3 (Future)
- 📋 Meal planning system
- 📋 Coach booking
- 📋 Progress tracking
- 📋 Social features
- 📋 AI recommendations

---

**Built with ❤️ using Flutter and Node.js**
