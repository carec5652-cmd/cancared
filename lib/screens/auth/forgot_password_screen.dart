import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/phone_text_field.dart';

/// Forgot Password Screen with 3-step flow:
/// Step 1: Enter phone number and send OTP
/// Step 2: Verify OTP code
/// Step 3: Set new password
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _currentStep = 1; // 1: Phone, 2: OTP, 3: New Password

  // Step 1 Controllers
  final _phoneFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  // Step 2 Controllers
  final _otpFormKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  // Step 3 Controllers
  final _passwordFormKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Firebase Auth
  String? _verificationId;
  PhoneAuthCredential?
  _phoneCredential; // Store phone credential for password update
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Step 1: Send OTP to phone number
  Future<void> _sendOTP() async {
    if (!_phoneFormKey.currentState!.validate()) {
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final phoneNumber = _phoneController.text.trim();
      // Format phone number with country code (Jordan: 00962 or +962 for Firebase)
      String formattedPhone = phoneNumber;

      // Remove any spaces or dashes
      formattedPhone = formattedPhone.replaceAll(' ', '').replaceAll('-', '');

      // Convert to Firebase format (+962) if needed
      if (formattedPhone.startsWith('00962')) {
        // Convert 00962 to +962 for Firebase
        formattedPhone = formattedPhone.replaceFirst('00962', '+962');
      } else if (formattedPhone.startsWith('+962')) {
        // Already in Firebase format
        formattedPhone = formattedPhone;
      } else if (formattedPhone.startsWith('0')) {
        // Starts with 0, replace with +962
        formattedPhone = '+962${formattedPhone.substring(1)}';
      } else if (!formattedPhone.startsWith('+')) {
        // Add +962 if not present
        formattedPhone = '+962$formattedPhone';
      }

      // Show loading message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sending OTP code... Please wait (this may take up to 60 seconds).',
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.blue,
          ),
        );
      }

      // Verify phone number and send OTP
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed (Android only, when SMS code is detected)
          // Sign in with credential
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Auto-verification successful!'),
                backgroundColor: Colors.green,
              ),
            );
          }
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
          });

          String errorMessage = 'Failed to send OTP. Please try again.';
          String errorCode = e.code;
          String? errorMessageText = e.message?.toLowerCase();
          String fullErrorString = e.toString().toLowerCase();

          // Check for device blocking (error code 17010 or message contains "blocked")
          // Note: Error 17010 may appear in logs but not always in e.code
          if (errorCode == '17010' ||
              errorCode.contains('17010') ||
              (errorMessageText != null &&
                  (errorMessageText.contains('blocked') ||
                      errorMessageText.contains('unusual activity') ||
                      errorMessageText.contains('17010'))) ||
              fullErrorString.contains('17010') ||
              fullErrorString.contains('blocked') ||
              fullErrorString.contains('unusual activity')) {
            errorMessage =
                '⚠️ Device Blocked\n\n'
                'Firebase has temporarily blocked this device due to unusual activity.\n\n'
                'Please try again in 30-60 minutes.\n\n'
                'If the problem persists:\n'
                '• Wait 24 hours for automatic unblock\n'
                '• Try from a different device\n'
                '• Contact support if urgent';
          } else {
            switch (errorCode) {
              case 'invalid-phone-number':
                errorMessage =
                    'Invalid phone number format. Please check and try again.';
                break;
              case 'too-many-requests':
                errorMessage =
                    'Too many requests for this phone number.\nPlease wait 2-3 minutes or use a different phone number for testing.';
                break;
              case 'quota-exceeded':
                errorMessage =
                    'SMS quota exceeded. Please try again later or contact support.';
                break;
              case 'billing-not-enabled':
                errorMessage =
                    'Phone authentication requires Blaze Plan.\nPlease upgrade your Firebase plan in Firebase Console.';
                break;
              case 'app-not-authorized':
              case 'invalid-app-credential':
                errorMessage =
                    'App not authorized.\nPlease verify SHA-1 and SHA-256 are added in Firebase Console under Project Settings → Your apps.';
                break;
              case 'network-request-failed':
                errorMessage =
                    'Network error. Please check your internet connection and try again.';
                break;
              default:
                errorMessage =
                    '${e.message ?? errorCode}\n\nCommon fixes:\n1. Enable Blaze Plan\n2. Add SHA-1 & SHA-256\n3. Check internet connection';
            }
          }

          if (mounted) {
            // Longer duration for device blocking error
            final duration =
                errorMessage.contains('Device Blocked')
                    ? const Duration(seconds: 10)
                    : const Duration(seconds: 6);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: duration,
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            );
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          // OTP code sent successfully
          setState(() {
            _verificationId = verificationId;
            _isLoading = false;
            _currentStep = 2; // Move to OTP verification step
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '✅ OTP code sent to $formattedPhone\nPlease check your SMS messages.',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout
          _verificationId = verificationId;
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('⏱️ Timeout: Please enter OTP code manually'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        timeout: const Duration(seconds: 120), // Increased timeout to 2 minutes
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Sign in with phone credential (used after OTP verification)
  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        setState(() {
          _isLoading = false;
          _currentStep = 3; // Move to password update step
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'Verification failed. Please try again.';

      switch (e.code) {
        case 'invalid-credential':
          errorMessage =
              'The supplied auth credential is incorrect, malformed or has expired.\nPlease request a new OTP code.';
          // Reset to step 1
          setState(() {
            _currentStep = 1;
            _verificationId = null;
            _otpController.clear();
          });
          break;
        case 'invalid-verification-code':
          errorMessage = 'Invalid OTP code. Please check and try again.';
          break;
        case 'invalid-verification-id':
          errorMessage = 'Verification expired. Please request a new OTP code.';
          setState(() {
            _currentStep = 1;
            _verificationId = null;
            _otpController.clear();
          });
          break;
        case 'session-expired':
          errorMessage = 'Session expired. Please request a new OTP code.';
          setState(() {
            _currentStep = 1;
            _verificationId = null;
            _otpController.clear();
          });
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        default:
          errorMessage = e.message ?? 'Verification failed: ${e.code}';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  /// Step 2: Verify OTP code
  Future<void> _verifyOTP() async {
    if (!_otpFormKey.currentState!.validate()) {
      return;
    }

    if (_verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification ID not found. Please send OTP again.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _currentStep = 1;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final smsCode = _otpController.text.trim();

      // Create PhoneAuthCredential with verification ID and SMS code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      // Save credential for password update
      _phoneCredential = credential;

      // Sign in with credential
      await _signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'Invalid OTP code. Please try again.';

      switch (e.code) {
        case 'invalid-verification-code':
          errorMessage = 'Invalid OTP code. Please check and try again.';
          break;
        case 'invalid-verification-id':
          errorMessage = 'Verification expired. Please request a new OTP code.';
          setState(() {
            _currentStep = 1; // Go back to phone input
            _verificationId = null;
            _otpController.clear();
          });
          break;
        case 'session-expired':
          errorMessage = 'Session expired. Please request a new OTP code.';
          setState(() {
            _currentStep = 1;
            _verificationId = null;
            _otpController.clear();
          });
          break;
        case 'credential-already-in-use':
          errorMessage =
              'This phone number is already registered. Please use a different number.';
          break;
        default:
          errorMessage = e.message ?? 'Invalid credential. Please try again.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Step 3: Update password
  /// After OTP verification, update/create Email/Password user directly
  Future<void> _updatePassword() async {
    if (!_passwordFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newPassword = _newPasswordController.text.trim();
      final phoneNumber = _phoneController.text.trim();

      // Format email: phone@cancare.com
      final email = '$phoneNumber@cancare.com';

      // Get current user (Phone Auth user)
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null || _phoneCredential == null) {
        throw Exception('User not authenticated or credential missing');
      }

      // Try to link Phone Auth with Email/Password
      // First, try to create Email/Password account
      try {
        // Try to create Email/Password user
        final emailCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: email,
              password: newPassword,
            );

        // User created successfully - password is already set
        if (emailCredential.user != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Account created and password set successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }

        // Sign out after password update
        await FirebaseAuth.instance.signOut();

        if (mounted) {
          Navigator.of(context).pop(true);
        }
        return;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // User already exists - use Cloud Functions to update password
          // Get ID token from Phone Auth user for authentication
          await FirebaseAuth.instance.signOut();

          // Sign in with Phone Auth again to get ID token
          final phoneUserCredential = await FirebaseAuth.instance
              .signInWithCredential(_phoneCredential!);

          if (phoneUserCredential.user != null) {
            try {
              // Get ID token for Cloud Functions authentication
              final idToken = await phoneUserCredential.user!.getIdToken();

              // Call Cloud Function to update password
              final functions = FirebaseFunctions.instance;
              final callable = functions.httpsCallable(
                'updatePasswordAfterOTP',
              );

              final result = await callable.call({
                'email': email,
                'newPassword': newPassword,
                'idToken': idToken,
              });

              // Check if password was updated successfully
              if (result.data['success'] == true) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Password updated successfully!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }

                // Sign out
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.of(context).pop(true);
                }
                return;
              } else {
                throw Exception(
                  result.data['error'] ?? 'Failed to update password',
                );
              }
            } catch (functionError) {
              // If Cloud Function fails, try alternative method
              // Delete old user and create new one (if possible)
              try {
                // Alternative: Try to delete and recreate
                // This requires Admin SDK, so we'll show an error
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '⚠️ Error updating password: ${functionError.toString()}\n'
                        'Please contact admin or try again later.',
                      ),
                      backgroundColor: Colors.orange,
                      duration: const Duration(seconds: 6),
                    ),
                  );
                }
              } catch (altError) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${altError.toString()}'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 5),
                    ),
                  );
                }
              }

              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.of(context).pop(false);
              }
              return;
            }
          }
        } else {
          rethrow;
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'Failed to update password. Please try again.';
      switch (e.code) {
        case 'requires-recent-login':
          errorMessage =
              'This operation requires recent authentication. Please sign in again.';
          break;
        case 'weak-password':
          errorMessage =
              'Password is too weak. Please choose a stronger password.';
          break;
        case 'email-already-in-use':
          errorMessage =
              'This phone number is already registered. Please contact admin to reset password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid phone number format.';
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Enable keyboard to push content up
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior
                  .onDrag, // Dismiss keyboard on scroll
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Indicator
              Row(
                children: [
                  _buildStepIndicator(1, 'Phone', _currentStep >= 1),
                  _buildStepLine(_currentStep > 1),
                  _buildStepIndicator(2, 'OTP', _currentStep >= 2),
                  _buildStepLine(_currentStep > 2),
                  _buildStepIndicator(3, 'Password', _currentStep >= 3),
                ],
              ),
              const SizedBox(height: 32),

              // Step 1: Enter Phone Number
              if (_currentStep == 1) _buildStep1(),

              // Step 2: Enter OTP
              if (_currentStep == 2) _buildStep2(),

              // Step 3: Set New Password
              if (_currentStep == 3) _buildStep3(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isActive ? Theme.of(context).primaryColor : Colors.grey[300],
            ),
            child: Center(
              child: Text(
                '$step',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
                  isActive ? Theme.of(context).primaryColor : Colors.grey[600],
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: isActive ? Theme.of(context).primaryColor : Colors.grey[300],
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _phoneFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Phone Number',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'We will send an OTP code to verify your phone number',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          PhoneTextField(
            controller: _phoneController,
            hintText: '00962 7X XXX XXXX',
            labelText: 'Phone Number',
            autofocus: true, // Auto focus to show keyboard immediately
          ),
          const SizedBox(height: 16),
          // Info message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'OTP will be sent via SMS. This may take 30-60 seconds.',
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Send OTP',
            onPressed: _isLoading ? null : _sendOTP,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _otpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verify OTP Code',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the 6-digit code sent to ${_phoneController.text}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _otpController,
            autofocus: true, // Auto focus to show keyboard immediately
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
            decoration: InputDecoration(
              labelText: 'OTP Code',
              hintText: '000000',
              prefixIcon: const Icon(Icons.lock_clock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
              counterText: '',
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter OTP code';
              }
              if (value.length != 6) {
                return 'OTP code must be 6 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Verify OTP',
            onPressed: _verifyOTP,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed:
                _isLoading
                    ? null
                    : () {
                      setState(() {
                        _currentStep = 1;
                        _otpController.clear();
                      });
                    },
            child: const Text('Change phone number'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Form(
      key: _passwordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set New Password',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your new password. Make sure it\'s at least 6 characters.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _newPasswordController,
            autofocus: true, // Auto focus to show keyboard immediately
            obscureText: _obscureNewPassword,
            decoration: InputDecoration(
              labelText: 'New Password',
              hintText: 'Enter new password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter new password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Confirm new password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm password';
              }
              if (value != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Update Password',
            onPressed: _updatePassword,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
