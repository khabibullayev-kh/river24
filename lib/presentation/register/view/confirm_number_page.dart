import 'dart:async';

import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outsource/data/bloc/choose_lang_bloc.dart';
import 'package:outsource/navigation/route_name.dart';
import 'package:outsource/presentation/register/bloc/register_bloc.dart';
import 'package:outsource/presentation/widgets/agreement_policy.dart';
import 'package:outsource/presentation/widgets/choose_lang_widget.dart';
import 'package:outsource/presentation/widgets/river_logo.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/resources/app_icons.dart';
import 'package:outsource/translations/locale_keys.g.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ConfirmNumberPage extends StatefulWidget {
  final RegisterBloc bloc;

  const ConfirmNumberPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<ConfirmNumberPage> createState() => _ConfirmNumberPageState();
}

class _ConfirmNumberPageState extends State<ConfirmNumberPage> {
  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider.value(
      value: widget.bloc,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              fit: StackFit.loose,
              children: [
                Positioned(
                  top: maxHeight > 900 ? -1616 : -1670,
                  left: -726,
                  child: Container(
                    height: 1882,
                    width: 1882,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFFE5E7EB),
                      ),
                    ),
                  ),
                ),
                const _LoginPageBody(),
                const _LoadingWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((RegisterBloc bloc) => bloc.data.isLoading);
    return isLoading
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white.withOpacity(0.5),
            child: const Center(child: CircularProgressIndicator()),
          )
        : const SizedBox();
  }
}

class _LoginPageBody extends StatelessWidget {
  const _LoginPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: <Widget>[
            SizedBox(height: constraints.maxHeight > 900 ? 92 : 70),
            const _ChooseLanguageButton(),
            SizedBox(height: constraints.maxHeight > 900 ? 24 : 20),
            RiverLogo(
              welcomeText: LocaleKeys.welcome.tr(),
            ),
            SizedBox(height: constraints.maxHeight > 900 ? 102 : 64),
            const _ConfirmText(),
            SizedBox(height: constraints.maxHeight > 900 ? 16 : 14),
            const _ConfirmInfoText(),
            SizedBox(height: constraints.maxHeight > 900 ? 24 : 20),
            const _EnterPinRow(),
            SizedBox(height: constraints.maxHeight > 900 ? 24 : 20),
            const _TryAgainText(),
            SizedBox(height: constraints.maxHeight > 900 ? 24 : 20),
            const _SignInButton(),
            SizedBox(height: constraints.maxHeight > 800 ? 150 : 40),
            const Divider(thickness: 1, height: 1),
            const SizedBox(height: 24),
            const AgreementPolicy(),
          ],
        );
      },
    );
  }
}

class _ChooseLanguageButton extends StatelessWidget {
  const _ChooseLanguageButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<RegisterBloc>();
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ChangeNotifierProvider(
              create: (_) => ChooseLangBloc(),
              child: const ChooseLangWidget(),
            );
          },
        ).whenComplete(() async {
          await bloc.loadLang();
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Align(
          alignment: Alignment.topRight,
          child: Text(
            '${LocaleKeys.lang_text.tr()} ${bloc.data.langText}',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.slate500,
            ),
          ),
        ),
      ),
    );
  }
}

class _RiverLogo extends StatelessWidget {
  const _RiverLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Image.asset(
          width: maxHeight > 900 ? 50 : 40,
          height: maxHeight > 900 ? 50 : 40,
          AppIcons.riverLogo,
        ),
        SizedBox(height: maxHeight > 900 ? 10 : 7),
        Image.asset(
          width: maxHeight > 900 ? 197 : 150,
          height: maxHeight > 900 ? 30 : 26,
          AppIcons.welcomeLogo,
        ),
      ],
    );
  }
}

class _ConfirmText extends StatelessWidget {
  const _ConfirmText();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        LocaleKeys.confirm_phone_number.tr(),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2D283F),
        ),
      ),
    );
  }
}

class _EnterPinRow extends StatefulWidget {
  const _EnterPinRow({Key? key}) : super(key: key);

  @override
  State<_EnterPinRow> createState() => _EnterPinRowState();
}

