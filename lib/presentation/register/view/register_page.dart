import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:outsource/data/bloc/choose_lang_bloc.dart';
import 'package:outsource/navigation/route_name.dart';
import 'package:outsource/presentation/register/bloc/register_bloc.dart';
import 'package:outsource/presentation/widgets/agreement_policy.dart';
import 'package:outsource/presentation/widgets/choose_lang_widget.dart';
import 'package:outsource/presentation/widgets/river_logo.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = RegisterBloc();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider.value(
      value: _bloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          top: false,
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
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginPageBody extends StatelessWidget {
  const _LoginPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.select((RegisterBloc bloc) => bloc.data.langText);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: <Widget>[
            SizedBox(height: constraints.maxHeight > 890 ? 92 : 75),
            const _ChooseLanguageButton(),
            SizedBox(height: constraints.maxHeight > 890 ? 24 : 20),
            RiverLogo(welcomeText: LocaleKeys.welcome.tr(),),
            SizedBox(height: constraints.maxHeight > 890 ? 100 : 64),
            const _RegisterText(),
            SizedBox(height: constraints.maxHeight > 890 ? 24 : 20),
            const _PhoneField(),
            SizedBox(height: constraints.maxHeight > 890 ? 16 : 12),
            const _SignInButtonRow(),
            const Expanded(child: SizedBox()),
            const Divider(thickness: 1, height: 1),
            const SizedBox(height: 24),
            const AgreementPolicy(),
            const SizedBox(height: 16),
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

class _RegisterText extends StatelessWidget {
  const _RegisterText();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<RegisterBloc>();
    return Align(
      alignment: Alignment.center,
      child: Text(
        LocaleKeys.register.tr(),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2D283F),
        ),
      ),
    );
  }
}

class _PhoneField extends StatefulWidget {
  const _PhoneField({Key? key}) : super(key: key);

  @override
  State<_PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<_PhoneField> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterBloc>();
    final phoneController = bloc.data.phoneController;
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'UZ',
      newMask: '+000 00 000 00 00',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 60,
        child: TextFormField(
          controller: phoneController,
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
            prefixIcon: const Icon(
              Icons.phone,
            ),
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
      ),
    );
  }
}

class _SignInButtonRow extends StatelessWidget {
  const _SignInButtonRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<RegisterBloc>();
    final isHeight = MediaQuery.of(context).size.height > 900;
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await bloc.sendSms();
                if (bloc.data.isLogin) {
                  Navigator.of(context).pushNamed(
                    RouteName.loginPin.route,
                    arguments: bloc,
                  );
                } else if (bloc.data.phoneController.text.length > 5) {
                  Navigator.of(context).pushNamed(
                    RouteName.confirmNumberPage.route,
                    arguments: bloc,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.red500,
                      content: Text(
                        LocaleKeys.enter_phone_number.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }

                if (bloc.data.message.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.red500,
                      content: Text(
                        bloc.data.message,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
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
                child: Text(
                  LocaleKeys.register.tr(),
                  style: TextStyle(
                    fontSize: isHeight ? 14 : 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}