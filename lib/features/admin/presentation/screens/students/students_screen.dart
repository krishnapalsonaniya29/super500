import 'package:flutter/material.dart';

import '../../../../../services/admin/admin_service.dart';

import '../../../../../theme/app_colors.dart';

import 'student_detail_screen.dart';
import 'student_documents_screen.dart';
import 'assign_mentor_screen.dart';
import 'pending_students_screen.dart';

class StudentsScreen
    extends StatefulWidget {
  final Function(int index)
      onNavigate;

  const StudentsScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<StudentsScreen>
      createState() =>
          _StudentsScreenState();
}

class _StudentsScreenState
    extends State<
        StudentsScreen> {
  List students = [];

  List filteredStudents = [];

  bool loading = true;

  bool actionLoading = false;

  String searchQuery = "";

  String? errorMessage;

  final searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchStudents();
  }


/// =====================================
/// VERIFY DIALOG
///  =====================================
void showVerifyDialog(
  String studentId,
) {
  final amountController =
      TextEditingController();
  debugPrint("VERIFY DIALOG OPENED");
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text(
        "Verify Student",
      ),
      content: TextField(
        controller: amountController,
        keyboardType:
            TextInputType.number,
        decoration:
            const InputDecoration(
          labelText:
              "Allotted Amount",
          hintText:
              "Enter amount",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final amount =
                double.tryParse(
              amountController.text,
            );

            if (amount == null ||
                amount <= 0) {
              ScaffoldMessenger.of(
                      context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    "Enter valid amount",
                  ),
                ),
              );
              return;
            }

            Navigator.pop(context);

            await verifyStudent(
              studentId,
              amount,
            );
          },
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                Colors.green,
          ),
          child: const Text(
            "Verify",
          ),
        ),
      ],
    ),
  );
}
  /// =====================================
  /// FETCH STUDENTS
  /// =====================================

  Future<void> fetchStudents() async {
    try {
      setState(() {
        loading = true;
        errorMessage = null;
      });

      final response =
          await AdminService
              .getStudents();

      students =
          response["data"] ?? [];

      applySearch();
    } catch (e) {
      debugPrint(e.toString());

      errorMessage =
          "Failed to load students";
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  /// =====================================
  /// DEACTIVATE STUDENT
  /// =====================================
void showDeactivateDialog(
  String studentId,
  String studentName,
) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text(
        "Deactivate Student",
      ),
      content: Text(
        "Deactivate $studentName?\n\nThe student will lose access until approved again.",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);

            await deactivateStudent(
              studentId,
            );
          },
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                Colors.red,
          ),
          child: const Text(
            "Deactivate",
          ),
        ),
      ],
    ),
  );
}
  /// =====================================
  /// SEARCH
  /// =====================================

  void applySearch() {
    filteredStudents =
        students.where((student) {
      final user = student["user"];

      final name =
          (user["fullName"] ?? "")
              .toString()
              .toLowerCase();

      final phone =
          (user["phone"] ?? "")
              .toString();

      return name.contains(
            searchQuery.toLowerCase(),
          ) ||
          phone.contains(
            searchQuery,
          );
    }).toList();

    setState(() {});
  }

  /// =====================================
  /// VERIFY
  /// =====================================

Future<void> verifyStudent(
  String id,
  double allottedAmount,
) async {
  try {
    setState(() {
      actionLoading = true;
    });

    await AdminService.verifyStudent(
      id,
      allottedAmount,
    );

    await fetchStudents();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Student verified successfully",
        ),
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  } finally {
    if (mounted) {
      setState(() {
        actionLoading = false;
      });
    }
  }
}

  /// =====================================
  /// REJECT
  /// =====================================

  Future<void> rejectStudent({
    required String id,
    required String reason,
  }) async {
    try {
      setState(() {
        actionLoading = true;
      });

      await AdminService
          .rejectStudent(
        id: id,
        reason: reason,
      );

      await fetchStudents();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.orange,

          content: Text(
            "Student rejected",
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          actionLoading = false;
        });
      }
    }
  }


