import 'package:flutter/material.dart';

import '../../../../../services/mentor/mentor_service.dart';

import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/cards/dashboard_card.dart';

import '../../../../../widgets/loaders/app_loader.dart';

class MentorHomeScreen
    extends StatefulWidget {
  const MentorHomeScreen({
    super.key,
  });

  @override
  State<MentorHomeScreen>
      createState() =>
          _MentorHomeScreenState();
}

class _MentorHomeScreenState
    extends State<MentorHomeScreen> {
  bool isLoading = true;

  Map<String, dynamic>?
      dashboardData;

  @override
  void initState() {
    super.initState();

    loadDashboard();
  }

  Future<void>
      loadDashboard() async {
    try {
      final response =
          await MentorService
              .getDashboard();

      if (!mounted) return;

      setState(() {
        dashboardData =
            response["data"];

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: AppLoader(),
      );
    }

    final recentReports =
        List<Map<String, dynamic>>.from(
      dashboardData?["recentReports"] ??
          [],
    );

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        backgroundColor:
            AppColors.primary,

        elevation: 0,

        title: const Text(
          "Mentor Dashboard",
        ),
      ),

      body: RefreshIndicator(
        onRefresh: loadDashboard,

        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),

          padding:
              const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              /// =================================
              /// STATS
              /// =================================

              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title:
                          "Students",

                      value:
                          "${dashboardData?["totalStudents"] ?? 0}",

                      icon:
                          Icons.people,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: DashboardCard(
                      title:
                          "Sessions",

                      value:
                          "${dashboardData?["upcomingSessions"] ?? 0}",

                      icon:
                          Icons.schedule,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 16,
              ),

              DashboardCard(
                title:
                    "Completed Sessions",

                value:
                    "${dashboardData?["completedSessions"] ?? 0}",

                icon:
                    Icons.check_circle,
              ),

              const SizedBox(
                height: 24,
              ),

              /// =================================
              /// REPORTS
              /// =================================

              const Text(
                "Recent Reports",

                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              if (recentReports
                  .isEmpty)
                Container(
                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: const Center(
                    child: Text(
                      "No reports available",
                    ),
                  ),
                ),

              ...recentReports.map(
                (report) {
                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),

                    child: ListTile(
                      leading:
                          const Icon(
                        Icons.assignment,
                      ),

                      title: Text(
                        report["reportType"] ??
                            "",
                      ),

                      subtitle: Text(
                        report["content"] ??
                            "",

                        maxLines: 2,

                        overflow:
                            TextOverflow
                                .ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}