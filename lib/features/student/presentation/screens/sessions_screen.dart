// // lib/features/student/presentation/screens/sessions_screen.dart

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../../../../services/student/student_service.dart';
// import '../../../../../theme/app_colors.dart';

// class SessionsScreen extends StatefulWidget {
//   final Function(int index) onNavigate;

//   const SessionsScreen({
//     super.key,
//     required this.onNavigate,
//   });

//   @override
//   State<SessionsScreen> createState() =>
//       _SessionsScreenState();
// }

// class _SessionsScreenState
//     extends State<SessionsScreen> {
//   bool isLoading = true;

//   List<Map<String, dynamic>>
//       sessions = [];

//   @override
//   void initState() {
//     super.initState();

//     loadSessions();
//   }

//   /// =====================================
//   /// LOAD STUDENT SESSIONS
//   /// =====================================

//  Future<void> loadSessions() async {
//   try {
//     setState(() {
//       isLoading = true;
//     });

//     final response =
//         await StudentService
//             .getStudentSessions();

//     debugPrint(
//       "Sessions Response: $response",
//     );

//     if (!mounted) return;

//     setState(() {
//       sessions =
//           List<Map<String, dynamic>>.from(
//         response,
//       );
//     });
//   } catch (e) {
//     debugPrint(
//       "Session Error: $e",
//     );

//     if (!mounted) return;

//     ScaffoldMessenger.of(context)
//         .showSnackBar(
//       SnackBar(
//         content: Text(
//           e.toString(),
//         ),
//       ),
//     );
//   } finally {
//     if (!mounted) return;

//     setState(() {
//       isLoading = false;
//     });
//   }
// }

//   /// =====================================
//   /// STATUS COLOR
//   /// =====================================

//   Color getStatusColor(
//     String status,
//   ) {
//     switch (status) {
//       case "COMPLETED":
//         return Colors.green;

//       case "CANCELLED":
//         return Colors.red;

//       case "MISSED":
//         return Colors.redAccent;

//       default:
//         return Colors.orange;
//     }
//   }

//   /// =====================================
//   /// FORMAT DATE
//   /// =====================================

//   String formatDate(
//     String? value,
//   ) {
//     if (value == null) {
//       return "N/A";
//     }

//     try {
//       return DateFormat(
//         "dd MMM yyyy",
//       ).format(
//         DateTime.parse(value),
//       );
//     } catch (e) {
//       return value;
//     }
//   }

//   /// =====================================
//   /// FORMAT TIME
//   /// =====================================

//   String formatTime(
//     String? value,
//   ) {
//     if (value == null) {
//       return "N/A";
//     }

//     try {
//       return DateFormat(
//         "hh:mm a",
//       ).format(
//         DateTime.parse(value),
//       );
//     } catch (e) {
//       return value;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:
//           AppColors.background,

//       appBar: AppBar(
//         elevation: 0,

//         backgroundColor:
//             AppColors.primary,

//         title: const Text(
//           "Mentorship Sessions",
//         ),
//       ),

//       body: RefreshIndicator(
//         onRefresh: loadSessions,

//         child: isLoading
//             ? const Center(
//                 child:
//                     CircularProgressIndicator(),
//               )
//             : sessions.isEmpty
//                 ? ListView(
//                     physics:
//                         const AlwaysScrollableScrollPhysics(),

//                     children: const [
//                       SizedBox(
//                         height: 250,
//                       ),

//                       Center(
//                         child: Text(
//                           "No sessions found",
//                         ),
//                       ),
//                     ],
//                   )
//                 : ListView.builder(
//                     padding:
//                         const EdgeInsets.all(
//                       16,
//                     ),

//                     itemCount:
//                         sessions.length,

//                     itemBuilder:
//                         (context, index) {
//                       final session =
//                           sessions[index];

//                       /// =====================================
//                       /// MENTOR
//                       /// =====================================

//                       final mentor =
//                           session["mentor"] != null
//                               ? Map<String, dynamic>.from(
//                                   session["mentor"],
//                                 )
//                               : {};

//                       final mentorUser =
//                           mentor["user"] != null
//                               ? Map<String, dynamic>.from(
//                                   mentor["user"],
//                                 )
//                               : {};

//                       final mentorName =
//                           mentorUser[
//                                   "fullName"] ??
//                               "Mentor";

//                       final mentorPhone =
//                           mentorUser[
//                                   "phone"] ??
//                               "";

