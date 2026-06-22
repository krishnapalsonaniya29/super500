import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

import '../../../../widgets/buttons/custom_button.dart';
import '../../../../widgets/inputs/custom_textfield.dart';
import '../../../../services/auth/auth_service.dart';
import '../../../mentor/presentation/screens/main/mentor_main_screen.dart';

class MentorOtpScreen extends StatefulWidget {
  final String phone;

  const MentorOtpScreen({super.key, required this.phone});

  @override
  State<MentorOtpScreen> createState() => _MentorOtpScreenState();
}

class _MentorOtpScreenState extends State<MentorOtpScreen> {
  final TextEditingController otpController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    otpController.dispose();

    super.dispose();
  }

  Future<void> verifyOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await AuthService.verifyOtp(
        phone: widget.phone,
        otp: otpController.text.trim(),
        role: "MENTOR",
      );

      if (response["success"] != true) {
        throw Exception("OTP verification failed");
      }

      final data = Map<String, dynamic>.from(response["data"] ?? {});

      final user = Map<String, dynamic>.from(data["user"] ?? {});

      final role = user["role"];

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Successful")));

      /// ROLE BASED NAVIGATION

      if (role == "MENTOR") {
        Navigator.pushAndRemoveUntil(
          context,

          MaterialPageRoute(builder: (_) => const MentorMainScreen()),

          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Unauthorized role")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                "assets/images/app_logo2.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mentor Portal",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Super 500 Mentorship System",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Image.asset("assets/images/mentor_role.png", height: 120),

                      const SizedBox(height: 12),

                      const Text(
                        "Verify OTP",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Enter the OTP sent to\n${widget.phone}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const SizedBox(height: 40),

                CustomTextField(
                  hintText: "Enter OTP",

                  controller: otpController,

                  keyboardType: TextInputType.number,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "OTP is required";
                    }

                    if (value.length < 4) {
                      return "Enter valid OTP";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                CustomButton(
                  text: isLoading ? 'Verifying...' : 'Verify OTP',

                  onPressed: isLoading ? null : verifyOtp,
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () {},

                    child: const Text("Resend OTP"),
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
