import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/translations/locale_keys.g.dart';

class ReusableConfirmButton extends StatelessWidget {
  final VoidCallback onTap;
  const ReusableConfirmButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
        child: Text(
          LocaleKeys.confirm.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
