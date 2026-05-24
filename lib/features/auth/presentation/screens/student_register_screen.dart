import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/student/presentation/screens/student_academic_screen.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/dio_client.dart';


class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  State<StudentRegisterScreen> createState() =>
      _StudentRegisterScreenState();
}

class _StudentRegisterScreenState
    extends State<StudentRegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final fullNameController =
      TextEditingController();

  final fatherNameController =
      TextEditingController();

  final schoolController =
      TextEditingController();

  final classController =
      TextEditingController();

  final districtController =
      TextEditingController();

  final samagraController =
      TextEditingController();

  final apaarController =
      TextEditingController();

  final marksController =
      TextEditingController();

  bool loading = false;

  String gender = "Male";

  Future<void> completeProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        loading = true;
      });
      //final token = await AuthService.getToken();
    

// final response = await DioClient.instance.post(
//   "http://localhost:5000/api/v1/auth/complete-profile",
final response =
    await DioClient.instance.post(
  "/v1/auth/complete-profile",

  data: {
    "fullName":
        fullNameController.text.trim(),

    "gender": gender,

    "district":
        districtController.text
            .trim()
            .toUpperCase(),

    "fatherName":
        fatherNameController.text
            .trim(),

    "schoolName":
        schoolController.text
            .trim(),

    "currentClass":
        classController.text
            .trim(),

    "samagraId":
        samagraController.text
            .trim(),

    "apaarId":
        apaarController.text
            .trim(),

    "marks10th":
        double.parse(
      marksController.text.trim(),
    ),
  },
);

//   options: Options(
//     headers: {
//       "Authorization":
//           "Bearer $token",
//     },
//   ),
// );

debugPrint(
  "REGISTER RESPONSE => ${response.data}",
);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Profile completed successfully",
          ),
        ),
      );

    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) =>
        const StudentAcademicScreen(),
  ),
   );
    } catch (e) {
  if (e is DioException) {
    debugPrint(
      "ERROR STATUS => ${e.response?.statusCode}",
    );

    debugPrint(
      "ERROR DATA => ${e.response?.data}",
    );
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        e.toString(),
      ),
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
          "Complete Profile",
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
                  "Student Registration",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Complete your profile to continue",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                buildField(
                  hint: "Full Name",
                  controller:
                      fullNameController,
                ),

                buildField(
                  hint: "Father Name",
                  controller:
                      fatherNameController,
                ),

                buildField(
                  hint: "School Name",
                  controller:
                      schoolController,
                ),

                buildField(
                  hint: "Current Class",
                  controller:
                      classController,
                ),

                buildField(
                  hint: "District",
                  controller:
                      districtController,
                ),

                buildField(
                  hint: "Samagra ID",
                  controller:
                      samagraController,
                  keyboard:
                      TextInputType.number,
                ),

                buildField(
                  hint: "Apaar ID",
                  controller:
                      apaarController,
                ),

                buildField(
                  hint: "10th Percentage",
                  controller:
                      marksController,
                  keyboard:
                      TextInputType.number,
                ),

                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  initialValue: gender,

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
                      value: "Male",
                      child: Text("Male"),
                    ),

                    DropdownMenuItem(
                      value: "Female",
                      child: Text("Female"),
                    ),

                    DropdownMenuItem(
                      value: "Other",
                      child: Text("Other"),
                    ),
                  ],

                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: loading
                        ? null
                        : completeProfile,

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
                            "Complete Profile",
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