import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:outsource/navigation/route_name.dart';
import 'package:outsource/presentation/register/bloc/register_bloc.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/resources/app_icons.dart';
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
    final maxWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider.value(
      value: _bloc,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
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
                  // if (_bloc.data.isLoading)
                  //   const Center(
                  //     child: CircularProgressIndicator(),
                  //   )
                ],
              ),
            ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: <Widget>[
            SizedBox(height: constraints.maxHeight > 900 ? 92 : 70),
            const _ChooseLanguageButton(),
            SizedBox(height: constraints.maxHeight > 900 ? 24 : 20),
            const _RiverLogo(),
            SizedBox(height: constraints.maxHeight > 900 ? 102 : 64),
            const _RegisterText(),
            SizedBox(height: constraints.maxHeight > 900 ? 24 : 20),
            const _PhoneField(),
            SizedBox(height: constraints.maxHeight > 900 ? 16 : 12),
            const _PasswordField(),
            SizedBox(height: constraints.maxHeight > 900 ? 16 : 12),
            const _NewPasswordField(),
            SizedBox(height: constraints.maxHeight > 900 ? 16 : 12),
            const _SignInButtonRow(),
            SizedBox(height: constraints.maxHeight > 800 ? 150 : 50),
            //const Expanded(child: SizedBox()),
            const Divider(thickness: 1, height: 1),
            const SizedBox(height: 24),
            const _AgreementPolicy(),
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
    return const Padding(
      padding: EdgeInsets.only(right: 16.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          'Язык: Русский',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.slate500,
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

class _RegisterText extends StatelessWidget {
  const _RegisterText();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: Text(
        'Регистрация',
        style: TextStyle(
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

class _PasswordField extends StatefulWidget {
  const _PasswordField({Key? key}) : super(key: key);

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 60,
        child: TextFormField(
          cursorColor: AppColors.slate400,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.slate900,
          ),
          obscureText: true,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Новый пароль',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: AppColors.slate900,
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Image(
                width: 17,
                height: 19,
                image: AssetImage(
                  AppIcons.lock,
                ),
              ),
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

class _NewPasswordField extends StatefulWidget {
  const _NewPasswordField({Key? key}) : super(key: key);

  @override
  State<_NewPasswordField> createState() => _NewPasswordFieldState();
}

class _NewPasswordFieldState extends State<_NewPasswordField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 60,
        child: TextFormField(
          cursorColor: AppColors.slate400,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.slate900,
          ),
          obscureText: true,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Подтвердите новый пароль',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: AppColors.slate900,
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Image(
                width: 17,
                height: 19,
                image: AssetImage(
                  AppIcons.lock,
                ),
              ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: "У вас уже есть аккаунт?\n",
                children: [
                  TextSpan(
                      text: "Войдите в систему",
                      style: const TextStyle(
                        color: AppColors.green500,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context)
                              .pushReplacementNamed(RouteName.login.route);
                        }),
                ],
                style: const TextStyle(
                  color: AppColors.slate900,
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await bloc.sendSms();
                if (bloc.data.isSuccess) {
                  Navigator.of(context).pushNamed(
                      RouteName.confirmNumberPage.route,
                      arguments: bloc);
                } else {
                  print(bloc.data.message);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: AppColors.red500,
                    content: Text(
                      bloc.data.message,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
                child: Text(
                  'Регистрация',
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

class _AgreementPolicy extends StatelessWidget {
  const _AgreementPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Продолжая, вы подтверждаете, что ознакомлены\n",
        children: [
          const TextSpan(
            text: "c ",
            style: TextStyle(
              color: AppColors.slate900,
            ),
          ),
          TextSpan(
              text: "Политикой конфиденциальности",
              style: const TextStyle(
                color: AppColors.green500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => print("SIGNIN")),
          const TextSpan(
            text: " и\n",
            style: TextStyle(
              color: AppColors.slate900,
            ),
          ),
          TextSpan(
              text: "Пользовательским соглашением",
              style: const TextStyle(
                color: AppColors.green500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => print("SIGNIN")),
          const TextSpan(
            text: " и принимаете их",
            style: TextStyle(
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
