import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/student_register_screen.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';


import '../../../../widgets/buttons/custom_button.dart';
import '../../../../widgets/inputs/custom_textfield.dart';
import '../../../student/presentation/screens/student_dashboard_screen.dart';

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
    try {
      setState(() {
        loading = true;
      });

      await AuthService.sendOtp(
        phoneController.text.trim(),
      );

      setState(() {
        otpSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP sent successfully"),
        ),
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

  Future<void> verifyOtp() async {
  try {
    setState(() {
      loading = true;
    });

    final response =
        await AuthService.verifyOtp(
      phone: phoneController.text.trim(),
      otp: otpController.text.trim(),
    );

    if (response["success"] == true) {
      final me =
          await AuthService.getMe();

      final studentProfile =
          me["data"]["studentProfile"];

      if (!mounted) return;

      /// PROFILE NOT COMPLETED
      if (studentProfile == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const StudentRegisterScreen(),
          ),
          (route) => false,
        );
      }

      /// PROFILE COMPLETED
      else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const StudentDashboardScreen(),
          ),
          (route) => false,
        );
      }
    }
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Login'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 30),

            const Text(
              'Welcome Student',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Login to continue your scholarship journey',
            ),

            const SizedBox(height: 40),

            CustomTextField(
              hintText: 'Enter Mobile Number',
              controller: phoneController,
              keyboardType:
                  TextInputType.phone,
            ),

            const SizedBox(height: 20),

            if (otpSent)
              CustomTextField(
                hintText: 'Enter OTP',
                controller: otpController,
                keyboardType:
                    TextInputType.number,
              ),

            const SizedBox(height: 24),

            CustomButton(
                  text: loading
                      ? 'Please wait...'
                      : otpSent
                          ? 'Verify OTP'
                          : 'Send OTP',

                  onPressed: () {
                    if (loading) return;

                    if (otpSent) {
                      verifyOtp();
                    } else {
                      sendOtp();
                    }
                  },
                ),
          ],
        ),
      ),
    );
  }
}