import 'package:flutter/material.dart';
import '../../controllers/admin_dashboard_controller.dart';
import '../common/empty_state.dart';
import '../common/section_title.dart';

/// Recent activity section for dashboard
class DashboardRecentActivity extends StatelessWidget {
  final AdminDashboardController controller;
  final bool isEnglish;

  const DashboardRecentActivity({
    super.key,
    required this.controller,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(text: isEnglish ? "Recent Activity:" : "آخر النشاطات:"),
        const SizedBox(height: 16),
        if (controller.recentActivity.isEmpty)
          EmptyState(
            message: isEnglish ? "No recent activity" : "لا توجد نشاطات حديثة",
          )
        else
          ...controller.recentActivity.map(
            (activity) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      activity,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
