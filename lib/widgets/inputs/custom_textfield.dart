import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;

  final TextEditingController controller;

  final TextInputType keyboardType;

  final bool obscureText;

  final String? Function(String?)? validator;

  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;

  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,

    required this.hintText,

    required this.controller,

    this.keyboardType = TextInputType.text,

    this.obscureText = false,

    this.validator,

    this.maxLines = 1,

    this.inputFormatters,

    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      keyboardType: keyboardType,

      obscureText: obscureText,

      validator: validator,

      maxLines: maxLines,

      inputFormatters: inputFormatters,

      textCapitalization: textCapitalization,

      decoration: InputDecoration(
        hintText: hintText,

        filled: true,

        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: const BorderSide(color: AppColors.border),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: const BorderSide(color: AppColors.border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: const BorderSide(color: Colors.red),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
