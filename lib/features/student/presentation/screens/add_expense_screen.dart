import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../services/student/student_service.dart';
import '../../../../theme/app_colors.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();

  final amountController = TextEditingController();

  final descriptionController = TextEditingController();

  bool isLoading = false;

  Uint8List? receiptBytes;
  String? receiptName;

  String category = "BOOKS";

  final List<String> categories = [
    "BOOKS",
    "LAPTOP",
    "STATIONERY",
    "INTERNET",
    "COURSE",
    "OTHER",
  ];

  Future<void> pickReceipt() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      setState(() {
        receiptBytes = result.files.single.bytes;

        receiptName = result.files.single.name;
      });
    }
  }

  Future<void> submitExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      MultipartFile? receipt;

      if (receiptBytes != null) {
        receipt = MultipartFile.fromBytes(receiptBytes!, filename: receiptName);
      }

      await StudentService.createExpense(
        title: titleController.text.trim(),
        amount: double.parse(amountController.text.trim()),
        category: category,
        description: descriptionController.text.trim(),
        receipt: receipt,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expense added successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(title: const Text("Add Expense")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Expense Title"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter title";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter amount";
                  }

                  if (double.tryParse(value) == null) {
                    return "Enter valid amount";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(labelText: "Category"),
                items: categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    category = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: "Description"),
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: pickReceipt,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: receiptBytes == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file, size: 50),
                            SizedBox(height: 8),
                            Text("Upload Receipt"),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(receiptBytes!, fit: BoxFit.cover),
                        ),
                ),
              ),

              if (receiptName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    receiptName!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submitExpense,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Submit Expense"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
