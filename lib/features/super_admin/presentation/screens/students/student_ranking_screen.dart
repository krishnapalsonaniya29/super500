import 'package:flutter/material.dart';

import '../../../../../services/super_admin/super_admin_service.dart';
import '../../../../../theme/app_colors.dart';
import 'student_detail_screen.dart';

class StudentRankingScreen
    extends StatefulWidget {
  const StudentRankingScreen({
    super.key,
  });

  @override
  State<StudentRankingScreen>
      createState() =>
          _StudentRankingScreenState();
}

class _StudentRankingScreenState
    extends State<StudentRankingScreen> {
  bool loading = true;

  List students = [];

  @override
  void initState() {
    super.initState();
    fetchRanking();
  }

  Future<void> fetchRanking() async {
    try {
      final response =
          await SuperAdminService
              .getStudentRanking();

      setState(() {
        students =
            response["data"] ?? [];
      });
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }


  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
  backgroundColor: AppColors.background,

  body: loading
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : SafeArea(
          child: RefreshIndicator(
            onRefresh: fetchRanking,
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
                            .withValues(alpha: 0.25),
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
                        padding:
                            const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                          child: Image.asset(
                            "assets/images/app_logo2.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Top 500 Students",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              "National Ranking Dashboard",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color:
                                AppColors.primary,
                          ),
                          tooltip:
                              "Recalculate Rankings",
                          onPressed: () async {
                            try {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Recalculating rankings...",
                                  ),
                                ),
                              );

                              await SuperAdminService
                                  .recalculateRankings();

                              await fetchRanking();

                              if (!mounted) return;

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Ranking updated successfully",
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Failed: $e",
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /// SUMMARY CARD
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(20),
                  margin:
                      const EdgeInsets.only(
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: 0.05,
                        ),
                        blurRadius: 8,
                        offset:
                            const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "${students.length}",
                            style:
                                const TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  AppColors.primary,
                            ),
                          ),
                          const Text(
                            "Ranked Students",
                          ),
                        ],
                      ),

                      Container(
                        width: 1,
                        height: 40,
                        color:
                            Colors.grey.shade300,
                      ),

                      const Column(
                        children: [
                          Icon(
                            Icons.emoji_events,
                            color:
                                Colors.amber,
                            size: 30,
                          ),
                          Text(
                            "Top 500",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// STUDENTS
                ...students.map(
                  (student) {
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                      margin:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.all(
                          12,
                        ),

                        leading:
                            CircleAvatar(
                          radius: 26,
                          backgroundColor:
                              student["rank"] <=
                                      3
                                  ? Colors.amber
                                  : AppColors
                                      .primary,
                          child: Text(
                            "${student["rank"]}",
                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        title: Text(
                          student["student"]
                                      ["user"]
                                  ?["fullName"] ??
                              "Unknown Student",
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        subtitle: Text(
                          "10th Marks : ${student["student"]["marks10th"]}",
                        ),

                        trailing:
                            const Icon(
                          Icons
                              .arrow_forward_ios,
                          size: 16,
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StudentDetailScreen(
                                student: student["student"],
                              ),
                            ),
                          );
                        },
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