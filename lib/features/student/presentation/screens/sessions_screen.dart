import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/student/student_service.dart';
import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/loaders/app_loader.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({
    super.key,
    required void Function(int index)
        onNavigate,
  });

  @override
  State<SessionsScreen>
      createState() =>
          _SessionsScreenState();
}

class _SessionsScreenState
    extends State<SessionsScreen> {
  bool isLoading = true;

  String? errorMessage;

  List<Map<String, dynamic>>
      sessions = [];

  @override
  void initState() {
    super.initState();

    loadSessions();
  }

  Future<void>
      loadSessions() async {
    try {
      final response =
          await StudentService
              .getStudentSessions();

      if (!mounted) return;

      setState(() {
        sessions =
            List<Map<String, dynamic>>.from(
          response["sessions"] ??
              [],
        );

        isLoading = false;

        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;

        errorMessage =
            e.toString();
      });
    }
  }

  Future<void> joinMeeting(
    String link,
  ) async {
    try {
      final uri = Uri.parse(link);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }

  Color getStatusColor(
    String status,
  ) {
    switch (status) {
      case "COMPLETED":
        return Colors.green;

      case "CANCELLED":
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: AppLoader(),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor:
            AppColors.background,

        body: Center(
          child: Text(
            errorMessage!,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadSessions,

          child: Padding(
            padding:
                const EdgeInsets.all(
              20,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                const Text(
                  'Sessions',

                  style: TextStyle(
                    fontSize: 30,

                    fontWeight:
                        FontWeight.bold,

                    fontFamily:
                        'Poppins',

                    color: AppColors
                        .textPrimary,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                Expanded(
                  child:
                      sessions.isEmpty
                          ? ListView(
                              children: const [
                                SizedBox(
                                  height:
                                      250,
                                ),

                                Center(
                                  child:
                                      Text(
                                    "No sessions found",
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount:
                                  sessions
                                      .length,

                              itemBuilder:
                                  (
                                    context,
                                    index,
                                  ) {
                                    final session =
                                        sessions[index];

                                    final mentor =
                                        session["mentor"] ??
                                            {};

                                    final mentorUser =
                                        mentor["user"] ??
                                            {};

                                    final reports =
                                        List<Map<String, dynamic>>.from(
                                      session["reports"] ??
                                          [],
                                    );

                                    final mentorName =
                                        mentorUser["fullName"] ??
                                            "Mentor";

                                    final title =
                                        session["title"] ??
                                            "";

                                    final description =
                                        session["description"] ??
                                            "";

                                    final status =
                                        session["status"] ??
                                            "";

                                    final meetingLink =
                                        session["meetingLink"];

                                    final scheduledAt =
                                        session["scheduledAt"] ??
                                            "";

                                    return Container(
                                      margin:
                                          const EdgeInsets.only(
                                        bottom:
                                            20,
                                      ),

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
                                          24,
                                        ),

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha:
                                                  0.05,
                                            ),

                                            blurRadius:
                                                10,

                                            offset:
                                                const Offset(
                                              0,
                                              4,
                                            ),
                                          ),
                                        ],
                                      ),

                                      child:
                                          Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(
                                                  16,
                                                ),

                                                decoration:
                                                    BoxDecoration(
                                                  color: AppColors.primary.withValues(
                                                    alpha:
                                                        0.1,
                                                  ),

                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    18,
                                                  ),
                                                ),

                                                child:
                                                    const Icon(
                                                  Icons.video_camera_front_rounded,

                                                  color:
                                                      AppColors.primary,

                                                  size:
                                                      32,
                                                ),
                                              ),

                                              const SizedBox(
                                                width:
                                                    16,
                                              ),

                                              Expanded(
                                                child:
                                                    Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,

                                                  children: [
                                                    Text(
                                                      title,

                                                      style:
                                                          const TextStyle(
                                                        fontSize:
                                                            18,

                                                        fontWeight:
                                                            FontWeight.w600,

                                                        fontFamily:
                                                            'Poppins',
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height:
                                                          6,
                                                    ),

                                                    Text(
                                                      mentorName,

                                                      style:
                                                          const TextStyle(
                                                        color:
                                                            AppColors.textSecondary,

                                                        fontFamily:
                                                            'Poppins',
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height:
                                                          4,
                                                    ),

                                                    Text(
                                                      scheduledAt.toString(),

                                                      style:
                                                          const TextStyle(
                                                        color:
                                                            AppColors.textSecondary,

                                                        fontFamily:
                                                            'Poppins',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              if (meetingLink !=
                                                      null &&
                                                  meetingLink
                                                      .toString()
                                                      .isNotEmpty)
                                                InkWell(
                                                  onTap:
                                                      () =>
                                                          joinMeeting(
                                                    meetingLink,
                                                  ),

                                                  child:
                                                      Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                      horizontal:
                                                          16,

                                                      vertical:
                                                          10,
                                                    ),

                                                    decoration:
                                                        BoxDecoration(
                                                      color:
                                                          const Color(
                                                        0xFFD4AF37,
                                                      ),

                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        14,
                                                      ),
                                                    ),

                                                    child:
                                                        const Text(
                                                      'Join',

                                                      style:
                                                          TextStyle(
                                                        color:
                                                            Colors.white,

                                                        fontWeight:
                                                            FontWeight.w600,

                                                        fontFamily:
                                                            'Poppins',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),

                                          if (description
                                              .isNotEmpty) ...[
                                            const SizedBox(
                                              height:
                                                  14,
                                            ),

                                            Text(
                                              description,
                                            ),
                                          ],

                                          const SizedBox(
                                            height:
                                                14,
                                          ),

                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal:
                                                  12,

                                              vertical:
                                                  6,
                                            ),

                                            decoration:
                                                BoxDecoration(
                                              color:
                                                  getStatusColor(
                                                status,
                                              ),

                                              borderRadius:
                                                  BorderRadius.circular(
                                                12,
                                              ),
                                            ),

                                            child:
                                                Text(
                                              status,

                                              style:
                                                  const TextStyle(
                                                color:
                                                    Colors.white,

                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          if (reports
                                              .isNotEmpty) ...[
                                            const SizedBox(
                                              height:
                                                  20,
                                            ),

                                            const Text(
                                              "Mentor Reports",

                                              style:
                                                  TextStyle(
                                                fontWeight:
                                                    FontWeight.bold,

                                                fontSize:
                                                    16,
                                              ),
                                            ),

                                            const SizedBox(
                                              height:
                                                  10,
                                            ),

                                            ...reports.map(
                                              (
                                                report,
                                              ) {
                                                return Container(
                                                  margin:
                                                      const EdgeInsets.only(
                                                    bottom:
                                                        10,
                                                  ),

                                                  padding:
                                                      const EdgeInsets.all(
                                                    12,
                                                  ),

                                                  decoration:
                                                      BoxDecoration(
                                                    color:
                                                        Colors.grey.shade100,

                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      12,
                                                    ),
                                                  ),

                                                  child:
                                                      Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,

                                                    children: [
                                                      Text(
                                                        report["reportType"] ??
                                                            "",

                                                        style:
                                                            const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                        height:
                                                            6,
                                                      ),

                                                      Text(
                                                        report["content"] ??
                                                            "",
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}