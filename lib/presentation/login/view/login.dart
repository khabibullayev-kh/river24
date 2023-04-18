import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:outsource/navigation/route_name.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/resources/app_icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;
    print(maxHeight);
    print(maxWidth);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            fit: StackFit.loose,
            children: [
              Positioned(
                top: maxHeight > 900 ? -1480 : -1600,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        print(constraints.maxHeight);
        print(constraints.maxWidth);
        return Column(
          children: <Widget>[
            SizedBox(height: constraints.maxHeight > 900 ? 102 : 70),
            _ChooseLanguageButton(),
            SizedBox(height: constraints.maxHeight > 900 ? 32 : 24),
            _RiverLogo(),
            SizedBox(height: constraints.maxHeight > 900 ? 102 : 64),
            _ForgotPassword(),
            SizedBox(height: constraints.maxHeight > 900 ? 16 : 12),
            _PhoneField(),
            SizedBox(height: constraints.maxHeight > 900 ? 16 : 12),
            _PasswordField(),
            SizedBox(height: 22),
            _SignInButtonRow(),
            SizedBox(height: constraints.maxHeight > 800 ? 150 : 50),
            Divider(thickness: 1, height: 1),
            SizedBox(height: 24),
            _AgreementPolicy(),
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
    final maxWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Image.asset(
          width: maxHeight > 900 ? 99 : 75,
          height: maxHeight > 900 ? 100 : 75,
          AppIcons.riverLogo,
        ),
        const SizedBox(height: 16),
        Image.asset(
          width: maxHeight > 900 ? 182 : 150,
          height: maxHeight > 900 ? 59 : 42,
          AppIcons.welcomeLogo,
        ),
      ],
    );
  }
}

class _ForgotPassword extends StatelessWidget {
  const _ForgotPassword();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: Text(
          'Забыли пароль?',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.slate500,
            decoration: TextDecoration.underline,
          ),
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
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'UZ',
      newMask: '+000 00 000 00 00',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 60,
        child: TextFormField(
          cursorColor: AppColors.slate400,
          keyboardType: TextInputType.phone,
          inputFormatters: [PhoneInputFormatter()],
          initialValue: '+998 ',
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
            hintText: 'Введите пароль',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: AppColors.slate400,
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
                text: "У вас ещё нет аккаунта?\nПройдите ",
                children: [
                  TextSpan(
                    text: "Регистрацию",
                    style: const TextStyle(
                      color: AppColors.green500,
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.of(context)
                          .pushReplacementNamed(RouteName.signIn.route),
                  ),
                ],
                style: const TextStyle(
                  color: AppColors.slate900,
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Text(
                  'Войти',
                  style: TextStyle(
                    fontSize: 14,
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
