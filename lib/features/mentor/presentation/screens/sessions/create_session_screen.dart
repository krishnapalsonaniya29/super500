import 'package:flutter/material.dart';

import '../../../../../services/mentor/mentor_service.dart';

import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/buttons/custom_button.dart';

import '../../../../../widgets/inputs/custom_textfield.dart';

import '../../../../../widgets/loaders/app_loader.dart';

class CreateSessionScreen
    extends StatefulWidget {
  const CreateSessionScreen({
    super.key,
  });

  @override
  State<CreateSessionScreen>
      createState() =>
          _CreateSessionScreenState();
}

class _CreateSessionScreenState
    extends State<
        CreateSessionScreen> {
  final titleController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  final meetingLinkController =
      TextEditingController();

  bool isLoading = false;

  List students = [];

  String? selectedStudentId;

  DateTime? selectedDateTime;

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
      pickDateTime() async {
    final date =
        await showDatePicker(
      context: context,

      firstDate: DateTime.now(),

      lastDate: DateTime(2030),

      initialDate: DateTime.now(),
    );

    if (date == null) return;

    final time =
        await showTimePicker(
      context: context,

      initialTime:
          TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      selectedDateTime =
          DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void>
      createSession() async {
    if (titleController.text
            .trim()
            .isEmpty ||
        selectedStudentId ==
            null ||
        selectedDateTime ==
            null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all required fields",
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
          .createSession(
        title:
            titleController.text
                .trim(),

        studentId:
            selectedStudentId!,

        scheduledAt:
            selectedDateTime!
                .toIso8601String(),

        description:
            descriptionController.text
                .trim(),

        meetingLink:
            meetingLinkController.text
                .trim(),
      );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Session created successfully",
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
          "Create Session",
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
                  /// ======================
                  /// TITLE
                  /// ======================

                  CustomTextField(
                    controller:
                        titleController,

                    hintText:
                        "Session Title",
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  /// ======================
                  /// DESCRIPTION
                  /// ======================

                  CustomTextField(
                    controller:
                        descriptionController,

                    hintText:
                        "Description",

                    maxLines: 4,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  /// ======================
                  /// MEETING LINK
                  /// ======================

                  CustomTextField(
                    controller:
                        meetingLinkController,

                    hintText:
                        "Meeting Link",
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  /// ======================
                  /// STUDENT DROPDOWN
                  /// ======================

                  DropdownButtonFormField<
                      String>(
                    initialValue:
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
                                    ["fullName"] ??
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

                  /// ======================
                  /// DATE TIME
                  /// ======================

                  InkWell(
                    onTap:
                        pickDateTime,

                    child: Container(
                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets.all(
                        16,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),

                      child: Text(
                        selectedDateTime ==
                                null
                            ? "Select Session Date & Time"
                            : selectedDateTime
                                .toString(),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  /// ======================
                  /// BUTTON
                  /// ======================

                  CustomButton(
                    text:
                        "Create Session",

                    onPressed:
                        createSession,
                  ),
                ],
              ),
            ),
    );
  }
}