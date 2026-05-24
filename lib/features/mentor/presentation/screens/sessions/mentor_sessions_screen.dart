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
      if (!mounted) return;

      setState(() {
        isUpdating = false;
      });
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
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Mentor Sessions",
        ),

        elevation: 0,

        backgroundColor:
            AppColors.primary,
      ),

      body: RefreshIndicator(
        onRefresh: loadSessions,

        child: sessions.isEmpty
            ? ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                children: const [
                  SizedBox(
                    height: 250,
                  ),

                  Center(
                    child: Text(
                      "No sessions found",
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
                    sessions.length,

                itemBuilder:
                    (context, index) {
                  final session =
                      sessions[index];

                  final student =
                      session["student"] ??
                          {};

                  final user =
                      student["user"] ??
                          {};

                  final studentName =
                      user["fullName"] ??
                          "";

                  final status =
                      session["status"] ??
                          "SCHEDULED";

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
                            getStatusColor(
                          status,
                        ),

                        child: const Icon(
                          Icons.schedule,

                          color:
                              Colors.white,
                        ),
                      ),

                      title: Text(
                        session["title"] ??
                            "",
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
                            studentName,
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
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
                        ],
                      ),

                      trailing:
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

                        itemBuilder:
                            (_) => [
                          const PopupMenuItem(
                            value:
                                "complete",

                            child: Text(
                              "Mark Completed",
                            ),
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
                      const CreateSessionScreen(),
            ),
          );

          await loadSessions();
        },

        child: const Icon(
          Icons.add,

          color: Colors.black,
        ),
      ),
    );
  }
}