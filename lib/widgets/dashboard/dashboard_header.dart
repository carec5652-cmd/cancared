import 'package:flutter/material.dart';

/// Dashboard header with avatar and notification icon
class DashboardHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;

  const DashboardHeader({super.key, this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Admin avatar on the left
        CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.person, color: Colors.white, size: 24),
        ),
        // Spacer to push icons to the right
        const Spacer(),
        // Notification icon
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined),
          onPressed:
              onNotificationTap ??
              () {
                /* TODO: Navigate to notification screen */
              },
        ),
      ],
    );
  }
}
