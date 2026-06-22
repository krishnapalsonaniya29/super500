import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

import '../../../../widgets/buttons/custom_button.dart';
import '../../../../widgets/inputs/custom_textfield.dart';

import '../widgets/auth_switch_text.dart';

import 'mentor_register_screen.dart';
import 'mentor_otp_screen.dart';
import '../../../../services/auth/auth_service.dart';

class MentorLoginScreen extends StatefulWidget {
  const MentorLoginScreen({super.key});

  @override
  State<MentorLoginScreen> createState() => _MentorLoginScreenState();
}

class _MentorLoginScreenState extends State<MentorLoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();

    super.dispose();
  }

  Future<void> sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await AuthService.sendOtp(
        phone: phoneController.text.trim(),
        role: "MENTOR",
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MentorOtpScreen(phone: phoneController.text.trim()),
        ),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("OTP Sent Successfully")));
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
                const SizedBox(height: 40),

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
                        "Welcome Mentor",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Login to manage students and mentoring sessions",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                CustomTextField(
                  hintText: 'Enter Mobile Number',

                  controller: phoneController,

                  keyboardType: TextInputType.phone,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number is required";
                    }

                    if (value.length < 10) {
                      return "Enter valid mobile number";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                CustomButton(
                  text: isLoading ? 'Sending OTP...' : 'Send OTP',

                  onPressed: isLoading ? null : sendOtp,
                ),

                const SizedBox(height: 30),

                Center(
                  child: AuthSwitchText(
                    normalText: "Don't have an account? ",

                    actionText: 'Register',

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MentorRegisterScreen(),
                        ),
                      );
                    },
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
