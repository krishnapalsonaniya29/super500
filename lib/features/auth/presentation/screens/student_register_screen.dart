import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// import '../../../../services/auth/auth_service.dart';
import '../../../../widgets/buttons/custom_button.dart';
import '../../../../widgets/inputs/custom_textfield.dart';
import 'otp_verification_screen.dart';

class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  State<StudentRegisterScreen> createState() =>
      _StudentRegisterScreenState();
}

class _StudentRegisterScreenState
    extends State<StudentRegisterScreen> {

  // =========================
  // PERSONAL INFO
  // =========================

  final fullNameController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  final genderController = TextEditingController();

  final dobController = TextEditingController();

  final fatherNameController = TextEditingController();

  // =========================
  // GOVERNMENT INFO
  // =========================

  final samagraController = TextEditingController();

  final apaarController = TextEditingController();

  // =========================
  // ACADEMIC INFO
  // =========================

  final schoolController = TextEditingController();

  final classController = TextEditingController();

  final marksController = TextEditingController();

  final joiningYearController = TextEditingController();

  final currentYearController = TextEditingController();

  // =========================
  // ADDRESS INFO
  // =========================

  final addressController = TextEditingController();

  final districtController = TextEditingController();

  final stateController = TextEditingController();

  final pincodeController = TextEditingController();

  // =========================
  // ADDITIONAL INFO
  // =========================

  final categoryController = TextEditingController();

  final incomeController = TextEditingController();

  // =========================
  // BANK INFO
  // =========================

  final accountNumberController = TextEditingController();

  final ifscController = TextEditingController();

  final bankNameController = TextEditingController();

  // =========================
  // LOADING
  // =========================

  bool isLoading = false;

//   Future<void> registerStudent() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       final response =
//     await AuthService.sendOtp(
//   phone: phoneController.text.trim(),
// );

//       if (response.statusCode == 200 ||
//           response.statusCode == 201) {

//         if (!mounted) return;

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content:
//                 Text('OTP sent successfully'),
//           ),
//         );

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) =>
//                 OtpVerificationScreen(
//               phoneNumber:
//                   phoneController.text.trim(),
//             ),
//           ),
//         );
//       }
//     } on DioException catch (e) {
//       String errorMessage =
//           'Registration failed';

//       if (e.response != null &&
//           e.response?.data != null) {

//         errorMessage =
//             e.response?.data['message'] ??
//                 errorMessage;
//       }

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

Future<void> registerStudent() async {

  try {

    setState(() {
      isLoading = true;
    });

    // Fake loading delay
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'OTP sent successfully',
        ),
      ),
    );

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) =>
            OtpVerificationScreen(
          phoneNumber:
              phoneController.text.trim(),
        ),
      ),
    );

  } catch (e) {

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );

  } finally {

    if (mounted) {

      setState(() {
        isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              const Text(
                'Create Student Account',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Fill your details to apply for Super 500 scholarship',
              ),

              const SizedBox(height: 30),

              // ====================================================
              // PERSONAL INFORMATION
              // ====================================================

              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              CustomTextField(
                hintText: 'Full Name',
                controller: fullNameController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Mobile Number',
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Email Address',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Gender',
                controller: genderController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Date of Birth (DD/MM/YYYY)',
                controller: dobController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Father Name',
                controller: fatherNameController,
              ),

              const SizedBox(height: 30),

              // ====================================================
              // GOVERNMENT INFORMATION
              // ====================================================

              const Text(
                'Government Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              CustomTextField(
                hintText: 'Samagra ID',
                controller: samagraController,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'APAAR ID',
                controller: apaarController,
              ),

              const SizedBox(height: 30),

              // ====================================================
              // ACADEMIC INFORMATION
              // ====================================================

              const Text(
                'Academic Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              CustomTextField(
                hintText: 'School Name',
                controller: schoolController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Current Class',
                controller: classController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Total Marks obtained in 10th Standard',
                controller: marksController,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Joining Year',
                controller: joiningYearController,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Current Academic Year',
                controller: currentYearController,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 30),

              // ====================================================
              // ADDRESS INFORMATION
              // ====================================================

              const Text(
                'Address Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              CustomTextField(
                hintText: 'Full Address',
                controller: addressController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'District',
                controller: districtController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'State',
                controller: stateController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Pincode',
                controller: pincodeController,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 30),

              // ====================================================
              // ADDITIONAL INFORMATION
              // ====================================================

              const Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              CustomTextField(
                hintText: 'Category',
                controller: categoryController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Annual Family Income',
                controller: incomeController,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 30),

              // ====================================================
              // BANK INFORMATION
              // ====================================================

              const Text(
                'Bank Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              CustomTextField(
                hintText: 'Bank Account Number',
                controller: accountNumberController,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'IFSC Code',
                controller: ifscController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Bank Name',
                controller: bankNameController,
              ),

              const SizedBox(height: 40),

             CustomButton(
                text: 'Continue Registration',
                isLoading: isLoading,
                onPressed: registerStudent,
             ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}