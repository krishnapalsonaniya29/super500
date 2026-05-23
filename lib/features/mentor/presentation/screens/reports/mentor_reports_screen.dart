import 'package:flutter/material.dart';

import '../../../../../services/mentor/mentor_service.dart';

import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/loaders/app_loader.dart';

import 'create_report_screen.dart';

class MentorReportsScreen
    extends StatefulWidget {
  const MentorReportsScreen({
    super.key,
  });

  @override
  State<MentorReportsScreen>
      createState() =>
          _MentorReportsScreenState();
}

class _MentorReportsScreenState
    extends State<
        MentorReportsScreen> {
  bool isLoading = true;

  List<Map<String, dynamic>>
      reports = [];

  @override
  void initState() {
    super.initState();

    loadReports();
  }

  Future<void>
      loadReports() async {
    try {
      final response =
          await MentorService
              .getReports();

      if (!mounted) return;

      setState(() {
        reports =
            List<Map<String, dynamic>>.from(
          response["reports"] ??
              [],
        );

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

  Color getReportColor(
    String type,
  ) {
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
      return const Center(
        child: AppLoader(),
      );
    }

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        backgroundColor:
            AppColors.primary,

        elevation: 0,

        title: const Text(
          "Mentor Reports",
        ),
      ),

      body: RefreshIndicator(
        onRefresh: loadReports,

        child: reports.isEmpty
            ? ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                children: const [
                  SizedBox(
                    height: 250,
                  ),

                  Center(
                    child: Text(
                      "No reports found",
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding:
                    const EdgeInsets.all(
                  16,
                ),

                itemCount:
                    reports.length,

                itemBuilder:
                    (context, index) {
                  final report =
                      reports[index];

                  final student =
                      report["student"] ??
                          {};

                  final user =
                      student["user"] ??
                          {};

                  final studentName =
                      user["fullName"] ??
                          "";

                  final reportType =
                      report["reportType"] ??
                          "";

                  final content =
                      report["content"] ??
                          "";

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 14,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),

                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.all(
                        14,
                      ),

                      leading:
                          CircleAvatar(
                        backgroundColor:
                            getReportColor(
                          reportType,
                        ),

                        child: const Icon(
                          Icons.assignment,

                          color:
                              Colors.white,
                        ),
                      ),

                      title: Text(
                        studentName,

                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      subtitle: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          const SizedBox(
                            height: 6,
                          ),

                          Text(
                            reportType,

                            style:
                                TextStyle(
                              color:
                                  getReportColor(
                                reportType,
                              ),

                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Text(
                            content,

                            maxLines: 3,

                            overflow:
                                TextOverflow
                                    .ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),

      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            AppColors.gold,

        onPressed: () async {
          await Navigator.push(
            context,

            MaterialPageRoute(
              builder:
                  (_) =>
                      const CreateReportScreen(),
            ),
          );

          await loadReports();
        },

        child: const Icon(
          Icons.add,

          color: Colors.black,
        ),
      ),
    );
  }
}