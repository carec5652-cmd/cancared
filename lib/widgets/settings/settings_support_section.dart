import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/locale_provider.dart';
import '../common/section_card.dart';
import '../common/action_tile.dart';

/// Help & Support section for settings screen
class SettingsSupportSection extends StatelessWidget {
  final VoidCallback? onTap;

  const SettingsSupportSection({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return SectionCard(
      title: localeProvider.isEnglish ? "Support" : "الدعم",
      child: ActionTile(
        icon: Icons.help_outline,
        title: localeProvider.isEnglish
            ? "Help & Support"
            : "المساعدة والدعم",
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap ?? () {
          // TODO: Navigate to help & support screen
        },
        margin: EdgeInsets.zero,
      ),
    );
  }
}
