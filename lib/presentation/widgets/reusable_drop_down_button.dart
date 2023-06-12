import 'package:flutter/material.dart';
import 'package:outsource/resources/app_colors.dart';

class ReusableDropDownButton extends StatefulWidget {
  final String hintText;
  final List<DropdownMenuItem> items;
  final int? value;
  final Function(dynamic) onChanged;

  const ReusableDropDownButton({
    Key? key,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ReusableDropDownButton> createState() => _ReusableDropDownButtonState();
}

class _ReusableDropDownButtonState extends State<ReusableDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.slate400,
      ),
      style: const TextStyle(
        color: AppColors.slate500,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: AppColors.slate500,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.slate400,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.slate400,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.slate400,
            width: 1,
          ),
        ),
      ),
      items: widget.items,
      value: widget.value,
      onChanged: widget.onChanged,
    );
  }
}
