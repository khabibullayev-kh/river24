import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:outsource/data/repository/pin_repository.dart';

class LocalAuthInteraction {
  static LocalAuthInteraction? _instance;

  factory LocalAuthInteraction.getInstance() =>
      _instance ??= LocalAuthInteraction._internal();

  LocalAuthInteraction._internal();

  static LocalAuthentication localAuth = LocalAuthentication();

  Future<bool> authenticateIsAvailable() async {
    final isAvailable = await localAuth.canCheckBiometrics;
    final isDeviceSupported = await localAuth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  Future<bool> auth() async {
    bool authenticated = false;
    final pin = await PinRepository.getInstance().getPin();
    if (await authenticateIsAvailable() && pin != null) {
      try {
        authenticated = await localAuth.authenticate(
          authMessages: <AuthMessages>[
            const IOSAuthMessages(),
            const AndroidAuthMessages(
              signInTitle: 'Авторизоваться',
              biometricHint: '',
            )
          ],
          localizedReason: 'Авторизуйтесь с помощью биометрических данных',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            sensitiveTransaction: true,
            stickyAuth: true,
            biometricOnly: false,
          ),
        );
        return authenticated;
      } on PlatformException catch (e) {
        print(e.message);
        return false;
      }
    }
    return authenticated;
  }
}
