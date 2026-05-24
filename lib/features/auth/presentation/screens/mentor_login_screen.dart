import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

import '../../../../widgets/buttons/custom_button.dart';
import '../../../../widgets/inputs/custom_textfield.dart';

import '../widgets/auth_switch_text.dart';

import 'mentor_register_screen.dart';
import 'mentor_otp_screen.dart';
import '../../../../services/auth/auth_service.dart';
class MentorLoginScreen
    extends StatefulWidget {
  const MentorLoginScreen({
    super.key,
  });

  @override
  State<MentorLoginScreen>
      createState() =>
          _MentorLoginScreenState();
}

class _MentorLoginScreenState
    extends State<MentorLoginScreen> {
  final TextEditingController
  phoneController =
      TextEditingController();

  final GlobalKey<FormState>
  _formKey =
      GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();

    super.dispose();
  }

  Future<void> sendOtp() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => MentorOtpScreen(
              phone:
                  phoneController.text,
            ),
      ),
    );
      await AuthService.sendOtp(
      phoneController.text.trim(),    
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "OTP Sent Successfully",
          ),
        ),
      );

      /// TODO:
      /// NAVIGATE TO OTP SCREEN
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
        title: const Text(
          'Mentor Login',
        ),
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
                  'Welcome Mentor',
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
                  'Login to manage students and mentoring sessions',
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
                      'Enter Mobile Number',

                  controller:
                      phoneController,

                  keyboardType:
                      TextInputType.phone,

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return "Phone number is required";
                    }

                    if (value.length <
                        10) {
                      return "Enter valid mobile number";
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 30,
                ),

                CustomButton(
                  text: isLoading
                      ? 'Sending OTP...'
                      : 'Send OTP',

                  onPressed:
                      isLoading
                          ? null
                          : sendOtp,
                ),

                const SizedBox(
                  height: 30,
                ),

                Center(
                  child: AuthSwitchText(
                    normalText:
                        "Don't have an account? ",

                    actionText:
                        'Register',

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  const MentorRegisterScreen(),
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