import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:outsource/data/http/dio_provider.dart';
import 'package:outsource/data/http/profile_api_client.dart';
import 'package:outsource/data/repository/pin_repository.dart';
import 'package:outsource/translations/locale_keys.g.dart';

class PinData {
  int pinLength = 5;
  TextEditingController pinController = TextEditingController();
  bool isObscured = true;

  String firstPin = '';
  String? pin;

  String error = '';
  String pinText = '';

  bool isSuccess = false;

  Status status = Status.oldPin;
}

class ChangePinBloc extends ChangeNotifier {
  final data = PinData();
  final _profileClient = ProfileApiClient(DioBuilder().build());

  ChangePinBloc() {
    isHavePin();
  }

  Future<void> enterPin(String pin) async {
    final storedPin = await PinRepository.getInstance().getPin();
    data.error = '';
    switch (data.status) {
      case Status.oldPin:
        if (storedPin == pin) {
          data.pinText = LocaleKeys.enter_new_pin.tr();
          data.pinController.clear();
          data.status = Status.newPin;
          notifyListeners();
        } else {
          data.error = LocaleKeys.error_pin.tr();
          data.pinController.clear();
          notifyListeners();
        }
        break;
      case Status.newPin:
        data.firstPin = pin;
        data.pinText = LocaleKeys.confirm_new_pin_code.tr();
        data.status = Status.confirmNewPin;
        data.pinController.clear();
        notifyListeners();
        break;
      case Status.confirmNewPin:
        if (data.firstPin == pin) {
          data.isSuccess = await onChangePin(storedPin!, pin);
          PinRepository.getInstance().savePin(pin);
          notifyListeners();
        } else {
          data.firstPin = '';
          data.error = LocaleKeys.error_pin2.tr();
          data.pinController.clear();
          data.status = Status.oldPin;
          isHavePin();
        }

        break;
    }
  }

  Future<bool> onChangePin(String storedPin, String pin) async {
    if (data.firstPin == pin) {
      return await _profileClient.updatePin(
        oldCode: storedPin,
        code: data.firstPin,
        codeConfirm: pin,
      );
    } else {
      return false;
    }
  }

  //void newPin() {
  //   data.pinController.clear();
  //   data.pinText = 'Подтвердите новый PIN';
  //   notifyListeners();
  // }

  Future<void> isHavePin() async {
    final String? pin = await PinRepository.getInstance().getPin();
    data.pin = pin;
    data.pinText = LocaleKeys.enter_current_pin.tr();
    notifyListeners();
  }

  void deleteOnePin() {
    final pin = data.pinController.text;
    if (pin.isNotEmpty) {
      data.pinController.text = pin.substring(0, pin.length - 1);
    }
    notifyListeners();
  }

  void handlePinButton(String number) {
    if (data.pinController.text.length == data.pinLength) return;
    data.pinController.text += number;
    notifyListeners();
  }
}

enum Status {
  oldPin,
  newPin,
  confirmNewPin,
}
