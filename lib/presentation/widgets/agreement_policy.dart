import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/translations/locale_keys.g.dart';

class AgreementPolicy extends StatelessWidget {
  const AgreementPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "${LocaleKeys.policy1.tr()}\n",
        children: [
          TextSpan(
            text: LocaleKeys.policy_with.tr(),
            style: const TextStyle(
              color: AppColors.slate900,
            ),
          ),
          TextSpan(
              text: LocaleKeys.policy_conf.tr(),
              style: const TextStyle(
                color: AppColors.green500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => print("SIGNIN")),
          TextSpan(
            text: " ${LocaleKeys.and.tr()}\n",
            style: const TextStyle(
              color: AppColors.slate900,
            ),
          ),
          TextSpan(
              text: LocaleKeys.user_agreement.tr(),
              style: const TextStyle(
                color: AppColors.green500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => print("SIGNIN")),
          TextSpan(
            text: ' ${LocaleKeys.confirm_them.tr()}',
            style: const TextStyle(
              color: AppColors.slate900,
            ),
          ),
        ],
        style: const TextStyle(
          color: AppColors.slate900,
          fontSize: 14,
        ),
      ),
      textAlign: TextAlign.center,
    );
  }
}
