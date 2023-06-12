import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:outsource/data/bloc/choose_lang_bloc.dart';
import 'package:outsource/data/http/auth_api_client.dart';
import 'package:outsource/data/http/dio_provider.dart';
import 'package:outsource/data/http/profile_api_client.dart';
import 'package:outsource/data/repository/lang_repository.dart';
import 'package:outsource/data/repository/token_repository.dart';
import 'package:outsource/presentation/profile/models/user.dart';
import 'package:path_provider/path_provider.dart';

class ProfileBlocData {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController languageController =
      TextEditingController(text: 'Русский');

  TextEditingController phoneController = TextEditingController();

  String imagePath = '';
  String phoneNumber = '';
  String code = '';

  int selectedSegmentId = 0;

  Uint8List? croppedImage;
  File? file;

  bool isSuccess = false;
  bool isLoading = false;

  String error = '';

  User? user;
}

class ProfileBloc extends ChangeNotifier {
  final data = ProfileBlocData();
  final _profileApiClient = ProfileApiClient(DioBuilder().build());
  final _authApiClient = AuthApiClient();

  String _confirmationPhone = '';

  ProfileBloc() {
    load();
  }

  Future<void> load() async {
    data.isLoading = true;
    notifyListeners();
    final user = await _profileApiClient.getUser();
    await loadLang();

    data.user = user;
    data.fullNameController.text = user.fullName ?? '';
    data.phoneController.text = '+${user.phoneNumber}';
    data.phoneNumber = user.phoneNumber;
    data.isLoading = false;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  Future<void> loadLang() async {
    await LangRepository.getInstance().getLang().then((value) {
      if (value != null && value.isNotEmpty) {
        data.languageController.text = Languages.values
            .firstWhere((language) => language.slug == value)
            .name;
      } else {
        LangRepository.getInstance().saveLang('ru');
        data.languageController.text = Languages.values
            .firstWhere((language) => language.slug == 'ru')
            .name;
      }
      notifyListeners();
    });
  }

  Future<void> updateProfile() async {
    if (data.croppedImage != null) {
      Uint8List imageInUnit8List =
          data.croppedImage!; // store unit8List image here ;
      final tempDir = await getTemporaryDirectory();
      data.file = await File('${tempDir.path}/avatar.png').create();
      data.file!.writeAsBytesSync(imageInUnit8List);
      data.imagePath = data.file?.path ?? '';
    }
    data.isSuccess = await _profileApiClient.updateUser(
      image: data.imagePath,
      fullName: data.fullNameController.text,
    );
    load();
  }

  Future<void> updatePhone() async {
    _confirmationPhone =
        data.phoneController.text.replaceAll(' ', '').replaceAll('+', '');
    if (data.phoneNumber == _confirmationPhone) {
      data.error = 'Номер не изменен';
    } else {
      data.error = '';
      data.isSuccess = await _profileApiClient.updatePhone(
        phone: _confirmationPhone,
      );
    }
    notifyListeners();
  }

  void changeSelectedId(int? index) {
    data.selectedSegmentId = index ?? 0;
    notifyListeners();
  }

  Future<void> confirmCode() async {
    data.error = '';
    data.isLoading = true;
    notifyListeners();

    data.isSuccess = await _profileApiClient.confirmAuthMember(
      _confirmationPhone,
      data.code,
    );

    if (!data.isSuccess) {
      data.error = 'Код подтверждения недействителен';
    } else {
      data.phoneNumber = _confirmationPhone;
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
      data.error = response.result!.message!;
      data.isSuccess = response.success;
      data.isLoading = false;
      data.error = '';

      notifyListeners();
    } else {
      data.error = response.error!.message;
      data.isLoading = false;
      data.error = '';

      notifyListeners();
    }
  }
}
