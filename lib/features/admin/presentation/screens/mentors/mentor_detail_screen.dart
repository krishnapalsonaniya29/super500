import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';

class MentorDetailScreen extends StatelessWidget {
  final Map<String, dynamic> mentor;

  const MentorDetailScreen({super.key, required this.mentor});

  Color getStatusColor(String status) {
    switch (status) {
      case "APPROVED":
        return Colors.green;

      case "REJECTED":
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = mentor["user"];

    final students = mentor["students"] ?? [];

    final status = mentor["verificationStatus"] ?? "PENDING";

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Mentor Details"),

        backgroundColor: AppColors.primary,

        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// PROFILE CARD
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,

                    backgroundColor: AppColors.primary,

                    child: Text(
                      user["fullName"][0].toUpperCase(),

                      style: const TextStyle(
                        color: Colors.white,

                        fontSize: 30,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    user["fullName"],

                    style: const TextStyle(
                      fontSize: 26,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: getStatusColor(status).withValues(alpha: 0.1),

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      status,

                      style: TextStyle(
                        color: getStatusColor(status),

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  buildInfoRow("Phone", user["phone"] ?? "-"),

                  buildInfoRow("District", mentor["district"] ?? "-"),

                  buildInfoRow("Students Assigned", students.length.toString()),

                  buildInfoRow("Role", user["role"] ?? "-"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ANALYTICS
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Mentor Analytics",

                    style: TextStyle(
                      fontSize: 22,

                      fontWeight: FontWeight.bold,

                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 20),

                  buildAnalyticsRow(
                    title: "Assigned Students",

                    value: students.length.toString(),
                  ),

                  buildAnalyticsRow(
                    title: "Verification Status",

                    value: status,
                  ),

                  buildAnalyticsRow(
                    title: "District",

                    value: mentor["district"] ?? "-",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// STUDENTS SECTION
            const Text(
              "Assigned Students",

              style: TextStyle(
                fontSize: 24,

                fontWeight: FontWeight.bold,

                fontFamily: 'Poppins',
              ),
            ),

            const SizedBox(height: 18),

            students.isEmpty
                ? Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Center(child: Text("No students assigned")),
                  )
                : Column(
                    children: students.map<Widget>((student) {
                      final studentUser = student["user"];

                      return Container(
                        width: double.infinity,

                        margin: const EdgeInsets.only(bottom: 16),

                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(22),
                        ),

                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,

                              backgroundColor: AppColors.primary,

                              child: Text(
                                studentUser["fullName"][0].toUpperCase(),

                                style: const TextStyle(
                                  color: Colors.white,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    studentUser["fullName"] ?? "-",

                                    style: const TextStyle(
                                      fontSize: 16,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(student["schoolName"] ?? "-"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: Row(
        children: [
          Expanded(
            flex: 2,

            child: Text(
              title,

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  Widget buildAnalyticsRow({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: Row(
        children: [
          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          Text(
            value,

            style: const TextStyle(
              fontWeight: FontWeight.bold,

              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
