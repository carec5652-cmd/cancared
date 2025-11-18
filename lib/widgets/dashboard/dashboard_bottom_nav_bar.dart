import 'package:flutter/material.dart';
import '../../screens/admin/settings_screen.dart';

/// Bottom navigation bar for dashboard
class DashboardBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isEnglish;

  const DashboardBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index);

        // Navigation logic
        if (index == 0) {
          // Home – stay on same page (Dashboard)
        } else if (index == 1) {
          // Transportation page (TODO)
          /*
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransportationScreen(),
            ),
          );
          */
        } else if (index == 2) {
          // Requests page (TODO)
          /*
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RequestsScreen(),
            ),
          );
          */
        } else if (index == 3) {
          // Profile → Settings Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            ),
          );
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: isEnglish ? "Home" : "الرئيسية",
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.directions_car),
          label: isEnglish ? "Transportation" : "النقل",
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.request_quote),
          label: isEnglish ? "Requests" : "الطلبات",
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: isEnglish ? "Profile" : "الملف الشخصي",
        ),
      ],
    );
  }
}