//                       final mentorEmail =
//                           mentorUser[
//                                   "email"] ??
//                               "";

//                       final mentorAvatar =
//                           mentorUser[
//                                   "avatar"];

//                       final specialization =
//                           mentor[
//                                   "specialization"] ??
//                               "N/A";

//                       final mentorDistrict =
//                           mentor[
//                                   "district"] ??
//                               "";

//                       /// =====================================
//                       /// SESSION
//                       /// =====================================

//                       final title =
//                           session["title"] ??
//                               "Mentorship Session";

//                       final description =
//                           session[
//                                   "description"] ??
//                               "";

//                       final meetingLink =
//                           session[
//                                   "meetingLink"] ??
//                               "";

//                       final status =
//                           session["status"] ??
//                               "SCHEDULED";

//                       final scheduledAt =
//                           session[
//                                   "scheduledAt"];

//                       final createdAt =
//                           session["createdAt"];

//                       return Container(
//                         margin:
//                             const EdgeInsets.only(
//                           bottom: 18,
//                         ),

//                         decoration:
//                             BoxDecoration(
//                           color:
//                               Colors.white,

//                           borderRadius:
//                               BorderRadius.circular(
//                             20,
//                           ),

//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors
//                                   .black
//                                   .withOpacity(
//                                 0.04,
//                               ),

//                               blurRadius:
//                                   10,

//                               offset:
//                                   const Offset(
//                                 0,
//                                 4,
//                               ),
//                             ),
//                           ],
//                         ),

//                         child: Padding(
//                           padding:
//                               const EdgeInsets.all(
//                             18,
//                           ),

//                           child: Column(
//                             crossAxisAlignment:
//                                 CrossAxisAlignment
//                                     .start,

//                             children: [
//                               /// =====================================
//                               /// TOP ROW
//                               /// =====================================

//                               Row(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 28,

//                                     backgroundColor:
//                                         AppColors
//                                             .primary,

//                                     backgroundImage:
//                                         mentorAvatar !=
//                                                 null
//                                             ? NetworkImage(
//                                                 mentorAvatar,
//                                               )
//                                             : null,

//                                     child: mentorAvatar == null
//                                         ? Text(
//                                             mentorName.isNotEmpty
//                                                 ? mentorName[0]
//                                                     .toUpperCase()
//                                                 : "M",

//                                             style:
//                                                 const TextStyle(
//                                               color:
//                                                   Colors
//                                                       .white,

//                                               fontWeight:
//                                                   FontWeight
//                                                       .bold,

//                                               fontSize:
//                                                   20,
//                                             ),
//                                           )
//                                         : null,
//                                   ),

//                                   const SizedBox(
//                                     width: 14,
//                                   ),

//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment
//                                               .start,

//                                       children: [
//                                         Text(
//                                           mentorName,

//                                           style:
//                                               const TextStyle(
//                                             fontSize:
//                                                 18,

//                                             fontWeight:
//                                                 FontWeight
//                                                     .bold,
//                                           ),
//                                         ),

//                                         const SizedBox(
//                                           height: 4,
//                                         ),

//                                         Text(
//                                           specialization,

//                                           style:
//                                               TextStyle(
//                                             color: Colors
//                                                 .grey[700],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                   Container(
//                                     padding:
//                                         const EdgeInsets.symmetric(
//                                       horizontal:
//                                           12,

//                                       vertical:
//                                           6,
//                                     ),

//                                     decoration:
//                                         BoxDecoration(
//                                       color:
//                                           getStatusColor(
//                                         status,
//                                       ).withOpacity(
//                                         0.12,
//                                       ),

//                                       borderRadius:
//                                           BorderRadius.circular(
//                                         20,
//                                       ),
//                                     ),

//                                     child: Text(
//                                       status,

//                                       style:
//                                           TextStyle(
//                                         color:
//                                             getStatusColor(
//                                           status,
//                                         ),

//                                         fontWeight:
//                                             FontWeight
//                                                 .bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),

//                               const SizedBox(
//                                 height: 20,
//                               ),

//                               /// =====================================
//                               /// SESSION TITLE
//                               /// =====================================

//                               Text(
//                                 title,

//                                 style:
//                                     const TextStyle(
//                                   fontSize: 18,

//                                   fontWeight:
//                                       FontWeight
//                                           .bold,
//                                 ),
//                               ),

//                               if (description
//                                   .toString()
//                                   .isNotEmpty) ...[
//                                 const SizedBox(
//                                   height: 10,
//                                 ),

