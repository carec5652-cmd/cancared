import 'package:flutter/material.dart';

/// Reusable action tile widget (Card + ListTile)
/// Used for settings items, dashboard actions, and similar list items
class ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;
  final EdgeInsets? margin;

  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.titleColor,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: titleColor != null
              ? TextStyle(color: titleColor)
              : null,
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

