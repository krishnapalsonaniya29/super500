import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

import '../../../../widgets/buttons/custom_button.dart';
import '../../../../widgets/inputs/custom_textfield.dart';
import '../../../../services/auth/auth_service.dart';
import '../../../mentor/presentation/screens/main/mentor_main_screen.dart';
class MentorOtpScreen
    extends StatefulWidget {
  final String phone;

  const MentorOtpScreen({
    super.key,
    required this.phone,
  });

  @override
  State<MentorOtpScreen>
      createState() =>
          _MentorOtpScreenState();
}

class _MentorOtpScreenState
    extends State<MentorOtpScreen> {
  final TextEditingController
  otpController =
      TextEditingController();

  final GlobalKey<FormState>
  _formKey =
      GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    otpController.dispose();

    super.dispose();
  }

Future<void> verifyOtp() async {
  if (!_formKey.currentState!
      .validate()) {
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    final response =
        await AuthService.verifyOtp(
      phone: widget.phone,
      otp: otpController.text.trim(),
    );

    final user =
        response["data"]["user"];

    final role =
        user["role"];

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Login Successful",
        ),
      ),
    );

    /// ROLE BASED NAVIGATION

    if (role == "MENTOR") {
  Navigator.pushAndRemoveUntil(
    context,

    MaterialPageRoute(
      builder:
          (_) =>
              const MentorMainScreen(),
    ),

    (route) => false,
  );
} else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Unauthorized role",
          ),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );
  } finally {
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
        elevation: 0,
        backgroundColor:
            Colors.transparent,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(24),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const SizedBox(
                  height: 40,
                ),

                const Text(
                  "OTP Verification",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Text(
                  "Enter the OTP sent to ${widget.phone}",
                  style: TextStyle(
                    color: Colors
                        .grey.shade600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                CustomTextField(
                  hintText:
                      "Enter OTP",

                  controller:
                      otpController,

                  keyboardType:
                      TextInputType.number,

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return "OTP is required";
                    }

                    if (value.length <
                        4) {
                      return "Enter valid OTP";
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 30,
                ),

                CustomButton(
                  text: isLoading
                      ? 'Verifying...'
                      : 'Verify OTP',

                  onPressed:
                      isLoading
                          ? null
                          : verifyOtp,
                ),

                const SizedBox(
                  height: 20,
                ),

                Center(
                  child: TextButton(
                    onPressed: () {},

                    child: const Text(
                      "Resend OTP",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}