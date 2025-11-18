const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

/**
 * Cloud Function to update password after OTP verification
 * This function is called from the Flutter app after OTP verification
 * 
 * @param {string} email - The email (phone@cancare.com format)
 * @param {string} newPassword - The new password to set
 * @param {string} idToken - The ID token from Phone Auth user
 */
exports.updatePasswordAfterOTP = functions.https.onCall(async (data, context) => {
  // Verify that the request is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'The function must be called while authenticated.'
    );
  }

  const { email, newPassword } = data;

  // Validate input
  if (!email || !newPassword) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Email and newPassword are required.'
    );
  }

  // Validate password length
  if (newPassword.length < 6) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Password must be at least 6 characters.'
    );
  }

  try {
    // Get the user by email
    const userRecord = await admin.auth().getUserByEmail(email);

    // Update the password using Admin SDK
    await admin.auth().updateUser(userRecord.uid, {
      password: newPassword
    });

    return {
      success: true,
      message: 'Password updated successfully'
    };
  } catch (error) {
    // If user doesn't exist, create new user
    if (error.code === 'auth/user-not-found') {
      try {
        await admin.auth().createUser({
          email: email,
          password: newPassword,
          emailVerified: false
        });

        return {
          success: true,
          message: 'User created and password set successfully'
        };
      } catch (createError) {
        throw new functions.https.HttpsError(
          'internal',
          `Failed to create user: ${createError.message}`
        );
      }
    } else {
      throw new functions.https.HttpsError(
        'internal',
        `Failed to update password: ${error.message}`
      );
    }
  }
});

