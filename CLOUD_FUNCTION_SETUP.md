# 🔥 Cloud Function Setup Guide

## خطوات إعداد Cloud Function لتحديث كلمة المرور

### 1. تثبيت Firebase CLI (إذا لم يكن مثبتاً)

```bash
npm install -g firebase-tools
```

### 2. تسجيل الدخول إلى Firebase

```bash
firebase login
```

### 3. تثبيت Dependencies للـ Functions

```bash
cd functions
npm install
cd ..
```

### 4. نشر Cloud Function

```bash
firebase deploy --only functions
```

### 5. التحقق من النشر

بعد النشر، ستجد الـ Function في Firebase Console:
- اذهب إلى: Firebase Console → Functions
- ستجد `updatePasswordAfterOTP` function

## 📝 ملاحظات مهمة:

1. **Blaze Plan مطلوب**: Cloud Functions تتطلب Blaze Plan (الخطة المدفوعة)
2. **الأمان**: الـ Function يتحقق من أن المستخدم مسجل دخول (Phone Auth)
3. **التحقق**: بعد OTP verification، يمكن تحديث كلمة المرور مباشرة

## 🔧 كيفية العمل:

1. المستخدم يدخل رقم الهاتف ويرسل OTP
2. بعد التحقق من OTP، يدخل كلمة المرور الجديدة
3. التطبيق يستدعي Cloud Function `updatePasswordAfterOTP`
4. الـ Function يحدّث كلمة المرور مباشرة باستخدام Firebase Admin SDK

## ✅ بعد النشر:

- التطبيق سيعمل تلقائياً
- لا حاجة لتعديل الكود في Flutter
- كلمة المرور ستُحدّث مباشرة بعد OTP verification

