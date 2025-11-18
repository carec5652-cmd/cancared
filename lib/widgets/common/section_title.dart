import 'package:flutter/material.dart';

/// Reusable section title widget
class SectionTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const SectionTitle({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          style ??
          Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
