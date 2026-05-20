import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';
import '../../../../../services/auth/auth_service.dart';

class ExpensesScreen extends StatefulWidget {
  final Function(int index) onNavigate;

  const ExpensesScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<ExpensesScreen> createState() =>
      _ExpensesScreenState();
}

class _ExpensesScreenState
    extends State<ExpensesScreen> {
  Map<String, dynamic>? userData;

  List expenses = [];

  bool loading = true;

  /// DEMO SCHOLARSHIP DATA
  double totalScholarship =
      120000;

  double disbursedAmount =
      75000;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await AuthService.getMe();

      final data = response["data"];

      final fetchedExpenses =
          data["studentProfile"]
                  ?["expenses"] ??
              [];

      setState(() {
        userData = data;

        expenses = fetchedExpenses;
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  double get totalExpenses {
    double total = 0;

    for (var expense in expenses) {
      total +=
          (expense["amount"] ?? 0)
              .toDouble();
    }

    return total;
  }

  double get availableBalance {
    return disbursedAmount -
        totalExpenses;
  }

  void showAddExpenseDialog() {
    final titleController =
        TextEditingController();

    final amountController =
        TextEditingController();

    final descriptionController =
        TextEditingController();

    String selectedCategory =
        "BOOKS";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),

      builder: (_) {
        return StatefulBuilder(
          builder:
              (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,

                bottom:
                    MediaQuery.of(
                              context,
                            )
                            .viewInsets
                            .bottom +
                        24,
              ),

              child:
                  SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    const Text(
                      "Add Expense",

                      style: TextStyle(
                        fontSize: 26,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    TextField(
                      controller:
                          titleController,

                      decoration:
                          InputDecoration(
                        labelText:
                            "Expense Title",

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    TextField(
                      controller:
                          amountController,

                      keyboardType:
                          TextInputType
                              .number,

                      decoration:
                          InputDecoration(
                        labelText:
                            "Amount",

                        prefixText:
                            "₹ ",

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      items: const [
                        DropdownMenuItem(
                          value: "BOOKS",

                          child: Text(
                            "Books",
                          ),
                        ),

                        DropdownMenuItem(
                          value:
                              "TRAVEL",

                          child: Text(
                            "Travel",
                          ),
                        ),

                        DropdownMenuItem(
                          value:
                              "EXAM_FEES",

                          child: Text(
                            "Exam Fees",
                          ),
                        ),

                        DropdownMenuItem(
                          value:
                              "HOSTEL",

                          child: Text(
                            "Hostel",
                          ),
                        ),

                        DropdownMenuItem(
                          value:
                              "OTHER",

                          child: Text(
                            "Other",
                          ),
                        ),
                      ],

                      onChanged: (value) {
                        setModalState(() {
                          selectedCategory =
                              value!;
                        });
                      },

                      decoration:
                          InputDecoration(
                        labelText:
                            "Expense Category",

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    TextField(
                      controller:
                          descriptionController,

                      maxLines: 4,

                      decoration:
                          InputDecoration(
                        labelText:
                            "Description",

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Container(
                      padding:
                          const EdgeInsets.all(
                        16,
                      ),

                      decoration:
                          BoxDecoration(
                        color: AppColors
                            .primary
                            .withValues(
                              alpha:
                                  0.05,
                            ),

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),

                      child: const Row(
                        children: [
                          Icon(
                            Icons
                                .upload_file,

                            color:
                                AppColors
                                    .primary,
                          ),

                          SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child: Text(
                              "Receipt upload support will be added later.",
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    SizedBox(
                      width:
                          double.infinity,

                      height: 56,

                      child:
                          ElevatedButton(
                        onPressed: () {
                          if (titleController
                                  .text
                                  .trim()
                                  .isEmpty ||
                              amountController
                                  .text
                                  .trim()
                                  .isEmpty) {
                            return;
                          }

                          setState(() {
                            expenses.insert(
                              0,
                              {
                                "title":
                                    titleController
                                        .text
                                        .trim(),

                                "amount":
                                    double.parse(
                                  amountController
                                      .text
                                      .trim(),
                                ),

                                "description":
                                    descriptionController
                                        .text
                                        .trim(),

                                "expenseCategory":
                                    selectedCategory,

                                "approved":
                                    false,
                              },
                            );
                          });

                          Navigator.pop(
                            context,
                          );
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors
                                  .primary,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),
                        ),

                        child: const Text(
                          "Add Expense",

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildExpenseTile({
    required String title,
    required String amount,
    required String category,
    required bool approved,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 18,
      ),

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
                  alpha: 0.05,
                ),

            blurRadius: 10,

            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.all(
                  14,
                ),

                decoration:
                    BoxDecoration(
                  color: AppColors
                      .primary
                      .withValues(
                        alpha: 0.1,
                      ),

                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),

                child: const Icon(
                  Icons
                      .payments_rounded,

                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(width: 16),

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
                        fontSize: 17,

                        fontWeight:
                            FontWeight
                                .w600,

                        fontFamily:
                            'Poppins',
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    Text(
                      category,

                      style:
                          const TextStyle(
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                amount,

                style:
                    const TextStyle(
                  fontSize: 18,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      Color(
                    0xFFD4AF37,
                  ),

                  fontFamily:
                      'Poppins',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),

                decoration:
                    BoxDecoration(
                  color: approved
                      ? Colors.green
                          .withValues(
                            alpha:
                                0.1,
                          )
                      : Colors.orange
                          .withValues(
                            alpha:
                                0.1,
                          ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Text(
                  approved
                      ? "Approved"
                      : "Pending",

                  style: TextStyle(
                    color: approved
                        ? Colors.green
                        : Colors.orange,

                    fontWeight:
                        FontWeight
                            .w600,
                  ),
                ),
              ),

              Text(
                "Receipt Pending",

                style: TextStyle(
                  color: Colors
                      .grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFinanceCard({
    required String title,
    required String amount,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.all(
          20,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            24,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(
                    alpha: 0.05,
                  ),

              blurRadius: 10,

              offset:
                  const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Text(
              title,

              style: const TextStyle(
                color: AppColors
                    .textSecondary,

                fontSize: 14,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              amount,

              style: TextStyle(
                color: color,

                fontSize: 24,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed:
            showAddExpenseDialog,

        backgroundColor:
            AppColors.primary,

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          "Add Expense",
        ),
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : SafeArea(
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets.all(
                  20,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    const Text(
                      'Scholarship & Expenses',

                      style: TextStyle(
                        fontSize: 30,

                        fontWeight:
                            FontWeight
                                .bold,

                        fontFamily:
                            'Poppins',

                        color: AppColors
                            .textPrimary,
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    /// MAIN CARD
                    Container(
                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets.all(
                        28,
                      ),

                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),

                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(
                              0xFF0A1931,
                            ),

                            Color(
                              0xFF1B3358,
                            ),
                          ],
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          const Text(
                            'Total Scholarship',

                            style: TextStyle(
                              color: Colors
                                  .white70,

                              fontFamily:
                                  'Poppins',
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            '₹ ${totalScholarship.toStringAsFixed(0)}',

                            style:
                                const TextStyle(
                              color:
                                  Colors
                                      .white,

                              fontSize: 36,

                              fontWeight:
                                  FontWeight
                                      .bold,

                              fontFamily:
                                  'Poppins',
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child:
                                    buildMiniFinanceInfo(
                                  "Disbursed",

                                  "₹ ${disbursedAmount.toStringAsFixed(0)}",
                                ),
                              ),

                              Expanded(
                                child:
                                    buildMiniFinanceInfo(
                                  "Available",

                                  "₹ ${availableBalance.toStringAsFixed(0)}",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    Row(
                      children: [
                        buildFinanceCard(
                          title:
                              "Total Expenses",

                          amount:
                              "₹ ${totalExpenses.toStringAsFixed(0)}",

                          color:
                              Colors.red,
                        ),

                        const SizedBox(
                          width: 16,
                        ),

                        buildFinanceCard(
                          title:
                              "Available Balance",

                          amount:
                              "₹ ${availableBalance.toStringAsFixed(0)}",

                          color:
                              Colors.green,
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 32,
                    ),

                    const Text(
                      'Expense History',

                      style: TextStyle(
                        fontSize: 22,

                        fontWeight:
                            FontWeight.bold,

                        fontFamily:
                            'Poppins',
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    if (expenses.isEmpty)
                      Container(
                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets.all(
                          28,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withValues(
                                    alpha:
                                        0.05,
                                  ),

                              blurRadius:
                                  10,

                              offset:
                                  const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [
                            Icon(
                              Icons
                                  .receipt_long_outlined,

                              size: 60,

                              color:
                                  Colors.grey
                                      .shade400,
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            const Text(
                              "No expenses added yet.",

                              style: TextStyle(
                                fontSize: 16,

                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...expenses.map(
                        (expense) {
                          return buildExpenseTile(
                            title:
                                expense[
                                        "title"] ??
                                    "",

                            amount:
                                "₹ ${(expense["amount"] ?? 0).toString()}",

                            category:
                                expense[
                                        "expenseCategory"] ??
                                    "OTHER",

                            approved:
                                expense[
                                        "approved"] ??
                                    false,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildMiniFinanceInfo(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: const TextStyle(
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          value,

          style: const TextStyle(
            color: Colors.white,

            fontSize: 20,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }
}