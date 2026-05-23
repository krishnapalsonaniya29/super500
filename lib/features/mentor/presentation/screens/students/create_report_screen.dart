import 'package:flutter/material.dart';

import '../../../../../services/mentor/mentor_service.dart';

import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/buttons/custom_button.dart';

class CreateReportScreen
    extends StatefulWidget {

  final String studentId;

  final String studentName;

  const CreateReportScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<CreateReportScreen>
      createState() =>
          _CreateReportScreenState();
}

class _CreateReportScreenState
    extends State<
        CreateReportScreen> {

  final TextEditingController
  contentController =
      TextEditingController();

  final GlobalKey<FormState>
  _formKey =
      GlobalKey<FormState>();

  String reportType =
      "MONTHLY";

  bool isLoading = false;

  @override
  void dispose() {
    contentController.dispose();

    super.dispose();
  }

  Future<void>
      submitReport() async {

    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await MentorService
          .createReport(
        studentId:
            widget.studentId,

        content:
            contentController.text
                .trim(),

        reportType:
            reportType,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Report submitted successfully",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      if (!mounted) return;

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
            AppColors.primary,

        title: const Text(
          "Create Report",
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          16,
        ),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [

              /// =====================
              /// STUDENT CARD
              /// =====================

              Card(
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),

                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),

                  child: Row(
                    children: [

                      CircleAvatar(
                        radius: 28,

                        backgroundColor:
                            AppColors.gold,

                        child: Text(
                          widget.studentName.isNotEmpty
                        ? widget.studentName[0]
                            .toUpperCase()
                        : "S",

                          style:
                              const TextStyle(
                            color:
                                Colors.black,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 14,
                      ),

                      Expanded(
                        child: Text(
                          widget.studentName,

                          style:
                              const TextStyle(
                            fontSize: 18,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              /// =====================
              /// REPORT TYPE
              /// =====================

              const Text(
                "Report Type",

                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              DropdownButtonFormField<String>(
                value: reportType,

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
                      "Monthly",
                    ),
                  ),

                  DropdownMenuItem(
                    value:
                        "QUARTERLY",

                    child: Text(
                      "Quarterly",
                    ),
                  ),

                  DropdownMenuItem(
                    value:
                        "PERFORMANCE",

                    child: Text(
                      "Performance",
                    ),
                  ),
                ],

                onChanged: (value) {

                  if (value == null) {
                    return;
                  }

                  setState(() {
                    reportType =
                        value;
                  });
                },
              ),

              const SizedBox(
                height: 24,
              ),

              /// =====================
              /// CONTENT
              /// =====================

              const Text(
                "Report Content",

                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              TextFormField(
                controller:
                    contentController,

                maxLines: 8,

                validator: (value) {

                  if (value == null ||
                      value.trim().isEmpty) {

                    return "Please write report content";
                  }

                  return null;
                },

                decoration:
                    InputDecoration(
                  hintText:
                      "Write mentor report...",

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
              ),

              const SizedBox(
                height: 30,
              ),

              /// =====================
              /// SUBMIT BUTTON
              /// =====================

              CustomButton(
                text: isLoading
                    ? "Submitting..."
                    : "Submit Report",

                onPressed:
                    isLoading
                        ? null
                        : submitReport,
              ),
            ],
          ),
        ),
      ),
    );
  }
}