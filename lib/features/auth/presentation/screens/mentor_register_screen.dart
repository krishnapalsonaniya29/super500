import 'package:flutter/material.dart';

import '../../../../widgets/buttons/custom_button.dart';
import '../../../../widgets/inputs/custom_textfield.dart';

class MentorRegisterScreen extends StatelessWidget {
  const MentorRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final professionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Registration'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            CustomTextField(
              hintText: 'Full Name',
              controller: nameController,
            ),

            const SizedBox(height: 20),
               CustomTextField(
              hintText: 'Mobile Number',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              hintText: 'Profession',
              controller: professionController,
            ),

            const SizedBox(height: 30),

            CustomButton(
              text: 'Apply as Mentor',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}