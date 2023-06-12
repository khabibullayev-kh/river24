import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/resources/app_icons.dart';
import 'package:outsource/translations/locale_keys.g.dart';

class RiverLogo extends StatelessWidget {
  final String welcomeText;
  const RiverLogo({Key? key, required this.welcomeText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset(
          width: 50,
          height: 50,
          AppIcons.riverLogo,
        ),
        const SizedBox(height: 10),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: '$welcomeText\n',
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.slate900,
            ),
            children: const <TextSpan>[
              TextSpan(
                text: 'RIVER',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.slate900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: '24',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.green500,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
