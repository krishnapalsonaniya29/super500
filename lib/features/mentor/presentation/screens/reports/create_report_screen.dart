import 'package:flutter/material.dart';

import '../../../../../services/mentor/mentor_service.dart';

import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/buttons/custom_button.dart';

import '../../../../../widgets/inputs/custom_textfield.dart';

import '../../../../../widgets/loaders/app_loader.dart';

class CreateReportScreen
    extends StatefulWidget {
  const CreateReportScreen({
    super.key,
  });

  @override
  State<CreateReportScreen>
      createState() =>
          _CreateReportScreenState();
}

class _CreateReportScreenState
    extends State<
        CreateReportScreen> {
  final contentController =
      TextEditingController();

  bool isLoading = false;

  List students = [];

  String? selectedStudentId;

  String selectedReportType =
      "MONTHLY";

  @override
  void initState() {
    super.initState();

    loadStudents();
  }

  Future<void>
      loadStudents() async {
    try {
      final response =
          await MentorService
              .getStudents();

      setState(() {
        students =
            response["students"];
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
    }
  }

  Future<void>
      createReport() async {
    if (selectedStudentId ==
            null ||
        contentController.text
            .trim()
            .isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields",
          ),
        ),
      );

      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await MentorService
          .createReport(
        studentId:
            selectedStudentId!,

        content:
            contentController.text
                .trim(),

        reportType:
            selectedReportType,
      );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Report created successfully",
          ),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        backgroundColor:
            AppColors.primary,

        title: const Text(
          "Create Report",
        ),
      ),

      body: isLoading
          ? const Center(
              child: AppLoader(),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.all(
                16,
              ),

              child: Column(
                children: [
                  /// =====================
                  /// STUDENT
                  /// =====================

                  DropdownButtonFormField<
                      String>(
                    value:
                        selectedStudentId,

                    decoration:
                        InputDecoration(
                      filled: true,

                      fillColor:
                          Colors.white,

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),

                    hint: const Text(
                      "Select Student",
                    ),

                    items:
                        students.map(
                      (student) {
                        return DropdownMenuItem<
                            String>(
                          value:
                              student["id"],

                          child: Text(
                            student["user"]
                                    ["name"] ??
                                "",
                          ),
                        );
                      },
                    ).toList(),

                    onChanged: (
                      value,
                    ) {
                      setState(() {
                        selectedStudentId =
                            value;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  /// =====================
                  /// REPORT TYPE
                  /// =====================

                  DropdownButtonFormField<
                      String>(
                    value:
                        selectedReportType,

                    decoration:
                        InputDecoration(
                      filled: true,

                      fillColor:
                          Colors.white,

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),

                    items: const [
                      DropdownMenuItem(
                        value:
                            "MONTHLY",

                        child: Text(
                          "MONTHLY",
                        ),
                      ),

                      DropdownMenuItem(
                        value:
                            "QUARTERLY",

                        child: Text(
                          "QUARTERLY",
                        ),
                      ),

                      DropdownMenuItem(
                        value:
                            "PERFORMANCE",

                        child: Text(
                          "PERFORMANCE",
                        ),
                      ),
                    ],

                    onChanged: (
                      value,
                    ) {
                      setState(() {
                        selectedReportType =
                            value!;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  /// =====================
                  /// CONTENT
                  /// =====================

                  CustomTextField(
                    controller:
                        contentController,

                    hintText:
                        "Write report content",

                    maxLines: 8,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  /// =====================
                  /// BUTTON
                  /// =====================

                  CustomButton(
                    text:
                        "Submit Report",

                    onPressed:
                        createReport,
                  ),
                ],
              ),
            ),
    );
  }
}