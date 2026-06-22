import 'package:flutter/material.dart';

import '../../../../../services/mentor/mentor_service.dart';

import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/loaders/app_loader.dart';
import './create_report_screen.dart';

class MentorStudentDetailScreen extends StatefulWidget {
  final String studentId;

  const MentorStudentDetailScreen({super.key, required this.studentId});

  @override
  State<MentorStudentDetailScreen> createState() =>
      _MentorStudentDetailScreenState();
}

class _MentorStudentDetailScreenState extends State<MentorStudentDetailScreen> {
  bool isLoading = true;

  Map<String, dynamic>? student;

  @override
  void initState() {
    super.initState();

    loadStudent();
  }

  Future<void> loadStudent() async {
    try {
      final response = await MentorService.getStudentDetails(widget.studentId);

      if (!mounted) return;

      setState(() {
        student = response["student"];

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

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 12),

      child: Text(
        title,

        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildInfoTile({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        children: [
          SizedBox(
            width: 140,

            child: Text(
              label,

              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          Expanded(child: Text(value.isEmpty ? "N/A" : value)),
        ],
      ),
    );
  }

  String? getProfileImage(List<Map<String, dynamic>> documents) {
    try {
      final photo = documents.firstWhere(
        (doc) => doc["documentType"] == "PHOTO",
      );

      return photo["documentUrl"];
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: AppLoader()));
    }

    final user = student?["user"] ?? {};

    final sessions = List<Map<String, dynamic>>.from(
      student?["sessions"] ?? [],
    );

    final documents = List<Map<String, dynamic>>.from(
      student?["documents"] ?? [],
    );

    final achievements = List<Map<String, dynamic>>.from(
      student?["achievements"] ?? [],
    );

    final expenses = List<Map<String, dynamic>>.from(
      student?["expenses"] ?? [],
    );

    final fullName = user["fullName"] ?? "";

    final profileImage = getProfileImage(documents);

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primary,

        title: Text(fullName.isEmpty ? "Student" : fullName),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// ============================
            /// PROFILE CARD
            /// ============================
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 38,

                      backgroundColor: AppColors.gold,

                      backgroundImage: profileImage != null
                          ? NetworkImage(profileImage)
                          : null,

                      child: profileImage == null
                          ? Text(
                              fullName.isNotEmpty
                                  ? fullName[0].toUpperCase()
                                  : "S",

                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          : null,
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            fullName,

                            style: const TextStyle(
                              fontSize: 21,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(student?["schoolName"] ?? ""),

                          Text(student?["stream"] ?? ""),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ============================
            /// STUDENT DETAILS
            /// ============================
            buildSectionTitle("Student Details"),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    buildInfoTile(label: "Phone", value: user["phone"] ?? ""),

                    buildInfoTile(label: "Email", value: user["email"] ?? ""),

                    buildInfoTile(
                      label: "School",

                      value: student?["schoolName"] ?? "",
                    ),

                    buildInfoTile(
                      label: "Stream",

                      value: student?["stream"] ?? "",
                    ),

                    buildInfoTile(
                      label: "Scholarship",

                      value: student?["scholarshipStatus"] ?? "N/A",
                    ),

                    buildInfoTile(
                      label: "Address",

                      value: student?["address"] ?? "",
                    ),
                  ],
                ),
              ),
            ),

            /// ============================
            /// SESSIONS
            /// ============================
            buildSectionTitle("Sessions"),

            if (sessions.isEmpty) const Text("No sessions available"),

            ...sessions.map((session) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.schedule),

                  title: Text(session["title"] ?? ""),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(session["status"] ?? ""),

                      if (session["notes"] != null) Text(session["notes"]),
                    ],
                  ),
                ),
              );
            }),

            /// ============================
            /// ACHIEVEMENTS
            /// ============================
            buildSectionTitle("Achievements"),

            if (achievements.isEmpty) const Text("No achievements available"),

            ...achievements.map((achievement) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.emoji_events),

                  title: Text(achievement["title"] ?? ""),

                  subtitle: Text(achievement["description"] ?? ""),
                ),
              );
            }),

            /// ============================
            /// EXPENSES
            /// ============================
            buildSectionTitle("Expenses"),

            if (expenses.isEmpty) const Text("No expenses available"),

            ...expenses.map((expense) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.currency_rupee),

                  title: Text(expense["title"] ?? ""),

                  subtitle: Text("₹ ${expense["amount"] ?? 0}"),
                ),
              );
            }),

            const SizedBox(height: 80),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.gold,

        child: const Icon(Icons.assignment, color: Colors.black),

        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) => CreateReportScreen(
                studentId: widget.studentId,

                studentName: fullName.isEmpty ? "Student" : fullName,
              ),
            ),
          );
        },
      ),
    );
  }
}
