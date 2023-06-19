import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:outsource/data/bloc/choose_lang_bloc.dart';
import 'package:outsource/data/http/auth_api_client.dart';
import 'package:outsource/data/repository/lang_repository.dart';
import 'package:outsource/data/repository/pin_repository.dart';
import 'package:outsource/data/repository/token_repository.dart';
import 'package:path_provider/path_provider.dart';

class RegisterBlocData {
  int pinLength = 5;
  TextEditingController pinController = TextEditingController();
  bool isObscured = true;

  TextEditingController phoneController = TextEditingController(text: '+998 ');

  TextEditingController fullNameController = TextEditingController();

  Uint8List? croppedImage;

  String phoneNumber = '';
  String message = '';

  String langText = 'Русский';

  bool isLogin = false;
  bool isSuccess = false;
  bool? isLogged;
  bool isLoading = false;
  bool isPinTrue = false;

  File? file;

  String code = '';
}

class RegisterBloc extends ChangeNotifier {
  final data = RegisterBlocData();
  final AuthApiClient _authApiClient = AuthApiClient();
  String _confirmationPhone = '';

  RegisterBloc() {
    loadLang();
  }

  Future<void> sendSms() async {
    if (!isPhoneValid(data.phoneController.text)) return;
    data.isLoading = true;
    notifyListeners();
    data.phoneNumber = data.phoneController.text.replaceRange(
      5,
      14,
      '** *** **',
    );
    _confirmationPhone =
        data.phoneController.text.replaceAll('+', '').replaceAll(' ', '');
    final response = await _authApiClient.registerViaPhone(_confirmationPhone);
    if (response.success) {
      data.isLogged = response.result!.isLogin!;
      data.isSuccess = response.success;
    } else {
      data.message = response.error!.message;
    }
    data.isLoading = false;

    notifyListeners();
  }

  Future<void> confirmCode() async {
    data.message = '';
    data.isLoading = true;
    data.isPinTrue = false;
    notifyListeners();

    final response = await _authApiClient.confirmAuthMember(
      _confirmationPhone,
      data.code,
    );

    if (response.result?.token == null) {
      data.message = response.error?.message ?? 'Произошла ошибка';
      data.isSuccess = false;
      data.isLogin = false;
    } else {
      if (response.result?.isLogin == true) {
        data.isLogin = true;
      } else {
        data.isSuccess = response.success;
      }
      TokenRepository.getInstance().saveToken(response.result!.token);
    }
    data.isLoading = false;
    notifyListeners();
  }

  Future<void> resendSms() async {
    data.isLoading = true;
    notifyListeners();

    final response = await _authApiClient.resendSms(
      _confirmationPhone,
    );

    if (response.success) {
      data.message = response.result!.message!;
      data.isSuccess = response.success;
      data.isLoading = false;
      data.message = '';

      notifyListeners();
    } else {
      data.message = response.error!.message;
      data.isLoading = false;
      data.message = '';

      notifyListeners();
    }
  }

  Future<void> enterPin(String code) async {
    try {
      final dto = await _authApiClient.checkPin(
        phone: _confirmationPhone,
        code: code,
      );
      data.isPinTrue = dto.success;
      if (data.isPinTrue) {
        PinRepository.getInstance().savePin(code);
      }
      data.message = dto.error?.message ?? '';
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveUserData() async {
    data.isLoading = true;
    data.isSuccess = false;
    notifyListeners();
    if (data.croppedImage != null) {
      Uint8List imageInUnit8List =
          data.croppedImage!; // store unit8List image here ;
      final tempDir = await getTemporaryDirectory();
      data.file = await File('${tempDir.path}/avatar.png').create();
      data.file!.writeAsBytesSync(imageInUnit8List);
    }
    final success = await _authApiClient.saveUserData(
      image: data.file?.path,
      fullName: data.fullNameController.text,
    );
    if (success) {
      data.isSuccess = success;
      notifyListeners();
    }
    data.isLoading = false;
    notifyListeners();
  }

  Future<void> loadLang() async {
    await LangRepository.getInstance().getLang().then((value) {
      data.langText = Languages.values
          .firstWhere(
            (language) => language.slug == value,
          )
          .name;
      notifyListeners();
    });
  }

  void handlePinButton(String number) {
    if (data.pinController.text.length == data.pinLength) return;
    data.pinController.text += number;
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
