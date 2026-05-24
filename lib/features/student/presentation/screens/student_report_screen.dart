// lib/features/student/presentation/screens/student_reports_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../theme/app_colors.dart';

import '../../../../services/student/student_service.dart';


class StudentReportsScreen
    extends StatefulWidget {
       final Function(int index)
      onNavigate;
  const StudentReportsScreen({
    super.key,
    required this.onNavigate,
  }); 

  @override
  State<StudentReportsScreen>
      createState() =>
          _StudentReportsScreenState();
}

class _StudentReportsScreenState
    extends State<StudentReportsScreen> {
  bool isLoading = true;

  List reports = [];

  @override
  void initState() {
    super.initState();

    loadReports();
  }

  /// =====================================
  /// LOAD REPORTS
  /// =====================================

  Future<void> loadReports() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response =
          await StudentService
              .getReports();

      reports =
          response["data"] ?? [];
    } catch (e) {
      debugPrint(
        "Reports Error: $e",
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,

        elevation: 0,

        title: const Text(
          "My Reports",

          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : reports.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh:
                      loadReports,

                  child: ListView.builder(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    itemCount:
                        reports.length,

                    itemBuilder:
                        (
                          context,
                          index,
                        ) {
                      final report =
                          reports[index];

                      return _buildReportCard(
                        report,
                      );
                    },
                  ),
                ),
    );
  }

  /// =====================================
  /// REPORT CARD
  /// =====================================

  Widget _buildReportCard(
    Map<String, dynamic>
        report,
  ) {
    final mentor =
        report["mentor"];

    final mentorUser =
        mentor?["user"];

    final createdAt =
        report["createdAt"];

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 18,
      ),

      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withValues(
              alpha: 0.05,
            ),

            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          /// HEADER
          Row(
            children: [
              CircleAvatar(
                radius: 24,

                backgroundColor:
                    AppColors.primary,

                child: Text(
                  mentorUser?["name"] !=
                          null
                      ? mentorUser["name"][0]
                          .toUpperCase()
                      : "M",

                  style:
                      const TextStyle(
                    color:
                        Colors.white,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      mentorUser?["name"] ??
                          "Mentor",

                      style:
                          const TextStyle(
                        fontSize: 17,

                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      createdAt != null
                          ? DateFormat(
                              "dd MMM yyyy",
                            ).format(
                              DateTime.parse(
                                createdAt,
                              ),
                            )
                          : "",

                      style: TextStyle(
                        color: Colors
                            .grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          /// TITLE
          Text(
            report["title"] ??
                "Progress Report",

            style: const TextStyle(
              fontSize: 20,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          /// ACADEMIC PERFORMANCE
          _buildSection(
            title:
                "Academic Performance",

            content:
                report[
                        "academicPerformance"] ??
                    "No academic feedback",
          ),

          const SizedBox(
            height: 14,
          ),

          /// BEHAVIOR
          _buildSection(
            title:
                "Behavior & Discipline",

            content:
                report[
                        "behaviorFeedback"] ??
                    "No behavior feedback",
          ),

          const SizedBox(
            height: 14,
          ),

          /// IMPROVEMENT
          _buildSection(
            title:
                "Improvement Suggestions",

            content:
                report[
                        "improvementAreas"] ??
                    "No suggestions",
          ),

          const SizedBox(
            height: 14,
          ),

          /// REMARKS
          _buildSection(
            title:
                "Mentor Remarks",

            content:
                report["remarks"] ??
                    "No remarks",
          ),
        ],
      ),
    );
  }

  /// =====================================
  /// SECTION
  /// =====================================

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: const TextStyle(
            fontSize: 15,

            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 6,
        ),

        Text(
          content,

          style: TextStyle(
            color:
                Colors.grey[800],

            height: 1.5,
          ),
        ),
      ],
    );
  }

  /// =====================================
  /// EMPTY STATE
  /// =====================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          30,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              Icons.description,
              size: 90,
              color: Colors.grey[400],
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              "No Reports Available",

              style: TextStyle(
                fontSize: 22,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              "Mentor reports and feedback will appear here.",

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                color:
                    Colors.grey[700],

                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}