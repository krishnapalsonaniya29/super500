import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';

class StudentDetailScreen
    extends StatelessWidget {
  final Map<String, dynamic>
      student;

  const StudentDetailScreen({
    super.key,
    required this.student,
  });

  Color getStatusColor(
    String status,
  ) {
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
    final user = student["user"];

    final documents =
        student["documents"] ?? [];

    final expenses =
        student["expenses"] ?? [];

    final achievements =
        student["achievements"] ??
            [];

    final mentor =
        student["mentor"];

    final status =
        student[
                "verificationStatus"] ??
            "PENDING";

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Student Details",
        ),

        backgroundColor:
            AppColors.primary,

        foregroundColor:
            Colors.white,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          children: [
            /// PROFILE CARD
            Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets.all(
                24,
              ),

              decoration:
                  BoxDecoration(
                color:
                    Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
              ),

              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,

                    backgroundColor:
                        AppColors.primary,

                    child: Text(
                      user["fullName"][0],

                      style:
                          const TextStyle(
                        color:
                            Colors.white,

                        fontSize: 28,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Text(
                    user["fullName"],

                    style:
                        const TextStyle(
                      fontSize: 24,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal:
                          14,
                      vertical: 8,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          getStatusColor(
                        status,
                      ).withValues(
                        alpha: 0.1,
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
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  buildInfoRow(
                    "Phone",
                    user["phone"] ??
                        "-",
                  ),

                  buildInfoRow(
                    "District",
                    student["district"] ??
                        "-",
                  ),

                  buildInfoRow(
                    "School",
                    student["schoolName"] ??
                        "-",
                  ),

                  buildInfoRow(
                    "Class",
                    student["currentClass"] ??
                        "-",
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 28,
            ),

            /// DOCUMENTS
            buildSectionTitle(
              "Documents",
            ),

            ...documents.map(
              (doc) => buildCard(
                title:
                    doc["documentType"] ??
                        "-",

                subtitle:
                    doc["fileUrl"] ??
                        "-",

                trailing:
                    doc["verified"] ==
                            true
                        ? "Verified"
                        : "Pending",
              ),
            ),

            const SizedBox(
              height: 28,
            ),

            /// EXPENSES
            buildSectionTitle(
              "Expenses",
            ),

            ...expenses.map(
              (expense) =>
                  buildCard(
                title:
                    expense["category"] ??
                        "-",

                subtitle:
                    "₹ ${expense["amount"]}",

                trailing:
                    expense["approved"] ==
                            true
                        ? "Approved"
                        : "Pending",
              ),
            ),

            const SizedBox(
              height: 28,
            ),

            /// ACHIEVEMENTS
            buildSectionTitle(
              "Achievements",
            ),

            ...achievements.map(
              (achievement) =>
                  buildCard(
                title:
                    achievement[
                            "title"] ??
                        "-",

                subtitle:
                    achievement[
                            "description"] ??
                        "-",
              ),
            ),

            const SizedBox(
              height: 28,
            ),

            /// MENTOR
            buildSectionTitle(
              "Assigned Mentor",
            ),

            mentor != null
                ? buildCard(
                    title:
                        mentor["user"]
                                ?[
                                "fullName"] ??
                            "-",

                    subtitle:
                        mentor["district"] ??
                            "-",
                  )
                : Container(
                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets.all(
                      20,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child:
                        const Text(
                      "No mentor assigned",
                    ),
                  ),

            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(
    String title,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),

      child: Text(
        title,

        style: const TextStyle(
          fontSize: 22,

          fontWeight:
              FontWeight.bold,

          fontFamily:
              'Poppins',
        ),
      ),
    );
  }

  Widget buildCard({
    required String title,
    required String subtitle,
    String? trailing,
  }) {
    return Container(
      width: double.infinity,

      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  title,

                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight
                            .bold,

                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  subtitle,

                  style:
                      const TextStyle(
                    color: AppColors
                        .textSecondary,
                  ),
                ),
              ],
            ),
          ),

          if (trailing != null)
            Text(
              trailing,

              style: TextStyle(
                color:
                    trailing ==
                            "Verified" ||
                        trailing ==
                            "Approved"
                    ? Colors.green
                    : Colors.orange,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildInfoRow(
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
          Expanded(
            flex: 2,

            child: Text(
              title,

              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            flex: 3,

            child: Text(
              value,
            ),
          ),
        ],
      ),
    );
  }
}