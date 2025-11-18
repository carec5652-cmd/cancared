# 🔥 Firebase Setup Guide for CanCare Admin App

This guide will help you set up Firebase Authentication for the CanCare Admin mobile app.

---

## 📋 Prerequisites

- Firebase account (create one at [firebase.google.com](https://firebase.google.com))
- Flutter SDK installed (3.7.2 or higher)
- Android Studio (for Android development)
- Android device or emulator

---

## 🚀 Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or select an existing project
3. Enter project name: **"CanCare"** (or your preferred name)
4. Follow the setup wizard:
   - Enable/disable Google Analytics (optional)
   - Complete project creation

---

## 📱 Step 2: Add Android App to Firebase

### 2.1 Add Android App

1. In Firebase Console, click **"Add app"** → Select **Android** icon
2. Enter **Android package name**: `com.example.flutter_application_4`
   - You can find this in `android/app/build.gradle.kts` under `applicationId`
3. Enter **App nickname** (optional): "CanCare Admin Android"
4. Enter **Debug signing certificate SHA-1** (optional for now, but required for Phone Auth)
5. Click **"Register app"**

### 2.2 Download `google-services.json`

1. Download the `google-services.json` file
2. Place it in: `android/app/google-services.json`
   - ⚠️ **Important**: This file should already exist in your project, but make sure it matches your Firebase project

### 2.3 Get SHA-1 and SHA-256 Keys (Required for Phone Auth)

For **debug** keystore (development):

```bash
# Windows
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Copy the **SHA-1** and **SHA-256** values.

For **release** keystore (production):

```bash
keytool -list -v -keystore <path-to-your-release-keystore> -alias <your-key-alias>
```

### 2.4 Add SHA Certificates to Firebase

1. In Firebase Console → Your Project → **Project Settings**
2. Scroll down to **"Your apps"** section
3. Click on your Android app
4. Under **"SHA certificate fingerprints"**, click **"Add fingerprint"**
5. Paste your **SHA-1** key → **Save**
6. Add your **SHA-256** key → **Save**

---

## 🔐 Step 3: Enable Authentication Methods

1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Enable the following providers:

### 3.1 Enable Phone Authentication

1. Click on **"Phone"**
2. Toggle **"Enable"** to ON
3. Click **"Save"**
4. ⚠️ **Important**: Phone authentication requires a paid Firebase plan (Blaze Plan) if using in production

### 3.2 (Optional) Enable Email/Password Authentication

1. Click on **"Email/Password"**
2. Toggle **"Enable"** to ON
3. **Important**: For this app, we use Email/Password with phone numbers formatted as `phone@cancare.com`
4. Click **"Save"**

---

## 👥 Step 4: Create Admin Users

### Option A: Create Admin via Firebase Console

1. Go to **Authentication** → **Users**
2. Click **"Add user"**
3. Enter:
   - **Email**: `799999999@cancare.com` (where `799999999` is the phone number)
   - **Password**: Your desired password (min 6 characters)
4. Click **"Add user"**

### Option B: Register Admin Programmatically (Not included in this code)

You would need to create a registration screen or use Firebase CLI/Admin SDK to create users.

---

## 📦 Step 5: Flutter Configuration

### 5.1 Install FlutterFire CLI (if not already installed)

```bash
dart pub global activate flutterfire_cli
```

### 5.2 Configure Firebase for Flutter

```bash
cd <your-project-directory>
flutterfire configure
```

Follow the prompts:
- Select your Firebase project
- Select platforms: Android (and iOS if needed)
- This will generate/update `lib/firebase_options.dart`

### 5.3 Verify Dependencies

Check `pubspec.yaml` includes:

```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
```

Run:
```bash
flutter pub get
```

---

## 🖼️ Step 6: Add Background Image Asset

1. Place your admin login background image at:
   ```
   assets/images/admin_login_bg.png
   ```

2. If the image doesn't exist, the app will show a fallback icon

---

## ✅ Step 7: Test the App

1. Run the app:
   ```bash
   flutter run
   ```

2. Test Admin Login:
   - Use phone number: `799999999` (without country code)
   - Use the password you set for the admin account

3. Test Forgot Password Flow:
   - Click "Forgot password?"
   - Enter phone number
   - Verify OTP
   - Set new password

---

## 🐛 Troubleshooting

### Phone Auth Not Working

- **Issue**: "Invalid phone number format"
  - **Solution**: Ensure phone number is formatted with country code (e.g., `+962799999999` for Jordan)

- **Issue**: "Quota exceeded"
  - **Solution**: Phone Auth on free tier has limited SMS. Upgrade to Blaze plan for production.

- **Issue**: "Verification failed"
  - **Solution**: 
    - Check SHA-1/SHA-256 are added to Firebase
    - Ensure `google-services.json` is in `android/app/`
    - Rebuild the app: `flutter clean && flutter pub get && flutter run`

### Login Not Working

- **Issue**: "User not found"
  - **Solution**: Ensure admin user exists in Firebase Console with email format: `phone@cancare.com`

- **Issue**: "Wrong password"
  - **Solution**: Verify password matches the one set in Firebase Console

### OTP Not Received

- **Issue**: SMS code not arriving
  - **Solution**: 
    - Check phone number format
    - Verify Firebase project has SMS quota
    - Check device has network connection
    - For testing, check Android logs for auto-verification

---

## 📝 Important Notes

1. **Phone Number Format**: 
   - In the app, users enter phone without `+` prefix
   - The code automatically formats to `+962XXXXXXXXX` (Jordan)
   - For other countries, modify `forgot_password_screen.dart` line ~75

2. **Email Format for Login**:
   - Phone numbers are converted to `phone@cancare.com` format
   - This allows using Email/Password auth with phone as identifier

3. **Production Considerations**:
   - Enable phone verification in production
   - Set up proper error handling
   - Consider rate limiting
   - Use secure password requirements
   - Enable app check for security

4. **Security**:
   - Never commit `google-services.json` with production keys to public repos
   - Use environment variables for sensitive data
   - Enable Firebase App Check

---

## 🔗 Additional Resources

- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Phone Auth Guide](https://firebase.google.com/docs/auth/flutter/phone-auth)

---

## ✅ Checklist

- [ ] Firebase project created
- [ ] Android app added to Firebase
- [ ] `google-services.json` downloaded and placed correctly
- [ ] SHA-1 and SHA-256 keys added to Firebase
- [ ] Phone Authentication enabled
- [ ] Email/Password Authentication enabled
- [ ] Admin user created in Firebase Console
- [ ] FlutterFire CLI configured (`flutterfire configure`)
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Background image added to `assets/images/`
- [ ] App tested on device/emulator

---

**Need Help?** Check the Firebase Console logs or Flutter debug console for detailed error messages.

