import 'package:flutter/material.dart';

import '../../../../widgets/buttons/custom_button.dart';
import '../../../../widgets/inputs/custom_textfield.dart';
import '../widgets/auth_switch_text.dart';
import 'mentor_register_screen.dart';

class MentorLoginScreen extends StatelessWidget {
              const MentorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Login'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            const Text(
              'Welcome Mentor',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Login to manage and mentor students',
            ),

            const SizedBox(height: 40),

            CustomTextField(
              hintText: 'Enter Mobile Number',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Send OTP',
              onPressed: () {},
            ),

            const SizedBox(height: 30),

            AuthSwitchText(
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
          ],
        ),
      ),
    );
  }
}