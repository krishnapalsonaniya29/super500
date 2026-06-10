import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/student_register_screen.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

import '../../../../widgets/inputs/custom_textfield.dart';
import '../../../student/presentation/screens/student_dashboard_screen.dart';
import '../../../student/presentation/screens/student_document_upload_screen.dart';
class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() =>
      _StudentLoginScreenState();
}

class _StudentLoginScreenState
    extends State<StudentLoginScreen> {
  final phoneController = TextEditingController();

  final otpController = TextEditingController();

  bool otpSent = false;

  bool loading = false;

Future<void> sendOtp() async {
  if (phoneController.text
      .trim()
      .length != 10) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Enter a valid 10-digit phone number",
        ),
      ),
    );

    return;
  }

  try {
    setState(() {
      loading = true;
    });

    await AuthService.sendOtp(
      phoneController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      otpSent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("OTP sent successfully"),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  } finally {
  if (mounted) {
    setState(() {
      loading = false;
    });
  }
}
}


Future<void> verifyOtp() async {
  if (otpController.text
      .trim()
      .length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Enter a valid 6-digit OTP",
        ),
      ),
    );

    return;
  }

  try {
    setState(() {
      loading = true;
    });

    final response =
        await AuthService.verifyOtp(
      phone: phoneController.text.trim(),
      otp: otpController.text.trim(),
      role: "STUDENT",
    );

    if (response["success"] == true) {
      if (!mounted) return;

      final data =
          Map<String, dynamic>.from(
        response["data"] ?? {},
      );
      final profileCompleted =
          data["profileCompleted"] == true;

      if (!profileCompleted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const StudentRegisterScreen(),
          ),
          (route) => false,
        );

        return;
      }

      Map<String, dynamic>? currentUser;
      try {
        currentUser =
            await AuthService
                .getCurrentUser();
      } catch (e) {
        debugPrint(
          "STUDENT LOGIN GET CURRENT USER ERROR => $e",
        );
      }

      if (!mounted) return;

      final studentProfile =
          currentUser?["studentProfile"];

      if (studentProfile is Map) {
        final documents =
            (studentProfile["documents"]
                    as List?)
                ?.cast<dynamic>() ??
            const [];

        if (documents.length < 5) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const StudentDocumentUploadScreen(),
            ),
            (route) => false,
          );

          return;
        }
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const StudentDashboardScreen(),
        ),
        (route) => false,
      );
    }
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  } finally {
  if (mounted) {
    setState(() {
      loading = false;
    });
  }
}
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Login'),
      ),

      body: SafeArea(
  child: SingleChildScrollView(
    padding:
        const EdgeInsets.all(
      24,
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        const SizedBox(
          height: 30,
        ),

        /// =====================================
        /// HEADER
        /// =====================================

        Center(
          child: Column(
            children: [
              Container(
                height: 90,
                width: 90,

                decoration:
                    BoxDecoration(
                  color:
                      Colors.blue
                          .withOpacity(
                    0.1,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),
                ),

                child: const Icon(
                  Icons.school,

                  size: 50,

                  color: Colors.blue,
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              const Text(
                "Student Login",

                style: TextStyle(
                  fontSize: 30,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Text(
                "Login to continue your scholarship journey",

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

        const SizedBox(
          height: 50,
        ),

        /// =====================================
        /// PHONE FIELD
        /// =====================================

        const Text(
          "Mobile Number",

          style: TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        CustomTextField(
          hintText:
              'Enter Mobile Number',

          controller:
              phoneController,

          keyboardType:
              TextInputType.phone,
        ),

        const SizedBox(
          height: 24,
        ),

        /// =====================================
        /// OTP FIELD
        /// =====================================

        if (otpSent) ...[
          const Text(
            "OTP",

            style: TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          CustomTextField(
            hintText:
                'Enter OTP',

            controller:
                otpController,

            keyboardType:
                TextInputType.number,
          ),

          const SizedBox(
            height: 12,
          ),

          Align(
            alignment:
                Alignment.centerRight,

            child: TextButton(
              onPressed: loading
                  ? null
                  : () {
                      setState(() {
                        otpSent =
                            false;

                        otpController
                            .clear();
                      });
                    },

              child: const Text(
                "Change Number",
              ),
            ),
          ),
        ],

        const SizedBox(
          height: 20,
        ),

        /// =====================================
        /// LOGIN BUTTON
        /// =====================================

        SizedBox(
          width:
              double.infinity,

          height: 56,

          child: ElevatedButton(
            onPressed: () {
              if (loading) return;

              if (otpSent) {
                verifyOtp();
              } else {
                sendOtp();
              }
            },

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.blue,

              foregroundColor:
                  Colors.white,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),
            ),

            child: Text(
              loading
                  ? "Please wait..."
                  : otpSent
                      ? "Verify OTP"
                      : "Send OTP",

              style:
                  const TextStyle(
                fontSize: 16,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 30,
        ),

        /// =====================================
        /// REGISTER SECTION
        /// =====================================

        // Row(
        //   mainAxisAlignment:
        //       MainAxisAlignment
        //           .center,

        //   children: [
        //     Text(
        //       "Not registered yet?",

        //       style: TextStyle(
        //         color:
        //             Colors.grey[700],
        //       ),
        //     ),

        //     TextButton(
        //       onPressed: () {
        //         Navigator.push(
        //           context,

        //           MaterialPageRoute(
        //             builder: (_) =>
        //                 const StudentRegisterScreen(),
        //           ),
        //         );
        //       },

        //       child: const Text(
        //         "Register Here",

        //         style: TextStyle(
        //           fontWeight:
        //               FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),

        // const SizedBox(
        //   height: 40,
        // ),

        /// =====================================
        /// DEMO OTP INFO
        /// =====================================

        Container(
          padding:
              const EdgeInsets.all(
            16,
          ),

          decoration:
              BoxDecoration(
            color:
                Colors.orange
                    .withOpacity(
              0.08,
            ),

            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),

          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [
              const Icon(
                Icons.info_outline,

                color: Colors.orange,
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Text(
                  "Use OTP 999999 for demo login during development.",

                  style: TextStyle(
                    color:
                        Colors.grey[800],

                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),
    );
  }
}
