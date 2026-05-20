import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './student_document_upload_screen.dart';
import '../../../../../services/auth/auth_service.dart';

class StudentAcademicScreen extends StatefulWidget {
  const StudentAcademicScreen({super.key});

  @override
  State<StudentAcademicScreen> createState() =>
      _StudentAcademicScreenState();
}

class _StudentAcademicScreenState
    extends State<StudentAcademicScreen> {
  final formKey = GlobalKey<FormState>();

  final addressController =
      TextEditingController();

  final stateController =
      TextEditingController();

  final pincodeController =
      TextEditingController();

  final annualIncomeController =
      TextEditingController();

  final joiningYearController =
      TextEditingController();

  final currentYearController =
      TextEditingController();

  final bankNameController =
      TextEditingController();

  final accountNumberController =
      TextEditingController();

  final ifscController =
      TextEditingController();

  DateTime? selectedDate;

  bool loading = false;

  String category = "General";

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialDate: DateTime(2008),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> submitAcademicDetails() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select date of birth",
          ),
        ),
      );

      return;
    }

    try {
      setState(() {
        loading = true;
      });

      final prefs =
          await SharedPreferences.getInstance();

      final token =
          prefs.getString("accessToken");

      await Dio().put(
        "${AuthService.baseUrl.replaceAll('/auth', '')}/users/complete-profile",

        data: {
          "dateOfBirth":
              selectedDate!.toIso8601String(),

          "address":
              addressController.text.trim(),

          "state":
              stateController.text.trim(),

          "pincode":
              pincodeController.text.trim(),

          "category": category,

          "annualIncome": double.parse(
            annualIncomeController.text.trim(),
          ),

          "joiningYear": int.parse(
            joiningYearController.text.trim(),
          ),

          "currentYear": int.parse(
            currentYearController.text.trim(),
          ),

          "bankName":
              bankNameController.text.trim(),

          "bankAccountNumber":
              accountNumberController.text.trim(),

          "ifscCode":
              ifscController.text.trim(),

          "profileCompleted": true,
        },

        options: Options(
          headers: {
            "Authorization":
                "Bearer $token",
          },
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Academic details submitted successfully",
          ),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const StudentDocumentUploadScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Widget buildField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboard =
        TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,

        validator: (value) {
          if (value == null ||
              value.trim().isEmpty) {
            return "$hint is required";
          }

          return null;
        },

        decoration: InputDecoration(
          hintText: hint,

          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(16),

            borderSide: BorderSide.none,
          ),

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,

        title: const Text(
          "Academic Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  "Complete Academic Profile",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Fill remaining details to continue",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Date of Birth",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                GestureDetector(
                  onTap: pickDate,

                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),

                    child: Text(
                      selectedDate == null
                          ? "Select Date of Birth"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",

                      style: TextStyle(
                        color:
                            selectedDate == null
                                ? Colors.grey
                                : Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                buildField(
                  hint: "Address",
                  controller:
                      addressController,
                ),

                buildField(
                  hint: "State",
                  controller:
                      stateController,
                ),

                buildField(
                  hint: "Pincode",
                  controller:
                      pincodeController,
                  keyboard:
                      TextInputType.number,
                ),

                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration:
                      InputDecoration(
                    filled: true,
                    fillColor: Colors.white,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),

                      borderSide:
                          BorderSide.none,
                    ),
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: "General",
                      child: Text("General"),
                    ),

                    DropdownMenuItem(
                      value: "OBC",
                      child: Text("OBC"),
                    ),

                    DropdownMenuItem(
                      value: "SC",
                      child: Text("SC"),
                    ),

                    DropdownMenuItem(
                      value: "ST",
                      child: Text("ST"),
                    ),

                    DropdownMenuItem(
                      value: "EWS",
                      child: Text("EWS"),
                    ),
                  ],

                  onChanged: (value) {
                    setState(() {
                      category = value!;
                    });
                  },
                ),

                const SizedBox(height: 18),

                buildField(
                  hint: "Annual Family Income",
                  controller:
                      annualIncomeController,
                  keyboard:
                      TextInputType.number,
                ),

                buildField(
                  hint: "Joining Year",
                  controller:
                      joiningYearController,
                  keyboard:
                      TextInputType.number,
                ),

                buildField(
                  hint: "Current Year",
                  controller:
                      currentYearController,
                  keyboard:
                      TextInputType.number,
                ),

                buildField(
                  hint: "Bank Name",
                  controller:
                      bankNameController,
                ),

                buildField(
                  hint: "Bank Account Number",
                  controller:
                      accountNumberController,
                  keyboard:
                      TextInputType.number,
                ),

                buildField(
                  hint: "IFSC Code",
                  controller:
                      ifscController,
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: loading
                        ? null
                        : submitAcademicDetails,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF0A1931,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          18,
                        ),
                      ),
                    ),

                    child: loading
                        ? const CircularProgressIndicator(
                            color:
                                Colors.white,
                          )
                        : const Text(
                            "Submit Details",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}