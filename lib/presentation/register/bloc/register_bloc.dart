import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:outsource/data/http/auth_api_client.dart';
import 'package:outsource/data/repository/token_repository.dart';
import 'package:path_provider/path_provider.dart';

class RegisterBlocData {
  TextEditingController phoneController = TextEditingController(text: '+998 ');

  TextEditingController fullNameController = TextEditingController();

  Uint8List? croppedImage;

  String phoneNumber = '';
  String message = '';

  bool isSuccess = false;
  bool isLoading = false;

  File? file;

  String code = '';
}

class RegisterBloc extends ChangeNotifier {
  final data = RegisterBlocData();
  final AuthApiClient _authApiClient = AuthApiClient();
  String _confirmationPhone = '';

  Future<void> sendSms() async {
    if (!isPhoneValid(data.phoneController.text)) return;
    data.isLoading = true;
    notifyListeners();
    data.phoneNumber =
        data.phoneController.text.replaceRange(5, 14, '** *** **');
    _confirmationPhone =
        data.phoneController.text.replaceAll('+', '').replaceAll(' ', '');

    final response = await _authApiClient.registerViaPhone(_confirmationPhone);
    if (response.success) {
      data.message = response.message!;
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
    notifyListeners();

    final response = await _authApiClient.confirmAuthMember(
      _confirmationPhone,
      data.code,
    );

    if (response.result?.token == null) {
      data.message = 'Код подтверждения недействителен';
    } else {
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
      data.message = response.message!;
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
}
