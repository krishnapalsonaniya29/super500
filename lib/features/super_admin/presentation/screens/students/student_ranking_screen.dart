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
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Top 500 Students",
        ),
      ),

      body:
          loading
              ? const Center(
                child:
                    CircularProgressIndicator(),
              )
              : ListView.builder(
                padding:
                    const EdgeInsets.all(
                  16,
                ),

                itemCount:
                    students.length,

                itemBuilder:
                    (
                      context,
                      index,
                    ) {
                      final student =
                          students[index];

                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 10,
                        ),

                        child: ListTile(
                          leading:
                              CircleAvatar(
                            backgroundColor:
                                AppColors.primary,

                            child: Text(
                              "${student["rank"]}",
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                              ),
                            ),
                          ),

                          title: Text(
                            student["user"]?["fullName"] ?? "Unknown Student",
                          ),

                          subtitle: Text(
                            "10th Marks : ${student["marks10th"]}",
                          ),

                          trailing:
                              const Icon(
                            Icons
                                .arrow_forward_ios,
                            size: 16,
                          ),

                          onTap: () {
                              print(student);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      StudentDetailScreen(
                                    student: student,
                                  ),
                                ),
                              );
                            },
                        ),
                      );
                    },
              ),
    );
  }
}