/// =========
/// Delete Student
/// ===========================
Future<void> deactivateStudent(
  String id,
) async {
  try {
    setState(() {
      actionLoading = true;
    });

    await AdminService
        .deactivateStudent(id);

    await fetchStudents();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        backgroundColor:
            Colors.orange,
        content: Text(
          "Student deactivated",
        ),
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  } finally {
    if (mounted) {
      setState(() {
        actionLoading = false;
      });
    }
  }
}
  /// =====================================
  /// REJECTION DIALOG
  /// =====================================

  void showRejectDialog(
    String id,
  ) {
    final controller =
        TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
        title:
            const Text(
          "Reject Student",
        ),

        content: TextField(
          controller: controller,

          maxLines: 3,

          decoration:
              const InputDecoration(
            hintText:
                "Enter rejection reason",
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
                const Text(
              "Cancel",
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              Navigator.pop(
                context,
              );

              await rejectStudent(
                id: id,
                reason:
                    controller.text,
              );
            },

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.red,
            ),

            child:
                const Text(
              "Reject",
            ),
          ),
        ],
      ),
    );
  }





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
    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : RefreshIndicator(
              onRefresh:
                  fetchStudents,

              child: ListView(
                padding:
                    const EdgeInsets.all(
                  20,
                ),

                children: [
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

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "District Students",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "${filteredStudents.length} students available for management",
                                style: const TextStyle(
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
                  

                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,

                    height: 54,

                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    const PendingStudentsScreen(),
                          ),
                        );

                        fetchStudents();
                      },

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:AppColors.primary,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),

                      icon: const Icon(
                        Icons.pending_actions,
                      ),

                      label: const Text(
                        "Pending Approval Students",

                        style: TextStyle(
                          fontSize: 16,

                          fontWeight:
                              FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  
                  Text(
                    "${filteredStudents.length} students found",

                    style:
                        const TextStyle(
                      color: AppColors
                          .textSecondary,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  /// SEARCH
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      searchQuery = value;
                      applySearch();
                    },
                    decoration: InputDecoration(
                      hintText: "Search by name or phone",
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  /// STUDENTS
                  
                  ...filteredStudents.map(
                    (student) {
                      final user =
                          student["user"];

                      final status =
                          student[
                                  "verificationStatus"] ??
                              "PENDING";

                      return Container(
                        margin:
                            const EdgeInsets.only(
                          bottom: 20,
                        ),

                        padding:
                            const EdgeInsets.all(
                          20,
                        ),
                      
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withValues(
                                alpha: 0.05,
                              ),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [
                            /// TOP
                            Row(
                              children: [
                                CircleAvatar(
                                  radius:
                                      28,

                                  backgroundColor:
                                      AppColors.primary,

                                  child: Text(
                                    user["fullName"][0]
                                        .toUpperCase(),

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 14,
                                ),

                                Expanded(
                                  child:
                                      Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        user[
                                            "fullName"],

                                        style:
                                            const TextStyle(
                                          fontSize:
                                              18,

                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            6,
                                      ),

                                      Text(
                                        student[
                                                "schoolName"] ??
                                            "-",
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal:
                                        12,

                                    vertical:
                                        6,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        getStatusColor(
                                      status,
                                    ).withValues(
                                      alpha:
                                          0.1,
                                    ),

                                    borderRadius:
                                        BorderRadius.circular(
                                      16,
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
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            buildInfoRow(
                              icon:
                                  Icons.phone,

                              title:
                                  "Phone",

                              value:
                                  user["phone"] ??
                                      "-",
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            buildInfoRow(
                              icon:
                                  Icons.school,

                              title:
                                  "Class",

                              value:
                                  student["currentClass"] ??
                                      "-",
                            ),

                            const SizedBox(
                              height: 24,
                            ),

                            /// ACTIONS
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,

                              children: [
                                actionButton(
                                  title:
                                      "Details",

                                  color:
                                      const Color.fromARGB(255, 1, 230, 134),

                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                StudentDetailScreen(
                                          student:
                                              student,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                actionButton(
                                  title:
                                      "Documents",

                                  color:
                                     const Color.fromARGB(255, 1, 230, 134),

                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                StudentDocumentsScreen(
                                          student:
                                              student,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                actionButton(
                                  title:
                                      "Assign Mentor",

                                  color:
                                      const Color.fromARGB(255, 1, 230, 134),

                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                AssignMentorScreen(
                                          student:
                                              student,
                                        ),
                                      ),
                                    );

                                    fetchStudents();
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            if (status == "PENDING")
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: actionLoading
                                      ? null
                                      : () => showVerifyDialog(
                                            student["id"],
                                          ),
                                    icon: const Icon(
                                      Icons.check_circle,
                                    ),
                                    label: const Text(
                                      "Verify",
                                    ),
                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.green,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: actionLoading
                                        ? null
                                        : () => showRejectDialog(
                                              student["id"],
                                            ),
                                    icon: const Icon(
                                      Icons.cancel,
                                    ),
                                    label: const Text(
                                      "Reject",
                                    ),
                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            )

                          else if (status == "APPROVED")
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: actionLoading
                                    ? null
                                    : () => showDeactivateDialog(
                                          student["id"],
                                          user["fullName"],
                                        ),
                                icon: const Icon(
                                  Icons.block,
                                ),
                                label: const Text(
                                  "Deactivate Student",
                                  style : TextStyle(color: Colors.white),
                                ),
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 82, 82),
                                ),
                              ),
                            )

                          else if (status == "REJECTED")
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: actionLoading
                                  ? null
                                  : () => showVerifyDialog(
                                        student["id"],
                                      ),
                                icon: const Icon(
                                  Icons.refresh,
                                ),
                                label: const Text(
                                  "Reactivate Student",
                                ),
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.green,
                                ),
                              ),
                            )
                            else
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    showDeactivateDialog(
                                      student["id"],
                                      user["fullName"],
                                    );
                                  },

                                  icon: const Icon(
                                    Icons.block,
                                  ),

                                  label: const Text(
                                    "Deactivate Student",
                                  ),
                                  
                                  
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.red.shade700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
    );
  }

Widget actionButton({
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

  Widget buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color:
              AppColors.primary,
        ),

        const SizedBox(
          width: 10,
        ),

        Text(
          "$title: ",

          style:
              const TextStyle(
                
            fontWeight:
                FontWeight.bold,

          ),
        ),

        Expanded(
          child: Text(
            value,
          ),
        ),
      ],
    );
  }
}