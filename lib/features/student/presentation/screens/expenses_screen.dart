// lib/features/student/presentation/screens/expenses_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../theme/app_colors.dart';
import '../../../../services/student/student_service.dart';
import 'add_expense_screen.dart';
class ExpensesScreen
    extends StatefulWidget {
  final Function(int index)
      onNavigate;
 
  const ExpensesScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<ExpensesScreen>
      createState() =>
          _ExpensesScreenState();
}

class _ExpensesScreenState
    extends State<ExpensesScreen> {
  bool isLoading = true;

 List expenses = [];

double allottedAmount = 0;
double approvedAmount = 0;
double pendingAmount = 0;
double rejectedAmount = 0;
double remainingAmount = 0;
double utilizationPercentage = 0;

  @override
  void initState() {
    super.initState();

    loadExpenses();
  }

  /// =====================================
  /// LOAD EXPENSES
  /// =====================================

  Future<void> loadExpenses() async {
  try {
    setState(() {
      isLoading = true;
    });

    final expenseResponse =
        await StudentService.getExpenses();

    final summaryResponse =
        await StudentService
            .getFinancialSummary();


debugPrint(
  "SUMMARY => $summaryResponse",
);
    expenses =
        expenseResponse["data"]
                ["expenses"] ??
            [];

    final summary =
        summaryResponse["data"];

    allottedAmount =
        (summary["allottedAmount"] ?? 0)
            .toDouble();

    approvedAmount =
        (summary["approvedAmount"] ?? 0)
            .toDouble();

    pendingAmount =
        (summary["pendingAmount"] ?? 0)
            .toDouble();

    rejectedAmount =
        (summary["rejectedAmount"] ?? 0)
            .toDouble();

    remainingAmount =
        (summary["remainingAmount"] ?? 0)
            .toDouble();

    utilizationPercentage =
        (summary[
                    "utilizationPercentage"] ??
                0)
            .toDouble();
  } catch (e) {
    debugPrint(
      "Expenses Error: $e",
    );
  }

  if (mounted) {
    setState(() {
      isLoading = false;
    });
  }
}

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.background,



    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const AddExpenseScreen(),
          ),
        );

        if (result == true) {
          loadExpenses();
        }
      },
      child: const Icon(Icons.add),
    ),

    body: isLoading
        ? const Center(
            child:
                CircularProgressIndicator(),
          )
        : Column(
            children: [
              /// SUPER500 HEADER
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  16,
                  36,
                  16,
                  20,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha:0.25),
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
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        "assets/images/app_logo2.png",
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(width: 18),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My Expenses",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            "Track and manage your approved expenses",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// SUMMARY CARD
              _buildSummaryCard(),

              /// EXPENSE LIST
              Expanded(
                child: expenses.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh:
                            loadExpenses,
                        child:
                            ListView.builder(
                          padding:
                              const EdgeInsets
                                  .all(16),
                          itemCount:
                              expenses.length,
                          itemBuilder:
                              (
                                context,
                                index,
                              ) {
                            final expense =
                                expenses[
                                    index];

                            return _buildExpenseCard(
                              expense,
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
  );
}

  /// =====================================
  /// SUMMARY CARD
  /// =====================================

Widget _buildSummaryCard() {
  return Container(
    margin:
        const EdgeInsets.all(16),

    padding:
        const EdgeInsets.all(20),

    decoration: BoxDecoration(
      gradient:
          const LinearGradient(
        colors: [
          Color(0xFF0A1931),
          Color(0xFF13294B),
        ],
      ),
      borderRadius:
          BorderRadius.circular(24),
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        const Text(
          "Financial Summary",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        _summaryRow(
          "Allotted",
          allottedAmount,
        ),

        _summaryRow(
          "Approved",
          approvedAmount,
        ),

        _summaryRow(
          "Pending",
          pendingAmount,
        ),

        _summaryRow(
          "Rejected",
          rejectedAmount,
        ),

        _summaryRow(
          "Remaining",
          remainingAmount,
        ),

        const SizedBox(height: 20),

        ClipRRect(
          borderRadius:
              BorderRadius.circular(10),

          child:
              LinearProgressIndicator(
            value:
                utilizationPercentage /
                    100,

            minHeight: 10,

            backgroundColor:
                Colors.white24,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "${utilizationPercentage.toStringAsFixed(0)}% Utilized",
          style:
              const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    ),
  );
}

Widget _summaryRow(
  String label,
  double amount,
) {
  return Padding(
    padding:
        const EdgeInsets.symmetric(
      vertical: 4,
    ),

    child: Row(
      mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,

      children: [
        Text(
          label,
          style:
              const TextStyle(
            color:
                Colors.white70,
          ),
        ),

        Text(
          "₹${amount.toStringAsFixed(0)}",
          style:
              const TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

  /// =====================================
  /// EXPENSE CARD
  /// =====================================

  Widget _buildExpenseCard(
    Map<String, dynamic>
        expense,
  ) {
    final createdAt =
        expense["createdAt"];

    return Container(
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
          20,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withValues(
              alpha: 0.05,
            ),

            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          /// HEADER
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.all(
                  12,
                ),

                decoration:
                    BoxDecoration(
                  color: Colors.red
                      .withValues(
                    alpha: 0.1,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),

                child: const Icon(
                  Icons
                      .currency_rupee,

                  color: Colors.red,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      expense[
                              "title"] ??
                          "Expense",

                      style:
                          const TextStyle(
                        fontSize: 17,

                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      expense[
                              "category"] ??
                          "General",

                      style: TextStyle(
                        color: Colors
                            .grey[700],
                      ),
                    ),
                    const SizedBox(height: 6),

                    _buildStatusChip(
                      expense["status"] ?? "PENDING",
                    ),
                  ],
                ),
              ),

              Text(
                "₹${expense["amount"] ?? 0}",

                style:
                    const TextStyle(
                  color: Colors.red,

                  fontSize: 18,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          /// DESCRIPTION
          Text(
            expense["description"] ??
                "No description available",

            style: TextStyle(
              color:
                  Colors.grey[800],

              height: 1.5,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          /// DATE
          Row(
            children: [
              const Icon(
                Icons.calendar_month,
                size: 18,
                color: Colors.blue,
              ),

              const SizedBox(
                width: 8,
              ),

              Text(
                createdAt != null
                    ? DateFormat(
                        "dd MMM yyyy",
                      ).format(
                        DateTime.parse(
                          createdAt,
                        ),
                      )
                    : "No Date",

                style: TextStyle(
                  color:
                      Colors.grey[700],

                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
  String status,
) {
  Color color;

  switch (status) {
    case "APPROVED":
      color = Colors.green;
      break;

    case "REJECTED":
      color = Colors.red;
      break;

    default:
      color = Colors.orange;
  }

  return Container(
    padding:
        const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 4,
    ),

    decoration: BoxDecoration(
      color:
          color.withValues(
        alpha: 0.15,
      ),
      borderRadius:
          BorderRadius.circular(20),
    ),

    child: Text(
      status,
      style: TextStyle(
        color: color,
        fontWeight:
            FontWeight.w600,
      ),
    ),
  );
}

  /// =====================================
  /// EMPTY STATE
  /// =====================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          30,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              Icons
                  .account_balance_wallet,
              size: 90,
              color: Colors.grey[400],
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              "No Expenses Found",

              style: TextStyle(
                fontSize: 22,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              "Your expense records will appear here.",

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                color:
                    Colors.grey[700],

                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}