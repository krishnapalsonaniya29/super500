import 'package:flutter/material.dart';

import '../../../../../services/admin/admin_service.dart';

import '../../../../../theme/app_colors.dart';

class ExpensesScreen
    extends StatefulWidget {
  const ExpensesScreen({
    super.key,
  });

  @override
  State<ExpensesScreen>
      createState() =>
          _ExpensesScreenState();
}

class _ExpensesScreenState
    extends State<
        ExpensesScreen> {
  List expenses = [];

  List filteredExpenses = [];

  bool loading = true;

  bool actionLoading = false;

  String searchQuery = "";

  String? errorMessage;

  final searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchExpenses();
  }

  /// =====================================
  /// FETCH EXPENSES
  /// =====================================

  Future<void> fetchExpenses() async {
    try {
      setState(() {
        loading = true;
        errorMessage = null;
      });

      final response =
          await AdminService
              .getStudents();

      final students =
          response["data"] ?? [];

      List allExpenses = [];

      for (final student
          in students) {
        final studentExpenses =
            student["expenses"] ??
                [];

        for (final expense
            in studentExpenses) {
          allExpenses.add({
            ...expense,
            "student":
                student,
          });
        }
      }

      expenses = allExpenses;

      applySearch();
    } catch (e) {
      debugPrint(e.toString());

      errorMessage =
          "Failed to load expenses";
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  /// =====================================
  /// SEARCH
  /// =====================================

  void applySearch() {
    filteredExpenses =
        expenses.where((expense) {
      final student =
          expense["student"];

      final user =
          student["user"];

      final name =
          (user["fullName"] ?? "")
              .toString()
              .toLowerCase();

      final category =
          (expense["category"] ??
                  "")
              .toString()
              .toLowerCase();

      return name.contains(
            searchQuery.toLowerCase(),
          ) ||
          category.contains(
            searchQuery.toLowerCase(),
          );
    }).toList();

    setState(() {});
  }

  /// =====================================
  /// APPROVE
  /// =====================================

  Future<void> approveExpense(
    String id,
  ) async {
    try {
      setState(() {
        actionLoading = true;
      });

      await AdminService
          .approveExpense(id);

      await fetchExpenses();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.green,
          content: Text(
            "Expense approved",
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

  Future<void> rejectExpense(
    String id,
  ) async {
    try {
      setState(() {
        actionLoading = true;
      });

      await AdminService
          .rejectExpense(id);

      await fetchExpenses();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.orange,
          content: Text(
            "Expense rejected",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: SafeArea(
        child: loading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh:
                    fetchExpenses,

                child:
                    SingleChildScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(),

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
                        "Expense Management",

                        style:
                            TextStyle(
                          fontSize:
                              30,

                          fontWeight:
                              FontWeight.bold,

                          fontFamily:
                              'Poppins',
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        "${filteredExpenses.length} expenses found",

                        style:
                            const TextStyle(
                          color: AppColors
                              .textSecondary,
                        ),
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      TextField(
                        controller:
                            searchController,

                        onChanged:
                            (value) {
                          searchQuery =
                              value;

                          applySearch();
                        },

                        decoration:
                            InputDecoration(
                          hintText:
                              "Search expenses",

                          prefixIcon:
                              const Icon(
                            Icons.search,
                          ),

                          filled: true,

                          fillColor:
                              Colors.white,

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),

                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      ListView.builder(
                        shrinkWrap: true,

                        physics:
                            const NeverScrollableScrollPhysics(),

                        itemCount:
                            filteredExpenses
                                .length,

                        itemBuilder:
                            (_, index) {
                          final expense =
                              filteredExpenses[
                                  index];

                          final student =
                              expense[
                                  "student"];

                          final user =
                              student[
                                  "user"];

                          return Container(
                            margin:
                                const EdgeInsets.only(
                              bottom:
                                  18,
                            ),

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
                                24,
                              ),
                            ),

                            child:
                                Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius:
                                          28,

                                      backgroundColor:
                                          AppColors.primary,

                                      child:
                                          Text(
                                        user["fullName"][0],

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
                                      width:
                                          14,
                                    ),

                                    Expanded(
                                      child:
                                          Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Text(
                                            user["fullName"],

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
                                            expense["category"] ??
                                                "-",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height:
                                      20,
                                ),

                                buildInfoRow(
                                  icon:
                                      Icons
                                          .currency_rupee,

                                  title:
                                      "Amount",

                                  value:
                                      "₹ ${expense["amount"]}",
                                ),

                                const SizedBox(
                                  height:
                                      10,
                                ),

                                buildInfoRow(
                                  icon:
                                      Icons.note,

                                  title:
                                      "Description",

                                  value:
                                      expense["description"] ??
                                          "-",
                                ),

                                const SizedBox(
                                  height:
                                      22,
                                ),

                                Row(
                                  children: [
                                    Expanded(
                                      child:
                                          ElevatedButton(
                                        onPressed:
                                            actionLoading
                                                ? null
                                                : () {
                                                    approveExpense(
                                                      expense["id"],
                                                    );
                                                  },

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
                                          14,
                                    ),

                                    Expanded(
                                      child:
                                          ElevatedButton(
                                        onPressed:
                                            actionLoading
                                                ? null
                                                : () {
                                                    rejectExpense(
                                                      expense["id"],
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
                                    ),
                                  ],
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