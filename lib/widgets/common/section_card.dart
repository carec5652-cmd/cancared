import 'package:flutter/material.dart';
import 'section_title.dart';

/// Reusable section wrapper with title and card content
/// Used for settings sections and similar grouped content
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final TextStyle? titleStyle;
  final double spacing;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.titleStyle,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(text: title, style: titleStyle),
        SizedBox(height: spacing),
        child,
      ],
    );
  }
}