//                                 Text(
//                                   description,

//                                   style: TextStyle(
//                                     color:
//                                         Colors.grey[
//                                             700],

//                                     height: 1.5,
//                                   ),
//                                 ),
//                               ],

//                               const SizedBox(
//                                 height: 20,
//                               ),

//                               /// =====================================
//                               /// SESSION DETAILS
//                               /// =====================================

//                               _buildInfoTile(
//                                 icon:
//                                     Icons.calendar_today,

//                                 title:
//                                     "Session Date",

//                                 value: formatDate(
//                                   scheduledAt,
//                                 ),
//                               ),

//                               _buildInfoTile(
//                                 icon:
//                                     Icons.access_time,

//                                 title:
//                                     "Session Time",

//                                 value: formatTime(
//                                   scheduledAt,
//                                 ),
//                               ),

//                               _buildInfoTile(
//                                 icon: Icons.phone,

//                                 title:
//                                     "Mentor Phone",

//                                 value:
//                                     mentorPhone,
//                               ),

//                               _buildInfoTile(
//                                 icon: Icons.email,

//                                 title:
//                                     "Mentor Email",

//                                 value:
//                                     mentorEmail,
//                               ),

//                               _buildInfoTile(
//                                 icon:
//                                     Icons.location_on,

//                                 title:
//                                     "District",

//                                 value:
//                                     mentorDistrict,
//                               ),

//                               _buildInfoTile(
//                                 icon:
//                                     Icons.schedule,

//                                 title:
//                                     "Created On",

//                                 value: formatDate(
//                                   createdAt,
//                                 ),
//                               ),

//                               /// =====================================
//                               /// MEETING LINK
//                               /// =====================================

//                               if (meetingLink
//                                   .toString()
//                                   .isNotEmpty) ...[
//                                 const SizedBox(
//                                   height: 16,
//                                 ),

//                                 SizedBox(
//                                   width:
//                                       double.infinity,

//                                   height: 52,

//                                   child:
//                                       ElevatedButton.icon(
//                                     onPressed:
//                                         () {
//                                       debugPrint(
//                                         meetingLink,
//                                       );
//                                     },

//                                     icon:
//                                         const Icon(
//                                       Icons
//                                           .video_call,
//                                     ),

//                                     label:
//                                         const Text(
//                                       "Join Meeting",
//                                     ),

//                                     style:
//                                         ElevatedButton.styleFrom(
//                                       backgroundColor:
//                                           AppColors
//                                               .primary,

//                                       foregroundColor:
//                                           Colors
//                                               .white,

//                                       shape:
//                                           RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(
//                                           14,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//       ),
//     );
//   }

//   /// =====================================
//   /// INFO TILE
//   /// =====================================

//   Widget _buildInfoTile({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return Padding(
//       padding:
//           const EdgeInsets.only(
//         bottom: 14,
//       ),

//       child: Row(
//         children: [
//           Icon(
//             icon,

//             size: 20,

//             color:
//                 AppColors.primary,
//           ),

//           const SizedBox(
//             width: 12,
//           ),

//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment
//                       .start,

//               children: [
//                 Text(
//                   title,

//                   style: TextStyle(
//                     color:
//                         Colors.grey[600],

//                     fontSize: 13,
//                   ),
//                 ),

//                 const SizedBox(
//                   height: 2,
//                 ),

//                 Text(
//                   value,

//                   style:
//                       const TextStyle(
//                     fontWeight:
//                         FontWeight.w600,

//                     fontSize: 15,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// lib/features/student/presentation/screens/sessions_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'mentor_detail_screen.dart';
import '../../../../../services/student/student_service.dart';
import '../../../../../theme/app_colors.dart';

class SessionsScreen extends StatefulWidget {
  final Function(int index) onNavigate;

  const SessionsScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<SessionsScreen> createState() =>
      _SessionsScreenState();
}

