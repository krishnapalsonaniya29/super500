import 'package:flutter/material.dart';

import '../../../../../services/admin/admin_service.dart';
import '../../../../../theme/app_colors.dart';

class StudentExpensesScreen extends StatefulWidget {
  final Map<String, dynamic> student;

  const StudentExpensesScreen({
    super.key,
    required this.student,
  });

  @override
  State<StudentExpensesScreen> createState() =>
      _StudentExpensesScreenState();
}

class _StudentExpensesScreenState
    extends State<StudentExpensesScreen> {
  bool isLoading = false;

  Future<void> approveExpense(
    String expenseId,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });

      await AdminService.approveExpense(
        id: expenseId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Expense approved successfully",
          ),
        ),
      );

      setState(() {
        final expenses =
            widget.student["expenses"];

        final index =
            expenses.indexWhere(
          (e) => e["id"] == expenseId,
        );

        if (index != -1) {
          expenses[index]["status"] =
              "APPROVED";
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> rejectExpense(
    String expenseId,
  ) async {
    final controller =
        TextEditingController();

    final reason =
        await showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Reject Expense",
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
              onPressed: () =>
                  Navigator.pop(
                context,
              ),
              child:
                  const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                controller.text,
              ),
              child:
                  const Text("Reject"),
            ),
          ],
        );
      },
    );

    if (reason == null ||
        reason.trim().isEmpty) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await AdminService.rejectExpense(
        id: expenseId,
        remarks: reason,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Expense rejected",
          ),
        ),
      );

      setState(() {
        final expenses =
            widget.student["expenses"];

        final index =
            expenses.indexWhere(
          (e) => e["id"] == expenseId,
        );

        if (index != -1) {
          expenses[index]["status"] =
              "REJECTED";

          expenses[index]["remarks"] =
              reason;
        }
      });
    }catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
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
    final user =
        widget.student["user"];

    final expenses =
        widget.student["expenses"] ??
            [];

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title: Text(
          "${user["fullName"]} Expenses",
        ),
        backgroundColor:
            AppColors.primary,
        foregroundColor:
            Colors.white,
      ),

      body: expenses.isEmpty
          ? const Center(
              child: Text(
                "No expenses submitted",
              ),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.all(
                16,
              ),
              itemCount:
                  expenses.length,
              itemBuilder:
                  (context, index) {
                final expense =
                    expenses[index];

                final status =
                    expense["status"] ??
                        "PENDING";

                return Container(
                  margin:
                      const EdgeInsets.only(
                    bottom: 20,
                  ),

                  padding:
                      const EdgeInsets.all(
                    18,
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
                                  "Expense",
                              style:
                                  const TextStyle(
                                fontSize:
                                    18,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                          Text(
                            "₹ ${expense["amount"]}",
                            style:
                                const TextStyle(
                              fontSize:
                                  18,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        "Category: ${expense["expenseCategory"] ?? "-"}",
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        expense["description"] ??
                            "No description",
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      if (expense[
                              "receiptUrl"] !=
                          null)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context:
                                  context,
                              builder:
                                  (_) =>
                                      Dialog(
                                child:
                                    InteractiveViewer(
                                  child:
                                      Image.network(
                                    expense[
                                        "receiptUrl"],
                                  ),
                                ),
                              ),
                            );
                          },
                          child:
                              ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),
                            child:
                                Image.network(
                              expense[
                                  "receiptUrl"],
                              width:
                                  double.infinity,
                              height:
                                  220,
                              fit: BoxFit
                                  .cover,
                            ),
                          ),
                        ),

                      const SizedBox(
                        height: 16,
                      ),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal:
                              12,
                          vertical: 8,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              getStatusColor(
                            status,
                          ).withValues(
                            alpha:
                                0.12,
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
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),

                      if (expense[
                              "remarks"] !=
                          null)
                        Padding(
                          padding:
                              const EdgeInsets.only(
                            top: 12,
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

                      if (status ==
                          "PENDING")
                        Padding(
                          padding:
                              const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child:
                                    ElevatedButton(
                                  onPressed:
                                      isLoading
                                          ? null
                                          : () => approveExpense(
                                                expense[
                                                    "id"],
                                              ),
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.green,
                                  ),
                                  child:
                                      const Text(
                                    "Approve",
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width:
                                    12,
                              ),

                              Expanded(
                                child:
                                    ElevatedButton(
                                  onPressed:
                                      isLoading
                                          ? null
                                          : () => rejectExpense(
                                                expense[
                                                    "id"],
                                              ),
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
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}