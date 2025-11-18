# 🔐 CanCare Admin Authentication System

Complete authentication flow for CanCare Healthcare Admin mobile app built with Flutter and Firebase.

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point with auth routing
├── firebase_options.dart              # Firebase configuration (auto-generated)
├── screens/
│   └── auth/
│       ├── admin_login_screen.dart    # Admin login with phone + password
│       └── forgot_password_screen.dart # 3-step password reset flow
└── widgets/
    ├── primary_button.dart            # Reusable primary button widget
    └── phone_text_field.dart          # Phone number input with validation

assets/
└── images/
    └── admin_login_bg.png            # Login background image
```

## ✨ Features

### 🔑 Admin Login Screen
- Login with **phone number + password**
- Beautiful UI with background image
- Form validation
- Error handling with user-friendly messages
- Loading indicators
- "Forgot password?" link

### 🔄 Forgot Password Flow (3 Steps)
1. **Enter Phone Number** → Send OTP via Firebase Phone Auth
2. **Verify OTP** → Enter 6-digit code received via SMS
3. **Set New Password** → Update password in Firebase Auth

## 🚀 Quick Start

### 1. Configure Firebase
See `FIREBASE_SETUP_GUIDE.md` for detailed instructions.

### 2. Add Background Image
Place your login background image at:
```
assets/images/admin_login_bg.png
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Run the App
```bash
flutter run
```

## 📱 Usage

### Admin Login
1. Enter phone number (e.g., `799999999`)
2. Enter password
3. Tap "تسجيل الدخول / Log In"

**Note:** Phone numbers are converted to email format: `phone@cancare.com` for Firebase Auth.

### Forgot Password
1. On login screen, tap "نسيت كلمة المرور؟ / Forgot password?"
2. Enter phone number → Tap "Send OTP"
3. Enter 6-digit OTP code → Tap "Verify OTP"
4. Enter new password and confirm → Tap "Update Password"
5. You'll be signed out and redirected to login

## 🔧 Technical Details

### Authentication Flow
- Uses Firebase Email/Password auth with phone number as email identifier
- Format: `{phone}@cancare.com`
- Password reset uses Firebase Phone Auth for verification

### Key Components
- **PhoneTextField**: Validates phone input (Jordan +962 format)
- **PrimaryButton**: Reusable button with loading state
- **AuthWrapper**: StreamBuilder checks auth state automatically
- **Form Validation**: All forms use GlobalKey<FormState>

### Error Handling
- Comprehensive try/catch blocks
- Firebase error codes mapped to user-friendly messages
- SnackBar notifications for errors and success
- Network error handling

## 🎨 UI Features
- Material Design 3
- Healthcare-themed blue color scheme
- Responsive layout
- Loading states
- Progress indicators for multi-step flows
- Arabic/English bilingual labels

## 📋 Prerequisites
- Flutter SDK 3.7.2+
- Firebase project configured
- Android device/emulator for testing
- SHA-1/SHA-256 keys added to Firebase (for Phone Auth)

## 📖 Firebase Setup
See `FIREBASE_SETUP_GUIDE.md` for complete Firebase configuration instructions.

## 🔒 Security Notes
- Passwords must be at least 6 characters
- OTP codes expire after 60 seconds
- Phone numbers validated for format
- Password confirmation required
- User signed out after password update

## 🐛 Troubleshooting

**Issue:** OTP not received
- Check phone number format includes country code
- Verify SHA-1/SHA-256 added to Firebase
- Check Firebase project has SMS quota

**Issue:** Login fails
- Verify admin user exists in Firebase Console
- Check email format: `phone@cancare.com`
- Verify password matches Firebase Console

**Issue:** Background image not showing
- Ensure image exists at `assets/images/admin_login_bg.png`
- Run `flutter pub get`
- Check `pubspec.yaml` includes assets section

## 📝 Next Steps
- Replace placeholder `HomeScreen` with actual admin dashboard
- Add more authentication methods if needed
- Implement remember me functionality
- Add biometric authentication
- Enhance error handling and logging

## 👨‍💻 Development
- All code follows Flutter best practices
- Null-safety enabled
- Clean architecture
- Comprehensive comments
- Modular, reusable widgets

---

**Built for CanCare Healthcare Admin App**
*Version 1.0.0*