class _SessionsScreenState
    extends State<SessionsScreen> {
  bool isLoading = true;

  List<Map<String, dynamic>>
      sessions = [];

  @override
  void initState() {
    super.initState();

    loadSessions();
  }

  /// =====================================
  /// LOAD SESSIONS
  /// =====================================

  Future<void> loadSessions() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response =
          await StudentService
              .getStudentSessions();

      if (!mounted) return;

      setState(() {
        sessions =
            List<Map<String, dynamic>>.from(
          response,
        );
      });
    } catch (e) {
      debugPrint(
        "Session Error: $e",
      );

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
        isLoading = false;
      });
    }
  }

  /// =====================================
  /// FORMAT DATE
  /// =====================================

  String formatDate(
    String? value,
  ) {
    if (value == null) {
      return "N/A";
    }

    try {
      return DateFormat(
        "dd MMM yyyy",
      ).format(
        DateTime.parse(value),
      );
    } catch (e) {
      return value;
    }
  }

  /// =====================================
  /// FORMAT TIME
  /// =====================================

  String formatTime(
    String? value,
  ) {
    if (value == null) {
      return "N/A";
    }

    try {
      return DateFormat(
        "hh:mm a",
      ).format(
        DateTime.parse(value),
      );
    } catch (e) {
      return value;
    }
  }

  /// =====================================
  /// STATUS COLOR
  /// =====================================

  Color getStatusColor(
    String status,
  ) {
    switch (status) {
      case "COMPLETED":
        return Colors.green;

      case "CANCELLED":
        return Colors.red;

      case "MISSED":
        return Colors.redAccent;

      default:
        return Colors.orange;
    }
  }

  /// =====================================
  /// OPEN LINK
  /// =====================================

  Future<void> openMeetingLink(
    String url,
  ) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode:
              LaunchMode
                  .externalApplication,
        );
      }
    } catch (e) {
      debugPrint(
        "Launch Error: $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// =====================================
    /// UPCOMING SESSION
    /// =====================================

    final upcomingSessions =
        sessions
            .where(
              (e) =>
                  e["status"] ==
                  "SCHEDULED",
            )
            .toList();

    final previousSessions =
        sessions
            .where(
              (e) =>
                  e["status"] !=
                  "SCHEDULED",
            )
            .toList();

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,

        backgroundColor:
            AppColors.primary,

        title: const Text(
          "Mentorship",
        ),

        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: loadSessions,

        child: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : sessions.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(
                        height: 250,
                      ),

                      Center(
                        child: Text(
                          "No mentorship sessions found",
                        ),
                      ),
                    ],
                  )
                : ListView(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    children: [
                      /// =====================================
                      /// HEADER CARD
                      /// =====================================

                      _buildMentorHeader(),

                      const SizedBox(
                        height: 24,
                      ),

                      /// =====================================
                      /// UPCOMING
                      /// =====================================

                      if (upcomingSessions
                          .isNotEmpty) ...[
                        const Text(
                          "Upcoming Sessions",

                          style: TextStyle(
                            fontSize: 20,

                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        ...upcomingSessions
                            .map(
                              (session) =>
                                  _buildSessionCard(
                                session,
                              ),
                            ),
                      ],

                      /// =====================================
                      /// OLD SESSIONS
                      /// =====================================

                      if (previousSessions
                          .isNotEmpty) ...[
                        const SizedBox(
                          height: 30,
                        ),

                        const Text(
                          "Previous Sessions",

                          style: TextStyle(
                            fontSize: 20,

                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        ...previousSessions
                            .map(
                              (session) =>
                                  _buildSessionCard(
                                session,
                              ),
                            ),
                      ],
                    ],
                  ),
      ),
    );
  }

  /// =====================================
  /// MENTOR HEADER
  /// =====================================

  Widget _buildMentorHeader() {
    final session =
        sessions.first;

    final mentor =
        session["mentor"] ?? {};

    final mentorUser =
        mentor["user"] ?? {};

    final mentorName =
        mentorUser["fullName"] ??
            "Mentor";

    final mentorPhone =
        mentorUser["phone"] ?? "";

    final mentorAvatar =
        mentorUser["avatar"];

    final specialization =
        mentor["specialization"] ??
            "Mentor";

    final district =
        mentor["district"] ?? "";

    return Container(
      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient:
            LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary
                .withOpacity(0.8),
          ],
        ),

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Column(
        children: [
          CircleAvatar(
            radius: 42,

            backgroundColor:
                Colors.white,

            backgroundImage:
                mentorAvatar != null
                    ? NetworkImage(
                        mentorAvatar,
                      )
                    : null,

            child: mentorAvatar ==
                    null
                ? Text(
                    mentorName[0]
                        .toUpperCase(),

                    style:
                        TextStyle(
                      color:
                          AppColors
                              .primary,

                      fontWeight:
                          FontWeight
                              .bold,

                      fontSize: 30,
                    ),
                  )
                : null,
          ),

          const SizedBox(
            height: 14,
          ),

          Text(
            mentorName,

            style:
                const TextStyle(
              color:
                  Colors.white,

              fontSize: 22,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            specialization,

            style:
                const TextStyle(
              color:
                  Colors.white70,

              fontSize: 15,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceEvenly,

            children: [
              _mentorInfo(
                Icons.phone,
                mentorPhone,
              ),

              _mentorInfo(
                Icons.location_on,
                district,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// =====================================
  /// SESSION CARD
  /// =====================================

  Widget _buildSessionCard(
    Map<String, dynamic>
        session,
  ) {
    final title =
        session["title"] ??
            "Session";

    final description =
        session["description"] ??
            "";

    final status =
        session["status"] ??
            "SCHEDULED";

    final scheduledAt =
        session["scheduledAt"];

    final meetingLink =
        session["meetingLink"] ??
            "";

    final notes =
        session["notes"];

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 18,
      ),

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),

            blurRadius: 10,

            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [
          /// TOP
          Row(
            children: [
              Expanded(
                child: Text(
                  title,

                  style:
                      const TextStyle(
                    fontSize: 18,

                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      getStatusColor(
                    status,
                  ).withOpacity(
                    0.12,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
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
                            .bold,
                  ),
                ),
              ),
            ],
          ),

          if (description
              .toString()
              .isNotEmpty) ...[
            const SizedBox(
              height: 12,
            ),

            Text(
              description,

              style: TextStyle(
                color:
                    Colors.grey[700],

                height: 1.5,
              ),
            ),
          ],

          const SizedBox(
            height: 18,
          ),

          /// DATE
          _buildInfoTile(
            Icons.calendar_today,
            "Date",
            formatDate(
              scheduledAt,
            ),
          ),

          _buildInfoTile(
            Icons.access_time,
            "Time",
            formatTime(
              scheduledAt,
            ),
          ),

          /// NOTES
          if (notes != null &&
              notes
                  .toString()
                  .isNotEmpty) ...[
            const SizedBox(
              height: 12,
            ),

            Container(
              padding:
                  const EdgeInsets.all(
                14,
              ),

              decoration:
                  BoxDecoration(
                color:
                    Colors.blue
                        .withOpacity(
                  0.05,
                ),

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),

              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Icon(
                    Icons.notes,

                    color:
                        AppColors
                            .primary,
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child: Text(
                      notes,

                      style:
                          const TextStyle(
                        height:
                            1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          /// BUTTONS
          const SizedBox(
            height: 18,
          ),

          Row(
            children: [
              Expanded(
                child:
                    OutlinedButton.icon(
                        onPressed: () {
                          final mentor =
                              session["mentor"];

                          if (mentor == null) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Mentor details not available",
                                ),
                              ),
                            );

                            return;
                          }

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  MentorDetailScreen(
                                mentor: mentor,
                              ),
                            ),
                          );
                        },

                  icon: const Icon(
                    Icons.person,
                  ),

                  label: const Text(
                    "View Mentor",
                  ),

                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        AppColors
                            .primary,

                    side: BorderSide(
                      color:
                          AppColors
                              .primary,
                    ),

                    padding:
                        const EdgeInsets.symmetric(
                      vertical:
                          14,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              if (meetingLink
                  .toString()
                  .isNotEmpty)
                Expanded(
                  child:
                      ElevatedButton.icon(
                    onPressed: () {
                      openMeetingLink(
                        meetingLink,
                      );
                    },

                    icon: const Icon(
                      Icons.video_call,
                    ),

                    label: const Text(
                      "Join",
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors
                              .primary,

                      foregroundColor:
                          Colors.white,

                      padding:
                          const EdgeInsets.symmetric(
                        vertical:
                            14,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// =====================================
  /// MENTOR INFO
  /// =====================================

  Widget _mentorInfo(
    IconData icon,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,

          color: Colors.white,

          size: 18,
        ),

        const SizedBox(
          width: 6,
        ),

        Text(
          value,

          style:
              const TextStyle(
            color:
                Colors.white,
          ),
        ),
      ],
    );
  }

  /// =====================================
  /// INFO TILE
  /// =====================================

  Widget _buildInfoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),

      child: Row(
        children: [
          Icon(
            icon,

            size: 18,

            color:
                AppColors.primary,
          ),

          const SizedBox(
            width: 10,
          ),

          Text(
            "$title : ",

            style:
                const TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          Expanded(
            child: Text(
              value,
            ),
          ),
        ],
      ),
    );
  }
}