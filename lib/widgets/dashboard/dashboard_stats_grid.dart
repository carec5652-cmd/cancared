import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../controllers/admin_dashboard_controller.dart';
import 'dashboard_stat_card.dart';

/// Grid of 4 statistic cards for dashboard
class DashboardStatsGrid extends StatelessWidget {
  final AdminDashboardController controller;

  const DashboardStatsGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        DashboardStatCard(
          icon: Icons.medical_services,
          title: localeProvider.isEnglish ? "Doctor" : "الأطباء",
          count: controller.doctorsCount,
          isEnglish: localeProvider.isEnglish,
        ),
        DashboardStatCard(
          icon: Icons.local_hospital,
          title: localeProvider.isEnglish ? "Nurse" : "الممرضون",
          count: controller.nursesCount,
          isEnglish: localeProvider.isEnglish,
        ),
        DashboardStatCard(
          icon: Icons.people,
          title: localeProvider.isEnglish ? "Patient" : "المرضى",
          count: controller.patientsCount,
          isEnglish: localeProvider.isEnglish,
        ),
        DashboardStatCard(
          icon: Icons.article,
          title: localeProvider.isEnglish ? "Posts" : "المنشورات",
          count: controller.postsCount,
          isEnglish: localeProvider.isEnglish,
        ),
      ],
    );
  }
}
