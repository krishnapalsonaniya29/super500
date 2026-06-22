import 'package:flutter/material.dart';

import '../../../../../services/mentor/mentor_service.dart';

import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/cards/dashboard_card.dart';

import '../../../../../widgets/loaders/app_loader.dart';

class MentorHomeScreen extends StatefulWidget {
  const MentorHomeScreen({super.key});

  @override
  State<MentorHomeScreen> createState() => _MentorHomeScreenState();
}

class _MentorHomeScreenState extends State<MentorHomeScreen> {
  bool isLoading = true;

  Map<String, dynamic>? dashboardData;

  @override
  void initState() {
    super.initState();

    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final response = await MentorService.getDashboard();

      if (!mounted) return;

      setState(() {
        dashboardData = response["data"];

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: AppLoader());
    }

    final recentReports = List<Map<String, dynamic>>.from(
      dashboardData?["recentReports"] ?? [],
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      body: RefreshIndicator(
        onRefresh: loadDashboard,

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/app_logo2.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mentor Dashboard",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Manage students, sessions and mentoring activities.",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// =================================
              /// STATS
              /// =================================
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: "Students",

                      value: "${dashboardData?["totalStudents"] ?? 0}",

                      icon: Icons.people,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: DashboardCard(
                      title: "Sessions",

                      value: "${dashboardData?["upcomingSessions"] ?? 0}",

                      icon: Icons.schedule,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              DashboardCard(
                title: "Completed Sessions",

                value: "${dashboardData?["completedSessions"] ?? 0}",

                icon: Icons.check_circle,
              ),

              const SizedBox(height: 24),

              /// =================================
              /// REPORTS
              /// =================================
              const Text(
                "Recent Reports",

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              if (recentReports.isEmpty)
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Center(child: Text("No reports available")),
                ),

              ...recentReports.map((report) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),

                  child: ListTile(
                    leading: const Icon(Icons.assignment),

                    title: Text(report["reportType"] ?? ""),

                    subtitle: Text(
                      report["content"] ?? "",

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
