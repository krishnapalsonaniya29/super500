import 'package:flutter/material.dart';

import '../../../../../services/mentor/mentor_service.dart';

import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/loaders/app_loader.dart';

import 'mentor_student_detail_screen.dart';

class MentorStudentsScreen
    extends StatefulWidget {
  const MentorStudentsScreen({
    super.key,
  });

  @override
  State<MentorStudentsScreen>
      createState() =>
          _MentorStudentsScreenState();
}

class _MentorStudentsScreenState
    extends State<
        MentorStudentsScreen> {
  bool isLoading = true;

  List<Map<String, dynamic>>
      students = [];

  @override
  void initState() {
    super.initState();

    loadStudents();
  }

  Future<void>
      loadStudents() async {
    try {
      final response =
          await MentorService
              .getStudents();

      if (!mounted) return;

      setState(() {
        students =
            List<Map<String, dynamic>>.from(
          response["students"] ?? [],
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
          "Assigned Students",
        ),

        elevation: 0,

        backgroundColor:
            AppColors.primary,
      ),

      body: RefreshIndicator(
        onRefresh: loadStudents,

        child: students.isEmpty
            ? ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                children: const [
                  SizedBox(
                    height: 250,
                  ),

                  Center(
                    child: Text(
                      "No students assigned",
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
                    students.length,

                itemBuilder:
                    (context, index) {
                  final student =
                      students[index];

                  final user =
                      student["user"] ??
                          {};

                  final name =
                      user["name"] ??
                          "";

                  final school =
                      student["schoolName"] ??
                          "";

                  final stream =
                      student["stream"] ??
                          "";

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 14,
                    ),

                    elevation: 2,

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
                            AppColors.gold,

                        child: Text(
                          name.isNotEmpty
                              ? name[0]
                                  .toUpperCase()
                              : "S",

                          style:
                              const TextStyle(
                            color:
                                Colors.black,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      title: Text(
                        name,

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

                          if (school
                              .isNotEmpty)
                            Text(school),

                          if (stream
                              .isNotEmpty)
                            Text(stream),
                        ],
                      ),

                      trailing:
                          const Icon(
                        Icons
                            .arrow_forward_ios,

                        size: 18,
                      ),

                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    MentorStudentDetailScreen(
                              studentId:
                                  student["id"],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}