import 'package:flutter/material.dart';
import 'package:outsource/navigation/route_name.dart';
import 'package:outsource/presentation/pin/bloc/pin_view_model.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/resources/app_icons.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class PinPage extends StatefulWidget {
  const PinPage({Key? key}) : super(key: key);

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (_) => PinBloc(),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(height: maxHeight > 900 ? 92 : 60),
            const _ForgotPassword(),
            SizedBox(height: maxHeight > 900 ? 32 : maxHeight < 800 ? 16 : 24),
            const _EnterPinText(),
            SizedBox(height: maxHeight > 900 ? 32 : maxHeight < 800 ? 16 : 24),
            const _EnterPinRow(),
            SizedBox(height: maxHeight > 900 ? 68 : maxHeight < 800 ? 32 : 52),
            const _BuildPinRow(),
          ],
        ),
      ),
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
          ),
        ),
      ),
    );
  }
}

class _EnterPinText extends StatelessWidget {
  const _EnterPinText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Text(
        'Установите новый PIN',
        style: TextStyle(
          fontSize: maxWidth > 450 ?  24 : 18,
          fontWeight: FontWeight.w700,
          color: AppColors.slate900,
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
  @override
  Widget build(BuildContext context) {
    final model = context.watch<PinBloc>();
    final pinController = model.data.pinController;
    final pinLength = model.data.pinLength;
    final isObscured = model.data.isObscured;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final maxWidth = constraints.maxWidth;
        return SizedBox(
          height: maxHeight > 900 ? 60 : 40,
          child: Row(
            children: <Widget>[
              const Expanded(child: SizedBox()),
              SizedBox(
                width: maxWidth > 400 ? 144 : 100,
                child: PinCodeTextField(
                  length: pinLength,
                  controller: pinController,
                  onChanged: (value) {
                    setState(() {
                      pinController.text = value;
                      if (pinController.text.length == pinLength) {
                        Navigator.of(context)
                            .pushReplacementNamed(RouteName.login.route);
                      }
                    });
                  },
                  textStyle: const TextStyle(
                    fontSize: 24,
                    color: AppColors.slate500,
                  ),
                  readOnly: true,
                  appContext: context,
                  obscureText: isObscured,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  obscuringCharacter: '*',
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  cursorColor: AppColors.slate500,
                  autoFocus: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: maxHeight > 900 ? 30 : 20,
                    fieldWidth: maxWidth > 400 ? 20 : 14,
                    activeColor: AppColors.slate500,
                    inactiveColor: AppColors.slate500,
                    selectedColor: AppColors.slate500,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8.0),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        model.data.isObscured = !isObscured;
                      });
                    },
                    icon: Icon(
                      isObscured ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.slate500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BuildPinRow extends StatefulWidget {
  const _BuildPinRow({Key? key}) : super(key: key);

  @override
  State<_BuildPinRow> createState() => _BuildPinRowState();
}

class _BuildPinRowState extends State<_BuildPinRow> {
  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        // final maxHeight = constraints.maxHeight;
        // final maxWidth = constraints.maxWidth;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: maxHeight > 900 ? 100 : 90,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  _BuildPinButton(number: '1'),
                  SizedBox(width: 16),
                  _BuildPinButton(number: '2'),
                  SizedBox(width: 16),
                  _BuildPinButton(number: '3'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: maxHeight > 900 ? 100 : 90,
              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  _BuildPinButton(number: '4'),
                  SizedBox(width: maxWidth > 400 ? 16 : 12),
                  _BuildPinButton(number: '5'),
                  SizedBox(width: maxWidth > 400 ? 16 : 12),
                  _BuildPinButton(number: '6'),
                ],
              ),
            ),
            SizedBox(height: maxHeight > 400 ? 16 : 12),
            SizedBox(
              height: maxHeight > 900 ? 100 : 90,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const _BuildPinButton(number: '7'),
                  SizedBox(width: maxWidth > 400 ? 16 : 12),
                  const _BuildPinButton(number: '8'),
                  SizedBox(width: maxWidth > 400 ? 16 : 12),
                  const _BuildPinButton(number: '9'),
                ],
              ),
            ),
            SizedBox(height: maxHeight > 400 ? 16 : 12),
            SizedBox(
              height: maxHeight > 900 ? 100 : 90,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _BuildFingerPrintButton(),
                  SizedBox(width: maxWidth > 400 ? 16 : 12),
                  _BuildPinButton(number: '0'),
                  SizedBox(width: maxWidth > 400 ? 16 : 12),
                  _BuildDeletePinButton(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BuildPinButton extends StatelessWidget {
  final String number;

  const _BuildPinButton({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PinBloc>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            model.handlePinButton(number);
          },
          child: Container(
            height: MediaQuery.of(context).size.height > 900 ? 100 : 90,
            width: MediaQuery.of(context).size.width > 400 ? 100 : 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.width > 400 ? 40 : 35,
                  color: AppColors.slate500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BuildFingerPrintButton extends StatelessWidget {
  const _BuildFingerPrintButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth > 400 ? 100 : 75,
          height: constraints.maxHeight > 400 ? 100 : 75,
          child: Center(
            child: Image.asset(
              AppIcons.fingerPrint,
              width: 36,
              height: 31,
            ),
          ),
        );
      },
    );
  }
}

class _BuildDeletePinButton extends StatelessWidget {
  const _BuildDeletePinButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth > 400 ? 100 : 75,
          height: constraints.maxHeight > 400 ? 100 : 75,
          child: Center(
            child: Image.asset(
              AppIcons.deletePin,
              width: 30,
              height: 23,
            ),
          ),
        );
      },
    );
  }
}
