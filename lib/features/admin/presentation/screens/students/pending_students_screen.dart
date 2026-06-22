import 'package:flutter/material.dart';

import '../../../../../services/admin/admin_service.dart';

import '../../../../../theme/app_colors.dart';

import 'student_detail_screen.dart';

class PendingStudentsScreen extends StatefulWidget {
  const PendingStudentsScreen({super.key});

  @override
  State<PendingStudentsScreen> createState() => _PendingStudentsScreenState();
}

class _PendingStudentsScreenState extends State<PendingStudentsScreen> {
  List students = [];

  bool loading = true;

  bool actionLoading = false;

  @override
  void initState() {
    super.initState();

    fetchPendingStudents();
  }

  void showVerifyDialog(String studentId) {
    final amountController = TextEditingController();

    debugPrint("VERIFY DIALOG OPENED");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Approve Student"),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Allotted Amount",
            hintText: "Enter amount",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);

              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enter valid amount")),
                );
                return;
              }

              Navigator.pop(context);

              await verifyStudent(studentId, amount);
            },
            child: const Text("Approve"),
          ),
        ],
      ),
    );
  }

  /// =====================================
  /// FETCH PENDING
  /// =====================================

  Future<void> fetchPendingStudents() async {
    try {
      setState(() {
        loading = true;
      });

      final response = await AdminService.getStudents();

      final allStudents = response["data"] ?? [];

      students = allStudents
          .where((student) => student["verificationStatus"] != "APPROVED")
          .toList();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  /// =====================================
  /// VERIFY
  /// =====================================

  Future<void> verifyStudent(String id, double allottedAmount) async {
    try {
      setState(() {
        actionLoading = true;
      });

      await AdminService.verifyStudent(id, allottedAmount);

      await fetchPendingStudents();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Student verified successfully"),
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

  Color getStatusColor(String status) {
    switch (status) {
      case "REJECTED":
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Pending Students"),

        backgroundColor: AppColors.primary,

        foregroundColor: Colors.white,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
          ? const Center(child: Text("No pending students"))
          : ListView.builder(
              padding: const EdgeInsets.all(20),

              itemCount: students.length,

              itemBuilder: (_, index) {
                final student = students[index];

                final user = student["user"];

                final status = student["verificationStatus"] ?? "PENDING";

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,

                            backgroundColor: AppColors.primary,

                            child: Text(
                              user["fullName"][0].toUpperCase(),

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
                                  user["fullName"],

                                  style: const TextStyle(
                                    fontSize: 18,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(student["schoolName"] ?? "-"),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,

                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: getStatusColor(
                                status,
                              ).withValues(alpha: 0.1),

                              borderRadius: BorderRadius.circular(16),
                            ),

                            child: Text(
                              status,

                              style: TextStyle(
                                color: getStatusColor(status),

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: actionLoading
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => StudentDetailScreen(
                                            student: student,
                                          ),
                                        ),
                                      );
                                    },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),

                              child: const Text("View Details"),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: actionLoading
                                  ? null
                                  : () {
                                      debugPrint("VERIFY BUTTON CLICKED");
                                      showVerifyDialog(student["id"]);
                                    },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),

                              child: const Text("Approve"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
