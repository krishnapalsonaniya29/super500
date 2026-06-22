import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';
import 'student_expenses_screen.dart';
import '../../../../../services/admin/admin_service.dart';
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
    
    final allottedAmount =
        double.tryParse(
              student["allottedAmount"]
                  ?.toString() ??
                  "0",
            ) ??
            0;

    final approvedExpenses =
        expenses.where((expense) {
      return expense["status"] ==
          "APPROVED";
    }).toList();

    double usedAmount = 0;

    for (final expense
        in approvedExpenses) {
      usedAmount +=
          double.tryParse(
                expense["amount"]
                    .toString(),
              ) ??
              0;
    }

    final remainingAmount =
        allottedAmount - usedAmount;

    final utilizationPercentage =
        allottedAmount > 0
            ? (usedAmount /
                    allottedAmount)
                .clamp(0.0, 1.0)
            : 0.0;

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

            /// SCHOLARSHIP FUND
            buildSectionTitle(
              "Scholarship Fund",
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  buildInfoRow(
                    "Allotted",
                    "₹${allottedAmount.toStringAsFixed(0)}",
                  ),

                  buildInfoRow(
                    "Used",
                    "₹${usedAmount.toStringAsFixed(0)}",
                  ),

                  buildInfoRow(
                    "Remaining",
                    "₹${remainingAmount.toStringAsFixed(0)}",
                  ),

                  const SizedBox(height: 16),

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10),
                    child:
                        LinearProgressIndicator(
                      value:
                          utilizationPercentage,
                      minHeight: 10,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${(utilizationPercentage * 100).toStringAsFixed(1)}% Fund Utilized",
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
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

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.receipt_long,
                        color: AppColors.primary,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          "${expenses.length} Expenses Submitted",
                          style:
                              const TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.visibility,
                      ),
                      label: const Text(
                        "View Expenses",
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                StudentExpensesScreen(
                              student: student,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
                buildAchievementCard(
              context,
              achievement,
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


  Widget buildAchievementCard(
  BuildContext context,
  Map<String, dynamic>
      achievement,
) {
  final status =
      achievement["status"] ??
      "PENDING";

  return Container(
    margin:
        const EdgeInsets.only(
      bottom: 16,
    ),

    padding:
        const EdgeInsets.all(
      16,
    ),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(
        20,
      ),
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        if (achievement[
                "proofImageUrl"] !=
            null)
          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
            child: GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding:
              const EdgeInsets.all(
            12,
          ),
          child: InteractiveViewer(
            child: Image.network(
              achievement[
                  "proofImageUrl"],
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  },
  child: Image.network(
    achievement[
        "proofImageUrl"],
    height: 220,
    width: double.infinity,
    fit: BoxFit.cover,
  ),
),
          ),

        const SizedBox(
          height: 12,
        ),

        Text(
          achievement["title"] ??
              "-",
          style:
              const TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 6,
        ),

        Text(
          achievement[
                  "description"] ??
              "-",
        ),

        const SizedBox(
          height: 12,
        ),

        Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(
                    status,
                  ).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: getStatusColor(
                      status,
                    ),
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const Spacer(),

              if (status == "PENDING") ...[
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await AdminService
                          .updateAchievementStatus(
                        achievementId:
                            achievement["id"],
                        status: "APPROVED",
                      );

                      achievement["status"] =
                          "APPROVED";

                      if (!context.mounted) return;

                      (context as Element)
                          .markNeedsBuild();

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Achievement approved",
                          ),
                        ),
                      );
                    } catch (e) {
                      debugPrint(
                        "Approve Error: $e",
                      );
                    }
                  },
                  child: const Text(
                    "Approve",
                  ),
                ),

                const SizedBox(width: 8),

                ElevatedButton(
                  onPressed: () async {
                    try {
                      await AdminService
                          .updateAchievementStatus(
                        achievementId:
                            achievement["id"],
                        status: "REJECTED",
                      );

                      achievement["status"] =
                          "REJECTED";

                      if (!context.mounted) return;

                      (context as Element)
                          .markNeedsBuild();

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Achievement rejected",
                          ),
                        ),
                      );
                    } catch (e) {
                      debugPrint(
                        "Reject Error: $e",
                      );
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red,
                  ),
                  child: const Text(
                    "Reject",
                  ),
                ),
              ],
            ],
          )
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