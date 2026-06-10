import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

import '../../../../widgets/buttons/custom_button.dart';
import '../../../../widgets/inputs/custom_textfield.dart';
import '../../../../services/auth/auth_service.dart';
class MentorRegisterScreen
    extends StatefulWidget {
  const MentorRegisterScreen({
    super.key,
  });

  @override
  State<MentorRegisterScreen>
      createState() =>
          _MentorRegisterScreenState();
}

class _MentorRegisterScreenState
    extends State<
        MentorRegisterScreen> {
  final TextEditingController
  nameController =
      TextEditingController();

  final TextEditingController
  phoneController =
      TextEditingController();

  final TextEditingController
  professionController =
      TextEditingController();

  final TextEditingController
  districtController =
      TextEditingController();

  final GlobalKey<FormState>
  _formKey =
      GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();

    phoneController.dispose();

    professionController.dispose();

    districtController.dispose();

    super.dispose();
  }

Future<void> applyMentor() async {
  if (!_formKey.currentState!
      .validate()) {
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    await AuthService.mentorRegister(
      name:
          nameController.text.trim(),

      phone:
          phoneController.text.trim(),

      profession:
          professionController.text
              .trim(),

      district:
          districtController.text
              .trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Mentor Application Submitted",
        ),
      ),
    );

    Navigator.pop(context);
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
          'Mentor Registration',
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
                  height: 20,
                ),

                const Text(
                  "Become a Mentor",
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
                  "Guide and mentor Super500 students",
                  style: TextStyle(
                    color: Colors
                        .grey.shade600,
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                CustomTextField(
                  hintText:
                      'Full Name',

                  controller:
                      nameController,

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return "Name is required";
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                CustomTextField(
                  hintText:
                      'Mobile Number',

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
                  height: 20,
                ),

                CustomTextField(
                  hintText:
                      'Profession',

                  controller:
                      professionController,

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return "Profession is required";
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 35,
                ),

                CustomTextField(
                  hintText:
                      'District',

                  controller:
                      districtController,

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return "District is required";
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 35,
                ),

                CustomButton(
                  text: isLoading
                      ? 'Submitting...'
                      : 'Apply as Mentor',

                  onPressed:
                      isLoading
                          ? null
                          : applyMentor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
