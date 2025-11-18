import 'package:flutter/material.dart';

/// Welcome text widget for dashboard
class DashboardWelcomeText extends StatelessWidget {
  final String adminName;
  final bool isEnglish;

  const DashboardWelcomeText({
    super.key,
    required this.adminName,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      isEnglish
          ? "Welcome Back, Admin $adminName"
          : "مرحباً بعودتك، أدمن $adminName",
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xFF00A3FF),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
