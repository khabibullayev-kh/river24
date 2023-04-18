import 'package:flutter/cupertino.dart';

class PinData {
  int pinLength = 5;
  TextEditingController pinController = TextEditingController();
  bool isObscured = true;
}

class PinBloc extends ChangeNotifier {
  final data = PinData();

  void handlePinButton(String number) {
    if (data.pinController.text.length == data.pinLength) return;
    data.pinController.text += number;
    notifyListeners();
  }
}