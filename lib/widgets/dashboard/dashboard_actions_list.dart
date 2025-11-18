import 'package:flutter/material.dart';
import '../common/action_tile.dart';

/// Vertical list of action items for dashboard
class DashboardActionsList extends StatelessWidget {
  final bool isEnglish;
  final Function(String action)? onActionTap;

  const DashboardActionsList({
    super.key,
    required this.isEnglish,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'icon': Icons.person_add,
        'title': isEnglish ? "Add Doctor" : "Ø¥Ø¶Ø§ÙØ© Ø·Ø¨ÙŠØ¨",
        'key': 'add_doctor',
      },
      {
        'icon': Icons.person_add_alt_1,
        'title': isEnglish ? "Add Patient" : "Ø¥Ø¶Ø§ÙØ© Ù…Ø±ÙŠØ¶",
        'key': 'add_patient',
      },
      {
        'icon': Icons.post_add,
        'title': isEnglish ? "New Post" : "Ù…Ù†Ø´ÙˆØ± Ø¬Ø¯ÙŠØ¯",
        'key': 'new_post',
      },
      {
        'icon': Icons.notifications_active,
        'title': isEnglish ? "New Notification" : "Ø¥Ø´Ø¹Ø§Ø± Ø¬Ø¯ÙŠØ¯",
        'key': 'new_notification',
      },
      {
        'icon': Icons.directions_car,
        'title': isEnglish ? "Transportation Requests" : "Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù†Ù‚Ù„",
        'key': 'transportation',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...actions.map(
          (action) => ActionTile(
            icon: action['icon'] as IconData,
            title: action['title'] as String,
            trailing: Text(
              isEnglish ? "View" : "Ø¹Ø±Ø¶",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
              ),
            ),
            onTap: () {
              if (onActionTap != null) {
                onActionTap!(action['key'] as String);
              }
              final String title = action['title'] as String;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(title: Text(title)),
                    body: Center(
                      child: Text(
                        'Coming soon',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
