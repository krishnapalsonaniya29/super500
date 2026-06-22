import 'package:flutter/material.dart';

import '../../../../../services/mentor/mentor_service.dart';

import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/loaders/app_loader.dart';

import 'create_session_screen.dart';

class MentorSessionsScreen
    extends StatefulWidget {
  const MentorSessionsScreen({
    super.key,
  });

  @override
  State<MentorSessionsScreen>
      createState() =>
          _MentorSessionsScreenState();
}

class _MentorSessionsScreenState
    extends State<
        MentorSessionsScreen> {
  bool isLoading = true;

  bool isUpdating = false;

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
          await MentorService
              .getSessions();

      if (!mounted) return;

      setState(() {
        sessions =
            List<Map<String, dynamic>>.from(
          response["sessions"] ??
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

  Future<void>
      markCompleted(
    String sessionId,
  ) async {
    try {
      setState(() {
        isUpdating = true;
      });

      await MentorService
          .updateSession(
        sessionId: sessionId,

        status: "COMPLETED",
      );

      await loadSessions();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Session updated",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {

      setState(() {
        isUpdating = false;
      });
      }
    }
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
    return const Center(
      child: AppLoader(),
    );
  }

  return Scaffold(
    backgroundColor: AppColors.background,

    body: RefreshIndicator(
      onRefresh: loadSessions,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(
              bottom: 20,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius:
                  BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary
                      .withValues(alpha:0.25),
                  blurRadius: 12,
                  offset:
                      const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  padding:
                      const EdgeInsets.all(8),
                  decoration:
                      BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius
                            .circular(
                      16,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius
                            .circular(
                      12,
                    ),
                    child: Image.asset(
                      "assets/images/app_logo2.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 16,
                ),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        "Mentor Sessions",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight
                                  .bold,
                          color:
                              Colors.white,
                        ),
                      ),

                      SizedBox(
                        height: 4,
                      ),

                      Text(
                        "Manage and track mentoring sessions.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors
                              .white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// EMPTY STATE
          if (sessions.isEmpty)
            Column(
              children: [
                const SizedBox(
                  height: 80,
                ),

                Icon(
                  Icons
                      .schedule_outlined,
                  size: 70,
                  color: Colors
                      .grey.shade400,
                ),

                const SizedBox(
                  height: 16,
                ),

                const Text(
                  "No sessions found",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  "Create a mentoring session using the + button.",
                  textAlign:
                      TextAlign.center,
                ),
              ],
            ),

          /// SESSION CARDS
          ...sessions.map(
            (session) {
              final student =
                  session["student"] ??
                      {};

              final user =
                  student["user"] ?? {};

              final studentName =
                  user["fullName"] ?? "";

              final status =
                  session["status"] ??
                      "SCHEDULED";

              return Container(
                margin:
                    const EdgeInsets.only(
                  bottom: 16,
                ),
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                decoration:
                    BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius
                          .circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors
                          .black
                          .withValues(alpha:
                        0.04,
                      ),
                      blurRadius: 8,
                      offset:
                          const Offset(
                        0,
                        4,
                      ),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor:
                          getStatusColor(
                            status,
                          ).withValues(alpha:
                            0.15,
                          ),
                      child: Icon(
                        Icons.schedule,
                        color:
                            getStatusColor(
                          status,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 16,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            session["title"] ??
                                "",
                            style:
                                const TextStyle(
                              fontSize:
                                  16,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            studentName,
                            style:
                                const TextStyle(
                              color:
                                  AppColors
                                      .textSecondary,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  10,
                              vertical: 4,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  getStatusColor(
                                status,
                              ).withValues(alpha:
                                0.12,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                            ),
                            child: Text(
                              status,
                              style:
                                  TextStyle(
                                color:
                                    getStatusColor(
                                  status,
                                ),
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    PopupMenuButton(
                      enabled:
                          !isUpdating,
                      onSelected:
                          (value) async {
                        if (value ==
                            "complete") {
                          await markCompleted(
                            session["id"],
                          );
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value:
                              "complete",
                          child: Text(
                            "Mark Completed",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ),

    floatingActionButton:
        FloatingActionButton(
      backgroundColor:
          AppColors.primary,
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const CreateSessionScreen(),
          ),
        );

        await loadSessions();
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    ),
  );
}
}