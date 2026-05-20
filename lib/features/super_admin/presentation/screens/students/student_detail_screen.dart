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

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        elevation: 0,

        backgroundColor:
            AppColors.background,

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
                          title:
                              achievement[
                                  "title"],

                          description:
                              achievement[
                                      "description"] ??
                                  "",

                          verified:
                              achievement[
                                      "verified"] ??
                                  false,
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
                          title:
                              expense[
                                  "title"],

                          amount:
                              expense[
                                      "amount"]
                                  .toString(),

                          approved:
                              expense[
                                      "approved"] ??
                                  false,
                        );
                      },
                    ),

                  const SizedBox(
                    height: 34,
                  ),

                  /// ACTIONS
                  Row(
                    children: [
                      Expanded(
                        child:
                            ElevatedButton(
                          onPressed:
                              verifyStudent,

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.green,

                            padding:
                                const EdgeInsets.symmetric(
                              vertical:
                                  16,
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
                            "Verify",
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 14,
                      ),

                      Expanded(
                        child:
                            ElevatedButton(
                          onPressed:
                              rejectStudent,

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.orange,

                            padding:
                                const EdgeInsets.symmetric(
                              vertical:
                                  16,
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

  Widget buildAchievementTile({
    required String title,
    required String description,
    required bool verified,
  }) {
    return buildEmptyCard(
      "$title\n$description",
    );
  }

  Widget buildExpenseTile({
    required String title,
    required String amount,
    required bool approved,
  }) {
    return buildEmptyCard(
      "$title • ₹$amount",
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