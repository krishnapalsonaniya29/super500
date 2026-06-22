import 'package:flutter/material.dart';

import '../../../../../services/super_admin/super_admin_service.dart';
import '../../../../../theme/app_colors.dart';
import 'mentor_students_screen.dart';

class MentorsScreen extends StatefulWidget {
  final Function(int index) onNavigate;

  const MentorsScreen({super.key, required this.onNavigate});

  @override
  State<MentorsScreen> createState() => _MentorsScreenState();
}

class _MentorsScreenState extends State<MentorsScreen> {
  List mentors = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    fetchMentors();
  }

  Future<void> fetchMentors() async {
    try {
      final response = await SuperAdminService.getMentors();

      setState(() {
        mentors = (response["data"] as List?) ?? [];
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> removeMentor(String id) async {
    try {
      await SuperAdminService.deleteMentor(id);

      fetchMentors();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mentor removed successfully")),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalStudents = mentors.fold<int>(
      0,
      (sum, mentor) => sum + ((mentor["students"]?.length ?? 0) as int),
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},

        backgroundColor: AppColors.primary,

        icon: const Icon(Icons.person_add_alt_1, color: Colors.white),

        label: const Text("Add Mentor", style: TextStyle(color: Colors.white)),
      ),

      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: fetchMentors,

                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Super Admin",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  SizedBox(height: 6),

                                  Text(
                                    "Manage Mentors",
                                    style: TextStyle(
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

                      /// TOP ANALYTICS
                      Row(
                        children: [
                          Expanded(
                            child: buildStatCard(
                              title: "Total Mentors",

                              value: mentors.length.toString(),

                              icon: Icons.groups_rounded,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: buildStatCard(
                              title: "Students Assigned",

                              value: totalStudents.toString(),

                              icon: Icons.school_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      /// MENTOR LIST
                      const Text(
                        "All Mentors",

                        style: TextStyle(
                          fontSize: 22,

                          fontWeight: FontWeight.bold,

                          fontFamily: 'Poppins',
                        ),
                      ),

                      const SizedBox(height: 18),

                      if (mentors.isEmpty)
                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(30),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(24),
                          ),

                          child: const Column(
                            children: [
                              Icon(
                                Icons.groups_rounded,

                                size: 60,

                                color: Colors.grey,
                              ),

                              SizedBox(height: 18),

                              Text(
                                "No mentors found",

                                style: TextStyle(
                                  fontSize: 18,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                      ListView.builder(
                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: mentors.length,

                        itemBuilder: (_, index) {
                          final mentor = mentors[index];

                          return buildMentorCard(mentor: mentor);
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),

              borderRadius: BorderRadius.circular(16),
            ),

            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(height: 18),

          Text(
            value,

            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(title, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget buildMentorCard({required dynamic mentor}) {
    final user = mentor["user"] ?? {};

    final students = (mentor["students"] as List?) ?? [];

    final fullName = (user["fullName"] ?? "").toString();

    final firstLetter = fullName.isNotEmpty ? fullName[0].toUpperCase() : "?";

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary,
                child: Text(
                  firstLetter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName.isNotEmpty ? fullName : "Unknown Mentor",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      (mentor["district"] ?? "No District").toString(),
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: (user["isActive"] == true)
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  (user["isActive"] == true) ? "Active" : "Inactive",
                  style: TextStyle(
                    color: (user["isActive"] == true)
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: buildInfoTile(
                  title: "Students",
                  value: students.length.toString(),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: buildInfoTile(
                  title: "District",
                  value: (mentor["district"] ?? "-").toString(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.phone, size: 18, color: AppColors.primary),

                    const SizedBox(width: 10),

                    Text((user["phone"] ?? "-").toString()),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        (mentor["specialization"] ?? "No Specialization")
                            .toString(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MentorStudentsScreen(mentor: mentor),
                      ),
                    );
                  },
                  child: const Text("View Students"),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    removeMentor(mentor["id"].toString());
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Remove"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // Widget buildMentorCard({
  //   required dynamic mentor,
  // }) {
  //   final user = mentor["user"];

  //   final students =
  //       mentor["students"] ?? [];

  //   return Container(
  //     margin:
  //         const EdgeInsets.only(
  //       bottom: 18,
  //     ),

  //     padding:
  //         const EdgeInsets.all(
  //       20,
  //     ),

  //     decoration: BoxDecoration(
  //       color: Colors.white,

  //       borderRadius:
  //           BorderRadius.circular(
  //         24,
  //       ),

  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black
  //               .withValues(
  //                 alpha: 0.05,
  //               ),

  //           blurRadius: 10,

  //           offset:
  //               const Offset(0, 4),
  //         ),
  //       ],
  //     ),

  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             CircleAvatar(
  //               radius: 28,

  //               backgroundColor:
  //                   AppColors.primary,

  //               child: Text(
  //                 user["fullName"][
  //                     0],

  //                 style:
  //                     const TextStyle(
  //                   color:
  //                       Colors.white,

  //                   fontWeight:
  //                       FontWeight
  //                           .bold,

  //                   fontSize: 22,
  //                 ),
  //               ),
  //             ),

  //             const SizedBox(
  //               width: 16,
  //             ),

  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment:
  //                     CrossAxisAlignment
  //                         .start,

  //                 children: [
  //                   Text(
  //                     user["fullName"],

  //                     style:
  //                         const TextStyle(
  //                       fontSize: 18,

  //                       fontWeight:
  //                           FontWeight
  //                               .bold,
  //                     ),
  //                   ),

  //                   const SizedBox(
  //                     height: 6,
  //                   ),

  //                   Text(
  //                     mentor[
  //                             "district"] ??
  //                         "No District",

  //                     style:
  //                         const TextStyle(
  //                       color: AppColors
  //                           .textSecondary,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),

  //             Container(
  //               padding:
  //                   const EdgeInsets.symmetric(
  //                 horizontal: 14,
  //                 vertical: 8,
  //               ),

  //               decoration:
  //                   BoxDecoration(
  //                 color:
  //                     (user["isActive"] ==
  //                             true)
  //                         ? Colors.green
  //                             .withValues(
  //                               alpha:
  //                                   0.1,
  //                             )
  //                         : Colors.red
  //                             .withValues(
  //                               alpha:
  //                                   0.1,
  //                             ),

  //                 borderRadius:
  //                     BorderRadius.circular(
  //                   20,
  //                 ),
  //               ),

  //               child: Text(
  //                 (user["isActive"] ==
  //                         true)
  //                     ? "Active"
  //                     : "Inactive",

  //                 style: TextStyle(
  //                   color:
  //                       (user["isActive"] ==
  //                               true)
  //                           ? Colors
  //                               .green
  //                           : Colors.red,

  //                   fontWeight:
  //                       FontWeight
  //                           .w600,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),

  //         const SizedBox(
  //           height: 20,
  //         ),

  //         Row(
  //           children: [
  //             Expanded(
  //               child:
  //                   buildInfoTile(
  //                 title:
  //                     "Students",

  //                 value: students
  //                     .length
  //                     .toString(),
  //               ),
  //             ),

  //             const SizedBox(
  //               width: 14,
  //             ),

  //             Expanded(
  //               child:
  //                   buildInfoTile(
  //                 title:
  //                     "District",

  //                 value:
  //                     mentor[
  //                             "district"] ??
  //                         "-",
  //               ),
  //             ),
  //           ],
  //         ),

  //         const SizedBox(
  //           height: 18,
  //         ),

  //         Container(
  //           width:
  //               double.infinity,

  //           padding:
  //               const EdgeInsets.all(
  //             16,
  //           ),

  //           decoration:
  //               BoxDecoration(
  //             color: AppColors
  //                 .primary
  //                 .withValues(
  //                   alpha: 0.04,
  //                 ),

  //             borderRadius:
  //                 BorderRadius.circular(
  //               18,
  //             ),
  //           ),

  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   const Icon(
  //                     Icons.phone,

  //                     size: 18,

  //                     color:
  //                         AppColors
  //                             .primary,
  //                   ),

  //                   const SizedBox(
  //                     width: 10,
  //                   ),

  //                   Text(
  //                     user["phone"] ??
  //                         "-",
  //                   ),
  //                 ],
  //               ),

  //               const SizedBox(
  //                 height: 12,
  //               ),

  //               Row(
  //                 children: [
  //                   const Icon(
  //                     Icons
  //                         .workspace_premium_rounded,

  //                     size: 18,

  //                     color:
  //                         AppColors
  //                             .primary,
  //                   ),

  //                   const SizedBox(
  //                     width: 10,
  //                   ),

  //                   Expanded(
  //                     child: Text(
  //                       mentor["specialization"] ??
  //                           "No Specialization",
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),

  //         const SizedBox(
  //           height: 20,
  //         ),

  //         Row(
  //           children: [
  //             Expanded(
  //               child:
  //                   ElevatedButton(
  //                 onPressed: () {},

  //                 style:
  //                     ElevatedButton.styleFrom(
  //                   backgroundColor:
  //                       AppColors
  //                           .primary,

  //                   padding:
  //                       const EdgeInsets.symmetric(
  //                     vertical: 14,
  //                   ),

  //                   shape:
  //                       RoundedRectangleBorder(
  //                     borderRadius:
  //                         BorderRadius.circular(
  //                       16,
  //                     ),
  //                   ),
  //                 ),

  //                 child: const Text(
  //                   "View Students",
  //                 ),
  //               ),
  //             ),

  //             const SizedBox(
  //               width: 14,
  //             ),

  //             Expanded(
  //               child:
  //                   ElevatedButton(
  //                 onPressed: () {
  //                   removeMentor(
  //                     mentor["id"],
  //                   );
  //                 },

  //                 style:
  //                     ElevatedButton.styleFrom(
  //                   backgroundColor:
  //                       Colors.red,

  //                   padding:
  //                       const EdgeInsets.symmetric(
  //                     vertical: 14,
  //                   ),

  //                   shape:
  //                       RoundedRectangleBorder(
  //                     borderRadius:
  //                         BorderRadius.circular(
  //                       16,
  //                     ),
  //                   ),
  //                 ),

  //                 child: const Text(
  //                   "Remove",
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildInfoTile({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.06),

        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        children: [
          Text(
            value,

            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(title, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