class _EnterPinRowState extends State<_EnterPinRow> {
  String _comingSms = 'Unknown';
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    initSmsListener();
  }

  Future<void> initSmsListener() async {
    String? comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;
    setState(() {
      _comingSms = comingSms ?? '';
      RegExp smsCode = RegExp(r"\d{5}");
      RegExpMatch? match = smsCode.firstMatch(_comingSms);
      textEditingController.text = match?[0] ??
          ''; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
    });
  }

  @override
  void dispose() {
    AltSmsAutofill().unregisterListener();
    //textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<RegisterBloc>();
    // final pinController = model.data.pinController;
    // final pinLength = model.data.pinLength;
    // final isObscured = model.data.isObscured;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final maxWidth = constraints.maxWidth;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: PinCodeTextField(
            length: 5,
            controller: textEditingController,
            enableActiveFill: true,
            onCompleted: (value) async {
              bloc.data.code = value;
              await bloc.confirmCode();
              if (bloc.data.isLogin) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteName.enterPin.route,
                  (Route<dynamic> route) => false,
                );
              } else if (bloc.data.isSuccess) {
                Navigator.of(context).pushReplacementNamed(
                  RouteName.lastStep.route,
                  arguments: bloc,
                );
              }
              if (bloc.data.message.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: AppColors.red500,
                  content: Text(bloc.data.message),
                ));
              }
            },
            textStyle: const TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            appContext: context,
            obscureText: false,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //obscuringCharacter: '*',
            keyboardType: TextInputType.number,
            animationType: AnimationType.fade,
            cursorColor: AppColors.slate500,
            autoFocus: true,

            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              fieldHeight: maxHeight > 900 ? 75 : 60,
              fieldWidth: maxHeight > 900 ? 70 : 55,
              activeColor: AppColors.grey200,
              inactiveColor: AppColors.grey200,
              selectedColor: AppColors.grey200,
              inactiveFillColor: Colors.white,
              selectedFillColor: Colors.white,
              activeFillColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              borderWidth: 1,
            ),
            onChanged: (String value) {},
          ),
        );
      },
    );
  }
}

class _ConfirmInfoText extends StatelessWidget {
  const _ConfirmInfoText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterBloc>();
    final data = bloc.data;
    return RichText(
      text: TextSpan(
        text: "${LocaleKeys.sent_to_phone.tr()}\n",
        children: [
          TextSpan(
            text:
                "${LocaleKeys.ru_to_number.tr() != ' ' ? "${LocaleKeys.ru_to_number.tr()} " : ''}+${data.phoneNumber}${LocaleKeys.uz_to_number.tr()}.\n",
            style: const TextStyle(
              color: AppColors.slate900,
            ),
          ),
          TextSpan(
              text: LocaleKeys.change_number.tr(),
              style: const TextStyle(
                color: AppColors.green500,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w700,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pop(context)),
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

class _TryAgainText extends StatefulWidget {
  const _TryAgainText({Key? key}) : super(key: key);

  @override
  State<_TryAgainText> createState() => _TryAgainTextState();
}

class _TryAgainTextState extends State<_TryAgainText> {
  late Timer _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          // setState(() {
          //   timer.cancel();
          // });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterBloc>();
    return RichText(
      text: TextSpan(
        text: "${LocaleKeys.dont_get_sms.tr()}\n",
        children: _start != 0
            ? [
                if (LocaleKeys.repeat_after_ru.tr() != ' ')
                  TextSpan(
                    text: LocaleKeys.repeat_after_ru.tr(),
                    style: const TextStyle(
                      color: AppColors.green500,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        // bloc.resendSms();
                        // setState(() {
                        //   _start = 60;
                        //
                        // });
                      },
                  ),
                TextSpan(
                  text:
                      "${LocaleKeys.repeat_after_ru.tr() != ' ' ? " ${LocaleKeys.repeat_after_ru.tr()}" : ''} $_start${LocaleKeys.repeat_uz.tr()}\n",
                  style: const TextStyle(
                    color: AppColors.slate900,
                  ),
                ),
                if (LocaleKeys.repeat_uz2.tr() != ' ')
                  TextSpan(
                    text: LocaleKeys.repeat_uz2.tr(),
                    style: const TextStyle(
                      color: AppColors.green500,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        // bloc.resendSms();
                        // setState(() {
                        //   _start = 60;
                        //
                        // });
                      },
                  ),
              ]
            : [
                TextSpan(
                  text: LocaleKeys.repeat.tr(),
                  style: const TextStyle(
                    color: AppColors.green500,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      bloc.resendSms();
                      setState(() {
                        _start = 60;
                      });
                    },
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

class _SignInButton extends StatelessWidget {
  const _SignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isHeight = MediaQuery.of(context).size.height > 900;
    final bloc = context.read<RegisterBloc>();
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 16),
        child: ElevatedButton(
          onPressed: () async {
            await bloc.confirmCode();
            if (bloc.data.isLogin) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                RouteName.enterPin.route,
                (Route<dynamic> route) => false,
              );
            } else if (bloc.data.isSuccess) {
              Navigator.of(context).pushReplacementNamed(
                RouteName.lastStep.route,
                arguments: bloc,
              );
            }
            if (bloc.data.message.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColors.red500,
                content: Text(bloc.data.message),
              ));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // <-- Radius
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isHeight ? 32 : 20,
              vertical: isHeight ? 16 : 14,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppIcons.done),
                const SizedBox(width: 10),
                Text(
                  LocaleKeys.confirm.tr(),
                  style: TextStyle(
                    fontSize: isHeight ? 14 : 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
