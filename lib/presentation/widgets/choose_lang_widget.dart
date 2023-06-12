import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:outsource/data/bloc/choose_lang_bloc.dart';
import 'package:outsource/presentation/widgets/reusable_confirm_button.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';

class ChooseLangWidget extends StatefulWidget {
  const ChooseLangWidget({Key? key}) : super(key: key);

  @override
  State<ChooseLangWidget> createState() => _ChooseLangWidgetState();
}

class _ChooseLangWidgetState extends State<ChooseLangWidget> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ChooseLangBloc>();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    LocaleKeys.choose_language_text.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.slate900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.slate900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const _LangsBuilder(),
            const SizedBox(height: 24),
            ReusableConfirmButton(
              onTap: () async {
                bloc.confirmLang(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _LangsBuilder extends StatelessWidget {
  const _LangsBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ChooseLangBloc>();
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final lang = Languages.values[index];
        final langTrue = lang.slug == bloc.data.currentLang;
        return _LangContainer(
          langName: lang.name,
          textColor: langTrue ? AppColors.green600 : AppColors.slate500,
          containerColor: langTrue ? AppColors.green200 : AppColors.slate100,
          onTap: () {
            bloc.setCurrentLang(index);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemCount: Languages.values.length,
    );
  }
}

class _LangContainer extends StatelessWidget {
  final String langName;
  final Color textColor;
  final Color containerColor;
  final VoidCallback onTap;

  const _LangContainer({
    Key? key,
    required this.langName,
    required this.textColor,
    required this.containerColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              langName,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
