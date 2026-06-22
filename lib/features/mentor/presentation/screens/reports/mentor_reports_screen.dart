import 'package:flutter/material.dart';

import '../../../../../services/mentor/mentor_service.dart';

import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/loaders/app_loader.dart';

import 'create_report_screen.dart';

class MentorReportsScreen extends StatefulWidget {
  const MentorReportsScreen({super.key});

  @override
  State<MentorReportsScreen> createState() => _MentorReportsScreenState();
}

class _MentorReportsScreenState extends State<MentorReportsScreen> {
  bool isLoading = true;

  List<Map<String, dynamic>> reports = [];

  @override
  void initState() {
    super.initState();

    loadReports();
  }

  Future<void> loadReports() async {
    try {
      final response = await MentorService.getReports();

      if (!mounted) return;

      setState(() {
        reports = List<Map<String, dynamic>>.from(response["reports"] ?? []);

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

  Color getReportColor(String type) {
    switch (type) {
      case "MONTHLY":
        return Colors.blue;

      case "QUARTERLY":
        return Colors.orange;

      case "PERFORMANCE":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: AppLoader());
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      body: RefreshIndicator(
        onRefresh: loadReports,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// HEADER
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

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mentor Reports",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Create and monitor student reports.",
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// EMPTY STATE
            if (reports.isEmpty)
              Column(
                children: [
                  const SizedBox(height: 80),

                  Icon(
                    Icons.assignment_outlined,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "No reports found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Create a report using the + button.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

            /// REPORT CARDS
            ...reports.map((report) {
              final student = report["student"] ?? {};

              final user = student["user"] ?? {};

              final studentName = user["fullName"] ?? "";

              final reportType = report["reportType"] ?? "";

              final content = report["content"] ?? "";

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: getReportColor(
                        reportType,
                      ).withValues(alpha: 0.15),
                      child: Icon(
                        Icons.assignment,
                        color: getReportColor(reportType),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            studentName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: getReportColor(
                                reportType,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              reportType,
                              style: TextStyle(
                                color: getReportColor(reportType),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            content,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.gold,

        onPressed: () async {
          await Navigator.push(
            context,

            MaterialPageRoute(builder: (_) => const CreateReportScreen()),
          );

          await loadReports();
        },

        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
