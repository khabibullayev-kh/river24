import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:outsource/resources/app_colors.dart';

class PhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  const PhoneField({Key? key, required this.controller, this.hintText}) : super(key: key);

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  @override
  Widget build(BuildContext context) {
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'UZ',
      newMask: '+000 00 000 00 00',
    );
    return SizedBox(
      height: 60,
      child: TextFormField(
        controller: widget.controller,
        cursorColor: AppColors.slate400,
        keyboardType: TextInputType.phone,
        inputFormatters: [PhoneInputFormatter()],
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.slate900,
        ),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: AppColors.slate500,
            fontSize: 16,
          ),
          prefixIcon: widget.hintText == null ? const Icon(
            Icons.phone,
          ) : null,
          prefixIconColor: AppColors.slate900,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 1,
                color: AppColors.slate400,
              )),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 1,
                color: AppColors.slate400,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 1,
                color: AppColors.slate400,
              )),
        ),
      ),
    );
  }
}