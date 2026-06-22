import 'package:flutter/material.dart';
import '../students/student_detail_screen.dart';
import '../../../../../theme/app_colors.dart';

class MentorStudentsScreen extends StatelessWidget {
  final Map<String, dynamic> mentor;

  const MentorStudentsScreen({super.key, required this.mentor});

  @override
  Widget build(BuildContext context) {
    final students = List<Map<String, dynamic>>.from(mentor["students"] ?? []);

    return Scaffold(
      body: SingleChildScrollView(
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
                    color: AppColors.primary,
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

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mentor["user"]?["fullName"] ?? "Mentor",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "Assigned Students",
                          style: TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "${students.length} Students",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// STUDENTS LIST
            if (students.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text("No students assigned"),
                ),
              ),

            ...students.map((student) {
              final user = student["user"] ?? {};

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudentDetailScreen(student: student),
                      ),
                    );
                  },

                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(
                      (user["fullName"] ?? "S")[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  title: Text(user["fullName"] ?? "Unknown"),

                  subtitle: Text(student["schoolName"] ?? ""),

                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
