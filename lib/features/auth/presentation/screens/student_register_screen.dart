import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/features/student/presentation/screens/student_dashboard_screen.dart';
import 'package:flutter_application_1/services/student/student_service.dart';

class StudentRegisterScreen
    extends StatefulWidget {
  const StudentRegisterScreen({
    super.key,
  });

  @override
  State<StudentRegisterScreen>
      createState() =>
          _StudentRegisterScreenState();
}

class _StudentRegisterScreenState
    extends State<StudentRegisterScreen> {
  static const int samagraLength = 9;

  final formKey =
      GlobalKey<FormState>();

  final samagraController =
      TextEditingController();
  final fullNameController =
      TextEditingController();
  final fatherNameController =
      TextEditingController();
  final districtController =
      TextEditingController();
  final genderController =
      TextEditingController();
  final dateOfBirthController =
      TextEditingController();
  final addressController =
      TextEditingController();
  final categoryController =
      TextEditingController();
  final schoolController =
      TextEditingController();
  final currentClassController =
      TextEditingController();
  final annualIncomeController =
      TextEditingController();
  final marksController =
      TextEditingController();
  final pincodeController =
      TextEditingController();

  static const List<String>
      classOptions = [
    '10',
    '11',
    '12',
  ];

  final Map<String, _SelectedDocument>
      selectedDocuments = {};
  bool documentsUploaded = false;

  bool loading = false;
  bool samagraFetched = false;

  @override
  void initState() {
    super.initState();
    _loadExistingDocuments();
  }

  @override
  void dispose() {
    samagraController.dispose();
    fullNameController.dispose();
    fatherNameController.dispose();
    districtController.dispose();
    genderController.dispose();
    dateOfBirthController.dispose();
    addressController.dispose();
    categoryController.dispose();
    schoolController.dispose();
    currentClassController.dispose();
    annualIncomeController.dispose();
    marksController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingDocuments() async {
    try {
      final documents =
          await StudentService
              .getMyDocuments();
      final uploadedTypes = documents
          .map(
            (item) =>
                item["documentType"]
                    ?.toString(),
          )
          .whereType<String>()
          .toSet();

      if (!mounted) return;

      setState(() {
        documentsUploaded =
            uploadedTypes.containsAll(
          const {
            'MARKSHEET',
            'AADHAR',
            'PHOTO',
            'CASTE_CERTIFICATE',
            'INCOME_CERTIFICATE',
          },
        );
      });
    } catch (_) {
      // Ignore document preload failures and let the user continue manually.
    }
  }

  Future<void> fetchSamagra() async {
    final samagraId =
        samagraController.text.trim();

    if (samagraId.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Enter Samagra ID first",
          ),
        ),
      );
      return;
    }

    if (samagraId.length <
        samagraLength) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Samagra ID must be 9 digits",
          ),
        ),
      );
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      final response =
          await StudentService
              .fetchSamagra(
        samagraId,
      );

      final samagra =
          Map<String, dynamic>.from(
        response["data"]
                ?["samagra"] ??
            {},
      );

      fullNameController.text =
          samagra["fullName"] ?? "";
      fatherNameController.text =
          samagra["fatherName"] ?? "";
      districtController.text =
          samagra["district"] ?? "";
      genderController.text =
          samagra["gender"] ?? "";
      dateOfBirthController.text =
          samagra["dateOfBirth"] ?? "";
      addressController.text =
          samagra["address"] ?? "";
      categoryController.text =
          samagra["category"] ?? "";

      if (!mounted) return;

      setState(() {
        samagraFetched = true;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Samagra details fetched successfully",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> completeProfile() async {
    if (!formKey.currentState!
        .validate()) {
      return;
    }

    if (!documentsUploaded) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Upload all required documents before completing registration",
          ),
        ),
      );
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      await StudentService
          .completeProfile(
        payload: {
          "samagraId":
              samagraController.text
                  .trim(),
          "schoolName":
              schoolController.text
                  .trim(),
          "currentClass":
              currentClassController.text
                  .trim(),
          "annualIncome":
              double.parse(
            annualIncomeController.text
                .trim(),
          ),
          "marks10th":
              double.parse(
            marksController.text
                .trim(),
          ), 
          "pincode":
              pincodeController.text
                  .trim(),
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Profile completed successfully",
          ),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const StudentDashboardScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> pickDocument({
    required String fieldKey,
    required List<String>
        allowedExtensions,
    required bool imageOnly,
  }) async {
    final result =
        await FilePicker.platform.pickFiles(
      type: imageOnly
          ? FileType.image
          : FileType.custom,
      allowedExtensions:
          imageOnly
              ? null
              : allowedExtensions,
      withData: true,
    );

    final file =
        result?.files.single;

    if (file?.bytes == null) {
      return;
    }

    setState(() {
      selectedDocuments[fieldKey] =
          _SelectedDocument(
        fileName: file!.name,
        bytes: file.bytes!,
        contentType:
            _resolveContentType(
          file.extension,
          imageOnly: imageOnly,
        ),
      );
      documentsUploaded = false;
    });
  }

  Future<void> uploadDocuments() async {
    const requiredFields = [
      'marksheet',
      'aadhar',
      'photo',
      'casteCertificate',
      'incomeCertificate',
    ];

    final missingFields =
        requiredFields.where(
      (field) =>
          !selectedDocuments
              .containsKey(field),
    );

    if (missingFields.isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please select all required documents",
          ),
        ),
      );
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      final files =
          <String, dynamic>{};

      for (final entry
          in selectedDocuments.entries) {
        final document =
            entry.value;
        files[entry.key] =
            StudentService
                .buildMultipartFile(
          bytes: document.bytes,
          filename:
              document.fileName,
          contentType:
              document.contentType,
        );
      }

      await StudentService
          .uploadDocuments(
        files:
            Map<String,
                MultipartFile>.from(
          files,
        ),
      );

      if (!mounted) return;

      setState(() {
        documentsUploaded = true;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Documents uploaded successfully",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }
  String _resolveContentType(
    String? extension, {
    required bool imageOnly,
  }) {
    final normalized =
        extension
            ?.toLowerCase()
            .trim();

    if (normalized == 'png') {
      return 'image/png';
    }

    if (normalized == 'jpg' ||
        normalized == 'jpeg') {
      return 'image/jpeg';
    }

    if (!imageOnly &&
        normalized == 'pdf') {
      return 'application/pdf';
    }

    return imageOnly
        ? 'image/jpeg'
        : 'application/pdf';
  }

  Widget buildField({
    required String hint,
    required TextEditingController
        controller,
    TextInputType keyboard =
        TextInputType.text,
    bool enabled = true,
    String? Function(String?)? validator,
    List<TextInputFormatter>?
        inputFormatters,
    bool readOnly = false,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        readOnly: readOnly,
        keyboardType: keyboard,
        inputFormatters:
            inputFormatters,
        validator:
            validator ??
            (value) {
          if (value == null ||
              value.trim().isEmpty) {
            return "$hint is required";
          }

          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: enabled
              ? readOnly
                  ? Colors.grey.shade100
                  : Colors.white
              : Colors.grey.shade200,
          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
            borderSide:
                BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget buildClassDropdown() {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),
      child:
          DropdownButtonFormField<String>(
        initialValue:
            currentClassController
                    .text
                .isEmpty
                ? null
                : currentClassController
                    .text,
        items: classOptions
            .map(
              (value) =>
                  DropdownMenuItem(
                value: value,
                child: Text(
                  value,
                ),
              ),
            )
            .toList(),
        onChanged: loading
            ? null
            : (value) {
                currentClassController
                    .text = value ?? '';
              },
        validator: (value) {
          if (value == null ||
              value.isEmpty) {
            return "Current Class is required";
          }

          return null;
        },
        decoration: InputDecoration(
          hintText: "Current Class",
          filled: true,
          fillColor: Colors.white,
          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
            borderSide:
                BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget buildUploadCard({
    required String title,
    required String fieldKey,
    required VoidCallback onTap,
  }) {
    final fileName =
        selectedDocuments[fieldKey]
            ?.fileName;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.upload_file,
            color: Color(0xFF0A1931),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  fileName ??
                      "No file selected",
                  style: TextStyle(
                    color:
                        fileName == null
                            ? Colors.grey
                            : Colors.green,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed:
                loading ? null : onTap,
            child: const Text(
              "Choose",
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            Colors.transparent,
        title: const Text(
          "Student Onboarding",
          style: TextStyle(
            color: Colors.black,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(
              20,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                const Text(
                  "Complete Registration",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Link Samagra first, then fill the remaining student details.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                buildField(
                  hint: "Samagra ID",
                  controller:
                      samagraController,
                  keyboard:
                      TextInputType.number,
                  enabled: !samagraFetched,
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly,
                    LengthLimitingTextInputFormatter(
                      samagraLength,
                    ),
                  ],
                  validator: (value) {
                    final samagraId =
                        value?.trim() ?? "";

                    if (samagraId
                        .isEmpty) {
                      return "Samagra ID is required";
                    }

                    if (samagraId.length <
                        samagraLength) {
                      return "Samagra ID must be 9 digits";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: loading ||
                            samagraFetched
                        ? null
                        : fetchSamagra,
                    child: Text(
                      loading
                          ? "Please wait..."
                          : samagraFetched
                              ? "Samagra Linked"
                              : "Fetch Samagra Details",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 28,
                ),
                if (samagraFetched) ...[
                  buildField(
                    hint: "Full Name",
                    controller:
                        fullNameController,
                    readOnly: true,
                  ),
                  buildField(
                    hint: "Father Name",
                    controller:
                        fatherNameController,
                    readOnly: true,
                  ),
                  buildField(
                    hint: "District",
                    controller:
                        districtController,
                    readOnly: true,
                  ),
                  buildField(
                    hint: "Gender",
                    controller:
                        genderController,
                    readOnly: true,
                  ),
                  buildField(
                    hint:
                        "Date of Birth (YYYY-MM-DD)",
                    controller:
                        dateOfBirthController,
                    readOnly: true,
                  ),
                  buildField(
                    hint: "Address",
                    controller:
                        addressController,
                    readOnly: true,
                  ),
                  buildField(
                    hint: "Category",
                    controller:
                        categoryController,
                    readOnly: true,
                  ),
                  buildField(
                    hint: "School Name",
                    controller:
                        schoolController,
                  ),
                  buildClassDropdown(),
                  buildField(
                    hint: "Annual Income",
                    controller:
                        annualIncomeController,
                    keyboard:
                        TextInputType.number,
                  ),
                  buildField(
                    hint: "10th Marks",
                    controller:
                        marksController,
                    keyboard:
                        TextInputType.number,
                  ),
                  buildField(
                    hint: "Pincode",
                    controller:
                        pincodeController,
                    keyboard:
                        TextInputType.number,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Upload Documents",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Upload all required documents before completing registration.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildUploadCard(
                    title:
                        "10th Marksheet (PDF)",
                    fieldKey:
                        "marksheet",
                    onTap: () =>
                        pickDocument(
                      fieldKey:
                          "marksheet",
                      allowedExtensions: [
                        'pdf',
                      ],
                      imageOnly:
                          false,
                    ),
                  ),
                  buildUploadCard(
                    title:
                        "Aadhar Card (PDF)",
                    fieldKey:
                        "aadhar",
                    onTap: () =>
                        pickDocument(
                      fieldKey:
                          "aadhar",
                      allowedExtensions: [
                        'pdf',
                      ],
                      imageOnly:
                          false,
                    ),
                  ),
                  buildUploadCard(
                    title:
                        "Student Photo (JPG/PNG)",
                    fieldKey: "photo",
                    onTap: () =>
                        pickDocument(
                      fieldKey:
                          "photo",
                      allowedExtensions: const [],
                      imageOnly: true,
                    ),
                  ),
                  buildUploadCard(
                    title:
                        "Caste Certificate (PDF)",
                    fieldKey:
                        "casteCertificate",
                    onTap: () =>
                        pickDocument(
                      fieldKey:
                          "casteCertificate",
                      allowedExtensions: [
                        'pdf',
                      ],
                      imageOnly:
                          false,
                    ),
                  ),
                  buildUploadCard(
                    title:
                        "Income Certificate (PDF)",
                    fieldKey:
                        "incomeCertificate",
                    onTap: () =>
                        pickDocument(
                      fieldKey:
                          "incomeCertificate",
                      allowedExtensions: [
                        'pdf',
                      ],
                      imageOnly:
                          false,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: loading
                          ? null
                          : uploadDocuments,
                      child: Text(
                        loading
                            ? "Please wait..."
                            : documentsUploaded
                                ? "Documents Uploaded"
                                : "Upload Documents",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : completeProfile,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                          0xFF0A1931,
                        ),
                        foregroundColor:
                            Colors.white,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),
                      child: Text(
                        loading
                            ? "Please wait..."
                            : "Complete Profile",
                        style:
                            const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedDocument {
  const _SelectedDocument({
    required this.fileName,
    required this.bytes,
    required this.contentType,
  });

  final String fileName;
  final List<int> bytes;
  final String contentType;
}
