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

  double totalExpense = 0;

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

      final response =
          await StudentService
              .getExpenses();

      expenses =
          response["data"]["expenses"] ??
              [];

      totalExpense =
          (response["data"]
                      ["totalExpense"] ??
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
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,

        elevation: 0,

        title: const Text(
          "My Expenses",

          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.push(
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
                /// SUMMARY CARD
                _buildSummaryCard(),

                /// EXPENSE LIST
                Expanded(
                  child:
                      expenses.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              onRefresh:
                                  loadExpenses,

                              child:
                                  ListView.builder(
                                padding:
                                    const EdgeInsets.all(
                                  16,
                                ),

                                itemCount:
                                    expenses
                                        .length,

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
          const EdgeInsets.all(
        16,
      ),

      padding:
          const EdgeInsets.all(
        22,
      ),

      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF0A1931),
            Color(0xFF13294B),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          24,
        ),
      ),

      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.all(
              14,
            ),

            decoration:
                BoxDecoration(
              color: Colors.white
                  .withValues(
                alpha: 0.15,
              ),

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child: const Icon(
              Icons
                  .account_balance_wallet,

              color: Colors.white,

              size: 34,
            ),
          ),

          const SizedBox(
            width: 18,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                const Text(
                  "Total Expenses",

                  style: TextStyle(
                    color:
                        Colors.white70,

                    fontSize: 14,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  "₹${totalExpense.toStringAsFixed(0)}",

                  style:
                      const TextStyle(
                    color:
                        Colors.white,

                    fontSize: 30,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
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