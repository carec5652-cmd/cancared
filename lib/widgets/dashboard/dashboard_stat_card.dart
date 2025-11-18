import 'package:flutter/material.dart';

/// Single statistic card widget for dashboard
class DashboardStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final bool isEnglish;
  final VoidCallback? onViewTap;

  const DashboardStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    required this.isEnglish,
    this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: Theme.of(context).primaryColor),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "$count ${isEnglish ? "Total" : "إجمالي"}",
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed:
                  onViewTap ??
                  () {
                    // TODO: Navigate to detail screen
                  },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(0, 24),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                isEnglish ? "View" : "عرض",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
