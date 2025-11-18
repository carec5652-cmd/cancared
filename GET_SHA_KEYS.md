# 🔑 كيفية الحصول على SHA-1 و SHA-256 للمشروع

## ⚡ الأوامر السريعة

### للحصول على SHA-1 و SHA-256 من Debug Keystore:

```bash
# Windows
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### للحصول على SHA من Gradle (أسهل طريقة):

```bash
cd android
./gradlew signingReport
```

أو في Windows:
```bash
cd android
gradlew signingReport
```

---

## 📝 خطوات تفعيل التحقق من التطبيق (App Verification)

### 1️⃣ تفعيل Blaze Plan (مطلوب لـ Phone Auth)

1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. اختر مشروعك: **cancare-312a8**
3. اذهب إلى **⚙️ Project Settings** → **Usage and billing**
4. اضغط **Upgrade to Blaze Plan**
   - ⚠️ **ملاحظة**: الخطة مجانية حتى 10,000 رسالة SMS شهرياً
   - لن يتم خصم أي مبلغ إلا عند تجاوز الحد المجاني

### 2️⃣ الحصول على SHA-1 و SHA-256

#### الطريقة الأولى: باستخدام keytool (Windows)

```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

#### الطريقة الثانية: باستخدام Gradle (الأسهل)

```bash
cd android
gradlew signingReport
```

ابحث في المخرجات عن:
- **SHA1:** `XX:XX:XX:...`
- **SHA256:** `XX:XX:XX:...`

### 3️⃣ إضافة SHA-1 و SHA-256 في Firebase Console

1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. اختر مشروعك: **cancare-312a8**
3. اذهب إلى **⚙️ Project Settings**
4. ابحث عن قسم **"Your apps"**
5. اضغط على تطبيق Android الخاص بك
6. في قسم **"SHA certificate fingerprints"**:
   - اضغط **"Add fingerprint"**
   - الصق **SHA-1** → **Save**
   - اضغط **"Add fingerprint"** مرة أخرى
   - الصق **SHA-256** → **Save**

### 4️⃣ التأكد من تفعيل Phone Authentication

1. في Firebase Console → **Authentication** → **Sign-in method**
2. اضغط على **"Phone"**
3. تأكد من تفعيل **"Enable"**
4. اضغط **Save**

---

## ✅ التحقق من الإعدادات

### Checklist:

- [ ] تم تفعيل Blaze Plan
- [ ] تم الحصول على SHA-1
- [ ] تم الحصول على SHA-256
- [ ] تم إضافة SHA-1 في Firebase Console
- [ ] تم إضافة SHA-256 في Firebase Console
- [ ] تم تفعيل Phone Authentication
- [ ] تم إعادة بناء التطبيق: `flutter clean && flutter run`

---

## 🔍 ملاحظات مهمة

### Play Integrity API (الإصدار 21.2.0+)
- **SHA-256 مطلوب** لـ Play Integrity API
- يعمل تلقائياً إذا كان الجهاز يحتوي على Google Play services
- لا يحتاج إعداد إضافي في الكود

### reCAPTCHA (Backup)
- **SHA-1 مطلوب** لـ reCAPTCHA
- يُستخدم عندما يكون Play Integrity غير متاح
- يعمل تلقائياً كبديل احتياطي

---

## 🐛 حل المشاكل

### الخطأ: `BILLING_NOT_ENABLED`
**الحل:** قم بتفعيل Blaze Plan من Firebase Console

### الخطأ: `Verification failed`
**الحل:** 
- تأكد من إضافة SHA-1 و SHA-256
- أعد بناء التطبيق: `flutter clean && flutter run`

### الكود لا يعمل
**الحل:**
1. تأكد من تفعيل Blaze Plan
2. أضف SHA-1 و SHA-256 في Firebase Console
3. أعد بناء التطبيق
4. تأكد من أن `google-services.json` موجود في `android/app/`

---

## 📱 اختبار Phone Auth

بعد إتمام الإعدادات:

1. شغّل التطبيق
2. اضغط "Forgot password?"
3. أدخل رقم الهاتف: `790261823`
4. اضغط "Send OTP"
5. يجب أن يصل رمز OTP (أو reCAPTCHA إذا لزم الأمر)

---

**ملاحظة:** بعد تفعيل Blaze Plan وإضافة SHA-1/SHA-256، يجب أن يعمل Phone Auth بشكل صحيح! 🎉

