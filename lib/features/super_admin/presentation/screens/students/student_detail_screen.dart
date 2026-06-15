import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../services/super_admin/super_admin_service.dart';
import '../../../../../theme/app_colors.dart';

class StudentDetailScreen
    extends StatefulWidget {
  final Map<String, dynamic> student;

  const StudentDetailScreen({
    super.key,
    required this.student,
  });

  @override
  State<StudentDetailScreen>
      createState() =>
          _StudentDetailScreenState();
}

class _StudentDetailScreenState
    extends State<
        StudentDetailScreen> {
  bool loading = false;

  late Map<String, dynamic>
      student;

  @override
  void initState() { 
    super.initState();

    student = widget.student;
    print(student["expenses"]);
  }

  Future<void> verifyStudent()
  async {
    try {
      setState(() {
        loading = true;
      });

      await SuperAdminService
          .verifyStudent(
        student["id"],
      );

      setState(() {
        student[
                "verificationStatus"] =
            "APPROVED";
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Student verified successfully",
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> suspendUser()
  async {
    try {
      setState(() {
        loading = true;
      });

      await SuperAdminService
          .suspendUser(
        student["user"]["id"],
      );

      setState(() {
        student["user"]
            ["isActive"] = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "User suspended",
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> rejectStudent()
  async {
    final controller =
        TextEditingController();

    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Reject Student",
          ),

          content: TextField(
            controller: controller,

            decoration:
                const InputDecoration(
              hintText:
                  "Reason",
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },

              child:
                  const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(
                  context,
                );

                try {
                  setState(() {
                    loading = true;
                  });

                  await SuperAdminService
                      .rejectStudent(
                    student["id"],
                    controller.text,
                  );

                  setState(() {
                    student[
                            "verificationStatus"] =
                        "REJECTED";
                  });

                  if (!mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Student rejected",
                      ),
                    ),
                  );
                } catch (e) {
                  debugPrint(
                    e.toString(),
                  );
                } finally {
                  setState(() {
                    loading =
                        false;
                  });
                }
              },

              child:
                  const Text(
                "Reject",
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void>
    updateScholarshipAmount() async {
  final controller =
      TextEditingController(
    text: student["allottedAmount"]
        .toString(),
  );

  showDialog(
    context: context,

    builder: (_) {
      return AlertDialog(
        title: const Text(
          "Update Scholarship Amount",
        ),

        content: TextField(
          controller: controller,

          keyboardType:
              TextInputType.number,

          decoration:
              const InputDecoration(
            hintText:
                "Enter amount",
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
              );
            },

            child:
                const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () async {
              try {
                final amount =
                    double.parse(
                  controller.text,
                );

                await SuperAdminService
                    .updateScholarshipAmount(
                  studentId:
                      student["id"],

                  amount: amount,
                );

                setState(() {
                  student[
                          "allottedAmount"] =
                      amount;
                });

                if (!mounted) {
                  return;
                }

                Navigator.pop(
                  context,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Scholarship updated",
                    ),
                  ),
                );
              } catch (e) {
                debugPrint(
                  e.toString(),
                );
              }
            },

            child:
                const Text(
              "Save",
            ),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final user =
        student["user"];

    final documents =
        student["documents"] ??
            [];

    final achievements =
        student[
                "achievements"] ??
            [];

    final expenses =
        student["expenses"] ??
            [];

    final reports =
        student["reports"] ?? [];

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
        elevation: 0,

        backgroundColor: AppColors.primary,

        title: const Text(
          "Student Details",
        ),
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.all(
                20,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  /// PROFILE
                  Container(
                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets.all(
                      24,
                    ),

                    decoration:
                        BoxDecoration(
                      gradient:
                          const LinearGradient(
                        colors: [
                          Color(
                            0xFF0A1931,
                          ),

                          Color(
                            0xFF132D46,
                          ),
                        ],
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                    ),

                    child: Column(
                      children: [
                        CircleAvatar(
                          radius:
                              50,

                          backgroundColor:
                              Colors.white,

                          backgroundImage:
                              getProfileImage(
                                        documents,
                                      ) !=
                                      null
                                  ? NetworkImage(
                                      getProfileImage(
                                        documents,
                                      )!,
                                    )
                                  : null,

                          child:
                              getProfileImage(
                                        documents,
                                      ) ==
                                      null
                                  ? const Icon(
                                      Icons
                                          .person,

                                      size:
                                          50,

                                      color:
                                          AppColors.primary,
                                    )
                                  : null,
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        Text(
                          user["fullName"] ??
                              "",

                          style:
                              const TextStyle(
                            color:
                                Colors.white,

                            fontSize:
                                28,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          user["phone"] ??
                              "",

                          style:
                              const TextStyle(
                            color: Colors
                                .white70,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal:
                                16,

                            vertical:
                                10,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                getVerificationColor(
                              student[
                                  "verificationStatus"],
                            ),

                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),
                          ),

                          child: Text(
                            student[
                                    "verificationStatus"] ??
                                "PENDING",

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  buildSectionTitle(
                    "Personal Details",
                  ),
                  const SizedBox(
                    height: 28,
                  ),

                  buildSectionTitle(
                    "Scholarship Analytics",
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        buildDetailTile(
                          "Allotted Amount",
                          "₹${allottedAmount.toStringAsFixed(0)}",
                        ),

                        buildDetailTile(
                          "Used Amount",
                          "₹${usedAmount.toStringAsFixed(0)}",
                        ),

                        buildDetailTile(
                          "Remaining Amount",
                          "₹${remainingAmount.toStringAsFixed(0)}",
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                          child:
                              LinearProgressIndicator(
                            value:
                                utilizationPercentage,
                            minHeight: 12,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 16,
                        ),

                        SizedBox(
                          width: double.infinity,

                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.currency_rupee,
                            ),

                            label: const Text(
                              "Update Scholarship Amount",
                            ),

                            onPressed:
                                updateScholarshipAmount,
                          ),
                        ),

                        Text(
                          "${(utilizationPercentage * 100).toStringAsFixed(1)}% Utilized",

                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  buildDetailTile(
                    "Father Name",
                    student[
                        "fatherName"],
                  ),

                  buildDetailTile(
                    "Gender",
                    student["gender"],
                  ),

                  buildDetailTile(
                    "District",
                    student[
                        "district"],
                  ),

                  buildDetailTile(
                    "School",
                    student[
                        "schoolName"],
                  ),

                  buildDetailTile(
                    "Current Class",
                    student[
                        "currentClass"],
                  ),

                  buildDetailTile(
                    "10th Marks",
                    "${student["marks10th"] ?? 0}%",
                  ),

                  buildDetailTile(
                    "Samagra ID",
                    student[
                        "samagraId"],
                  ),

                  buildDetailTile(
                    "APAAR ID",
                    student[
                        "apaarId"],
                  ),

                  buildDetailTile(
                    "Address",
                    student[
                        "address"],
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                const SizedBox(
                  height: 28,
                ),

                buildSectionTitle(
                  "Student Reports",
                ),

                const SizedBox(
                  height: 16,
                ),

                if (reports.isEmpty)
                  buildEmptyCard(
                    "No reports submitted yet",
                  )
                else
                  ...reports.map(
                    (report) {
                      return buildReportCard(
                        report,
                      );
                    },
                  ),

                  /// DOCUMENTS
                  buildSectionTitle(
                    "Documents",
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  if (documents
                      .isEmpty)
                    buildEmptyCard(
                      "No documents uploaded",
                    )
                  else
                    ...documents.map(
                      (doc) {
                        return buildDocumentTile(
                          title:
                              formatDocumentType(
                            doc[
                                "documentType"],
                          ),

                          verified:
                              doc["verified"] ??
                                  false,

                          onTap:
                              () async {
                            final uri =
                                Uri.parse(
                              doc[
                                  "documentUrl"],
                            );

                            await launchUrl(
                              uri,

                              mode:
                                  LaunchMode.externalApplication,
                            );
                          },
                        );
                      },
                    ),

                  const SizedBox(
                    height: 28,
                  ),

                  /// ACHIEVEMENTS
                  buildSectionTitle(
                    "Achievements",
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  if (achievements
                      .isEmpty)
                    buildEmptyCard(
                      "No achievements added",
                    )
                  else
                    ...achievements.map(
                      (achievement) {
                        return buildAchievementTile(
                          achievement,
                        );
                      },
                    ),

                  const SizedBox(
                    height: 28,
                  ),

                  /// EXPENSES
                  buildSectionTitle(
                    "Expenses",
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  if (expenses
                      .isEmpty)
                    buildEmptyCard(
                      "No expenses found",
                    )
                  else
                   ...expenses.map(
                    (expense) {
                      return buildExpenseTile(
                        expense,
                      );
                    },
                  ),

                  const SizedBox(
                    height: 34,
                  ),

                  /// ACTIONS
                  if (student["verificationStatus"] !=
                    "APPROVED")
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: verifyStudent,

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.green,

                            foregroundColor:
                                Colors.white,

                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 16,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),
                            ),
                          ),

                          child: const Text(
                            "Verify",
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 14,
                      ),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: rejectStudent,

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.orange,

                            foregroundColor:
                                Colors.white,

                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 16,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),
                            ),
                          ),

                          child: const Text(
                            "Reject",
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  SizedBox(
                    width:
                        double.infinity,

                    child:
                        ElevatedButton(
                      onPressed:
                          suspendUser,

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red,

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 16,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),

                      child:
                          const Text(
                        "Suspend User",
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildSectionTitle(
    String title,
  ) {
    return Text(
      title,

      style: const TextStyle(
        fontSize: 22,

        fontWeight:
            FontWeight.bold,
      ),
    );
  }

  Widget buildDetailTile(
    String title,
    dynamic value,
  ) {
    return Container(
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
            child: Text(
              title,
            ),
          ),

          Expanded(
            child: Text(
              value?.toString() ??
                  "-",

              textAlign:
                  TextAlign.end,

              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget buildReportCard(
  Map<String, dynamic> report,
) {
  return Container(
    width: double.infinity,

    margin:
        const EdgeInsets.only(
      bottom: 16,
    ),

    padding:
        const EdgeInsets.all(
      18,
    ),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(
        22,
      ),
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.all(
                10,
              ),

              decoration:
                  BoxDecoration(
                color: Colors.blue
                    .withValues(
                  alpha: 0.1,
                ),

                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),

              child: const Icon(
                Icons.description,
                color: Colors.blue,
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: Text(
                report["reportType"] ??
                    "Report",

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

        const SizedBox(
          height: 16,
        ),

        if (report["quarter"] != null)
          Text(
            "Quarter ${report["quarter"]}",
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),

        if (report["year"] != null)
          Text(
            "Year ${report["year"]}",
          ),

        const SizedBox(
          height: 12,
        ),

        Text(
          report["content"] ??
              "",
        ),

        const SizedBox(
          height: 12,
        ),

        Text(
          "Submitted: ${report["createdAt"]?.toString().substring(0, 10) ?? "-"}",

          style:
              const TextStyle(
            color: AppColors
                .textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

  Widget buildDocumentTile({
    required String title,
    required bool verified,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin:
            const EdgeInsets.only(
          bottom: 14,
        ),

        padding:
            const EdgeInsets.all(
          18,
        ),

        decoration:
            BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            22,
          ),
        ),

        child: Row(
          children: [
            const Icon(
              Icons.description,
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(
              child: Text(
                title,
              ),
            ),

            Icon(
              verified
                  ? Icons.verified
                  : Icons.pending,

              color: verified
                  ? Colors.green
                  : Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAchievementTile(
    Map<String, dynamic> achievement,
  ) {
    final status =
        achievement["status"] ??
        "PENDING";

    Color statusColor;

    switch (status) {
      case "APPROVED":
        statusColor = Colors.green;
        break;

      case "REJECTED":
        statusColor = Colors.red;
        break;

      default:
        statusColor = Colors.orange;
    }

    return Container(
      width: double.infinity,

      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: Colors.amber,
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Text(
                  achievement["title"] ??
                      "-",

                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      statusColor
                          .withValues(
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
                        statusColor,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          Text(
            achievement[
                    "description"] ??
                "",
          ),

          const SizedBox(
            height: 16,
          ),

          if (achievement[
                  "proofImageUrl"] !=
              null)
            OutlinedButton.icon(
              icon: const Icon(
                Icons.image,
              ),

              label: const Text(
                "View Proof",
              ),

              onPressed: () {
                showDialog(
                  context: context,

                  builder: (_) {
                    return Dialog(
                      insetPadding:
                          const EdgeInsets.all(
                        16,
                      ),

                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min,

                        children: [
                          AppBar(
                            title:
                                const Text(
                              "Achievement Proof",
                            ),

                            automaticallyImplyLeading:
                                false,

                            actions: [
                              IconButton(
                                icon:
                                    const Icon(
                                  Icons.close,
                                ),

                                onPressed:
                                    () {
                                  Navigator.pop(
                                    context,
                                  );
                                },
                              ),
                            ],
                          ),

                          Flexible(
                            child:
                                InteractiveViewer(
                              child:
                                  Image.network(
                                achievement[
                                    "proofImageUrl"],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

          const SizedBox(
            height: 12,
          ),

          Text(
            "Submitted: ${achievement["createdAt"]?.toString().substring(0, 10) ?? "-"}",

            style:
                const TextStyle(
              color: AppColors
                  .textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

Widget buildExpenseTile(
  Map<String, dynamic> expense,
) {
  final status =
      expense["status"] ??
      "PENDING";

  Color statusColor;

  switch (status) {
    case "APPROVED":
      statusColor = Colors.green;
      break;

    case "REJECTED":
      statusColor = Colors.red;
      break;

    default:
      statusColor = Colors.orange;
  }

  return Container(
    width: double.infinity,

    margin:
        const EdgeInsets.only(
      bottom: 16,
    ),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(
        22,
      ),
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        

        Padding(
          padding:
              const EdgeInsets.all(
            18,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      expense["title"] ??
                          "-",

                      style:
                          const TextStyle(
                        fontSize: 18,

                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          statusColor
                              .withValues(
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
                            statusColor,

                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),

              Text(
                "₹ ${expense["amount"]}",
                style:
                    const TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),

              if (expense["receiptUrl"] != null)
                OutlinedButton.icon(
                  icon: const Icon(
                    Icons.receipt_long,
                  ),

                  label: const Text(
                    "View Receipt",
                  ),

                  onPressed: () {
                    showDialog(
                      context: context,

                      builder: (_) {
                        return Dialog(
                          insetPadding:
                              const EdgeInsets.all(
                            16,
                          ),

                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [
                              AppBar(
                                title: const Text(
                                  "Receipt",
                                ),

                                automaticallyImplyLeading:
                                    false,

                                actions: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                    ),

                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                  ),
                                ],
                              ),

                              Flexible(
                                child:
                                    InteractiveViewer(
                                  child:
                                      Image.network(
                                    expense[
                                        "receiptUrl"],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

              const SizedBox(
                height: 12,
              ),

              if (expense[
                      "expenseCategory"] !=
                  null)
                Text(
                  "Category: ${expense["expenseCategory"]}",
                ),

              if (expense[
                      "description"] !=
                  null)
                Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 8,
                  ),

                  child: Text(
                    expense[
                        "description"],
                  ),
                ),

              if (expense["remarks"] !=
                  null)
                Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 8,
                  ),

                  child: Text(
                    "Remarks: ${expense["remarks"]}",
                    style:
                        const TextStyle(
                      color:
                          Colors.red,
                    ),
                  ),
                ),

              const SizedBox(
                height: 12,
              ),

              Text(
                "Submitted: ${expense["createdAt"]?.toString().substring(0, 10) ?? "-"}",

                style:
                    const TextStyle(
                  color: AppColors
                      .textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
  Widget buildEmptyCard(
    String text,
  ) {
    return Container(
      width: double.infinity,

      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(
        20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),

      child: Text(text),
    );
  }

  String? getProfileImage(
    List documents,
  ) {
    try {
      final photo =
          documents.firstWhere(
        (doc) =>
            doc["documentType"] ==
            "PHOTO",
      );

      return photo["documentUrl"];
    } catch (e) {
      return null;
    }
  }

  Color getVerificationColor(
    String? status,
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

  String formatDocumentType(
    String type,
  ) {
    return type.replaceAll(
      "_",
      " ",
    );
  }
}