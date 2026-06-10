import 'package:flutter/material.dart';

import '../../../../../services/admin/admin_service.dart';

import '../../../../../theme/app_colors.dart';

class AssignMentorScreen
    extends StatefulWidget {
  final Map<String, dynamic>
      student;

  const AssignMentorScreen({
    super.key,
    required this.student,
  });

  @override
  State<AssignMentorScreen>
      createState() =>
          _AssignMentorScreenState();
}

class _AssignMentorScreenState
    extends State<
        AssignMentorScreen> {
  List mentors = [];

  List filteredMentors = [];

  bool loading = true;

  bool assigning = false;

  String searchQuery = "";

  final searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchMentors();
  }

  /// =====================================
  /// FETCH MENTORS
  /// =====================================

  Future<void> fetchMentors() async {
    try {
      setState(() {
        loading = true;
      });

      final response =
          await AdminService
              .getMentors();

      mentors =
          response["data"] ?? [];

      applySearch();
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
  /// SEARCH
  /// =====================================

  void applySearch() {
    filteredMentors =
        mentors.where((mentor) {
      if (mentor[
              "verificationStatus"] !=
          "APPROVED") {
        return false;
      }

      final user = mentor["user"];

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
  /// ASSIGN MENTOR
  /// =====================================

  Future<void> assignMentor(
    String mentorId,
  ) async {
    try {
      setState(() {
        assigning = true;
      });

      await AdminService
          .assignMentor(
        studentId:
            widget.student["id"],

        mentorId: mentorId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.green,

          content: Text(
            "Mentor assigned successfully",
          ),
        ),
      );

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      debugPrint(e.toString());

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.red,

          content: Text(
            "Failed to assign mentor",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          assigning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentUser =
        widget.student["user"];

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Assign Mentor",
        ),

        backgroundColor:
            AppColors.primary,

        foregroundColor:
            Colors.white,
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Column(
              children: [
                /// STUDENT CARD
                Container(
                  margin:
                      const EdgeInsets.all(
                    20,
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

                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,

                        backgroundColor:
                            AppColors.primary,

                        child: Text(
                          studentUser[
                                  "fullName"][0]
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
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            Text(
                              studentUser[
                                      "fullName"] ??
                                  "-",

                              style:
                                  const TextStyle(
                                fontSize:
                                    18,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 6,
                            ),

                            Text(
                              widget.student[
                                      "schoolName"] ??
                                  "-",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// SEARCH
                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: TextField(
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
                          "Search mentors",

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
                ),

                const SizedBox(
                  height: 20,
                ),

                /// LIST
                Expanded(
                  child: filteredMentors
                          .isEmpty
                      ? const Center(
                          child: Text(
                            "No mentors found",
                          ),
                        )

                      : ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal:
                                20,
                          ),

                          itemCount:
                              filteredMentors
                                  .length,

                          itemBuilder:
                              (_, index) {
                            final mentor =
                                filteredMentors[
                                    index];

                            final user =
                                mentor[
                                    "user"];

                            final studentCount =
                                (mentor["students"]
                                            as List?)
                                        ?.length ??
                                    0;

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
                                              user["phone"] ??
                                                  "-",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height:
                                        18,
                                  ),

                                  buildInfoRow(
                                    icon:
                                        Icons
                                            .groups_rounded,

                                    title:
                                        "Students Assigned",

                                    value:
                                        studentCount
                                            .toString(),
                                  ),

                                  const SizedBox(
                                    height:
                                        10,
                                  ),

                                  buildInfoRow(
                                    icon:
                                        Icons
                                            .location_city,

                                    title:
                                        "District",

                                    value:
                                        mentor["district"] ??
                                            "-",
                                  ),

                                  const SizedBox(
                                    height:
                                        22,
                                  ),

                                  SizedBox(
                                    width:
                                        double.infinity,

                                    child:
                                        ElevatedButton(
                                      onPressed:
                                          assigning
                                              ? null
                                              : () {
                                                  assignMentor(
                                                    mentor["id"],
                                                  );
                                                },

                                      style:
                                          ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.primary,
                                      ),

                                      child:
                                          assigning
                                              ? const SizedBox(
                                                  height:
                                                      18,

                                                  width:
                                                      18,

                                                  child:
                                                      CircularProgressIndicator(
                                                    color:
                                                        Colors.white,

                                                    strokeWidth:
                                                        2,
                                                  ),
                                                )
                                              : const Text(
                                                  "Assign Mentor",
                                                ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
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
