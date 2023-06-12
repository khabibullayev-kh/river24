import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:outsource/data/http/auth_api_client.dart';
import 'package:outsource/data/repository/pin_repository.dart';
import 'package:outsource/data/repository/token_repository.dart';
import 'package:outsource/domain/interactors/local_auth_interactor.dart';
import 'package:outsource/translations/locale_keys.g.dart';

class PinData {
  int pinLength = 5;
  TextEditingController pinController = TextEditingController();
  bool isObscured = true;

  String firstPin = '';
  String? pin;

  String error = '';
  String pinText = '';

  bool isPinSave = false;

  bool isChangePin = false;

  Status status = Status.newPIN;
}

class PinBloc extends ChangeNotifier {
  final data = PinData();
  final _authApiClient = AuthApiClient();

  PinBloc() {
    isHavePin();
  }

  Future<void> localAuth() async {
    final isTrue = await LocalAuthInteraction.getInstance().authenticateIsAvailable();
    if (isTrue) {
      final isAuth = await LocalAuthInteraction.getInstance().auth();
      if (isAuth) {


        data.isPinSave = true;
        data.pinController.text = await TokenRepository.getInstance().getToken() ?? '';
        await enterPin(data.pinController.text);
        notifyListeners();
      }
    }
  }




  void handlePinButton(String number) {
    if (data.pinController.text.length == data.pinLength) return;
    data.pinController.text += number;
    notifyListeners();
  }

  Future<void> enterPin(String pin) async {
    final storedPin = await PinRepository.getInstance().getPin();
    switch (data.status) {
      case Status.newPIN:
        await onNewPin(pin);
        break;
      case Status.havePIN:
        await onHavePin(pin, storedPin!);
        break;
      case Status.changePIN:
        onChangePin();
        break;
    }
  }

  Future<void> onNewPin(String pin) async {
    if (data.firstPin.isEmpty) {
      data.firstPin = pin;
      data.pinController.clear();
      data.pinText = LocaleKeys.confirm_new_pin_code.tr();
      data.error = '';
      notifyListeners();
    } else {
      if (data.firstPin == pin) {
        PinRepository.getInstance().savePin(pin);
        data.isPinSave = await _authApiClient.savePin(code: pin);
        notifyListeners();
      } else {
        data.error = LocaleKeys.error_pin2.tr();
        data.firstPin = '';
        data.pinController.clear();
        isHavePin();
      }
    }
  }

  Future<void> onHavePin(String pin, String storedPin) async {
    if (pin == storedPin) {
      data.error = '';
      data.isPinSave = true;
      notifyListeners();
    } else {
      data.error = LocaleKeys.error_pin.tr();
      data.pinController.clear();
      isHavePin();
    }
  }

  void onChangePin() {}

  Future<void> isHavePin() async {
    final String? pin = await PinRepository.getInstance().getPin();
    if (pin == null || pin.isEmpty) {
      data.pinText = LocaleKeys.set_pin.tr();
      data.status = Status.newPIN;
    } else if (pin.isNotEmpty) {
      data.pinText = LocaleKeys.enter_pin.tr();
      data.status = Status.havePIN;
      if (data.status == Status.havePIN && data.isPinSave != true) {
        localAuth();
      }
    } else {
      data.pinText = LocaleKeys.enter_current_pin.tr();
      data.status = Status.changePIN;
    }
    notifyListeners();
  }

  void deleteOnePin() {
    final pin = data.pinController.text;
    if (pin.isNotEmpty) {
      data.pinController.text = pin.substring(0, pin.length - 1);
    }
    notifyListeners();
  }
}

enum Status {
  newPIN,
  havePIN,
  changePIN,
}
