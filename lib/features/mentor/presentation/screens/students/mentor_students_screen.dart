import 'package:flutter/material.dart';

import '../../../../../services/mentor/mentor_service.dart';

import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/loaders/app_loader.dart';

import 'mentor_student_detail_screen.dart';

class MentorStudentsScreen extends StatefulWidget {
  const MentorStudentsScreen({super.key});

  @override
  State<MentorStudentsScreen> createState() => _MentorStudentsScreenState();
}

class _MentorStudentsScreenState extends State<MentorStudentsScreen> {
  bool isLoading = true;

  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();

    loadStudents();
  }

  Future<void> loadStudents() async {
    try {
      final response = await MentorService.getStudents();

      if (!mounted) return;

      setState(() {
        students = List<Map<String, dynamic>>.from(response["students"] ?? []);

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: AppLoader());
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      body: RefreshIndicator(
        onRefresh: loadStudents,

        child: students.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),

                children: const [
                  SizedBox(height: 250),

                  Column(
                    children: [
                      Icon(Icons.school_outlined, size: 70, color: Colors.grey),

                      SizedBox(height: 16),

                      Text(
                        "No students assigned yet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        "Assigned students will appear here.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(16),
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
                            children: [
                              Text(
                                "Assigned Students",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "View and monitor students assigned to you.",
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

                  /// STUDENTS
                  ...students.map((student) {
                    final user = student["user"] ?? {};

                    final name = user["fullName"] ?? "";

                    final school = student["schoolName"] ?? "";

                    final stream = student["stream"] ?? "";

                    return _buildStudentCard(student, name, school, stream);
                  }),
                ],
              ),
      ),
    );
  }

  Widget _buildStudentCard(
    Map<String, dynamic> student,
    String name,
    String school,
    String stream,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : "S",
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                if (school.isNotEmpty) Text(school),

                if (stream.isNotEmpty) Text(stream),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MentorStudentDetailScreen(studentId: student["id"]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
