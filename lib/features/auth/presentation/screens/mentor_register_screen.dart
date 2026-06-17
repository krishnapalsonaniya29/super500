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

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius:
                        BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary
                            .withOpacity(0.25),
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
                            padding:
                                const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                              child: Image.asset(
                                "assets/images/app_logo2.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mentor Registration",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  "Super500 Mentorship Program",
                                  style: TextStyle(
                                    color:
                                        Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Image.asset(
                        "assets/images/mentor_role.png",
                        height: 120,
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "Become a Mentor",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Guide, inspire and support talented Super500 students in their educational journey.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              Colors.white.withOpacity(
                            0.85,
                          ),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                

                const SizedBox(height: 20),const Text(
                  "Application Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),
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
