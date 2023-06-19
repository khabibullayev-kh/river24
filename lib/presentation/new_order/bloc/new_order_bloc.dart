import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outsource/data/http/dio_provider.dart';
import 'package:outsource/data/http/new_advert_client.dart';
import 'package:outsource/data/models/common_dto.dart';
import 'package:outsource/data/models/weight_dto.dart';
import 'package:outsource/data/repository/lang_repository.dart';

class NewOrderBlocData {
  TextEditingController title = TextEditingController();
  TextEditingController receiverFullName = TextEditingController();
  TextEditingController receiverAddress = TextEditingController();
  TextEditingController receiverPhoneNumber = TextEditingController();
  TextEditingController comment = TextEditingController();
  TextEditingController mapAddress = TextEditingController();

  List<WeightDto> weights = [];

  List<DropdownMenuItem> fromRegionItems = [];
  List<DropdownMenuItem> fromDistrictItems = [];

  List<DropdownMenuItem> toRegionItems = [];
  List<DropdownMenuItem> toDistrictItems = [];

  List<XFile> images = [];

  int? fromRegionId;
  int? fromDistrictId;

  int? toRegionId;
  int? toDistrictId;

  int weightId = 1;

  double? lat;
  double? lon;

  String error = '';
  String success = '';

  bool isLoading = false;
}

class NewOrderBloc extends ChangeNotifier {
  final data = NewOrderBlocData();
  final _newAdvertApiClient = NewAdvertClient(DioBuilder().build());

  NewOrderBloc() {
    load();
  }

  Future<void> load() async {
    data.weights = await _newAdvertApiClient.getWeights();
    final regions = await _newAdvertApiClient.getRegions();
    final lang = await LangRepository.getInstance().getLang();
    print(lang);
    for (CommonDto i in regions) {
      data.fromRegionItems.add(
        DropdownMenuItem(
          value: i.id,
          child: Text(lang == 'ru'
              ? i.title.ru
              : lang == 'oz'
                  ? i.title.oz
                  : i.title.uz),
        ),
      );
      data.toRegionItems.add(
        DropdownMenuItem(
          value: i.id,
          child: Text(lang == 'ru'
              ? i.title.ru
              : lang == 'oz'
                  ? i.title.oz
                  : i.title.uz),
        ),
      );
    }
    notifyListeners();
  }

  Future<void> setFromRegionId(dynamic regionId) async {
    data.fromRegionId = regionId;
    final lang = await LangRepository.getInstance().getLang();
    await _newAdvertApiClient.getDistrictsById(regionId).then((value) {
      data.fromDistrictItems = value.map((district) {
        return DropdownMenuItem(
          value: district.id,
          child: Text(lang == 'ru'
              ? district.title.ru
              : lang == 'oz'
                  ? district.title.oz
                  : district.title.uz),
        );
      }).toList();
      data.fromDistrictId = value.first.id;
    });
    notifyListeners();
  }

  Future<void> setToRegionId(dynamic regionId) async {
    data.toRegionId = regionId;
    final lang = await LangRepository.getInstance().getLang();
    await _newAdvertApiClient.getDistrictsById(regionId).then((value) {
      data.toDistrictItems = value.map((district) {
        return DropdownMenuItem(
          value: district.id,
          child: Text(lang == 'ru'
              ? district.title.ru
              : lang == 'oz'
                  ? district.title.oz
                  : district.title.uz),
        );
      }).toList();
      data.toDistrictId = value.first.id;
    });
    notifyListeners();
  }

  void setFromDistrict(dynamic value) {
    data.fromDistrictId = value;
    notifyListeners();
  }

  void setToDistrict(dynamic value) {
    data.toDistrictId = value;
    notifyListeners();
  }

  void setWeight(int weightId) {
    data.weightId = weightId;
    notifyListeners();
  }

  Future<void> pickImages() async {
    data.images = await ImagePicker().pickMultiImage();
    notifyListeners();
  }

  Future<void> createAdvert() async {
    data.isLoading = true;
    notifyListeners();
    if (data.title.text.isNotEmpty &&
        data.receiverFullName.text.isNotEmpty &&
        data.receiverAddress.text.isNotEmpty &&
        (data.receiverPhoneNumber.text.isNotEmpty &&
        isPhoneValid(data.receiverPhoneNumber.text)) &&
        data.mapAddress.text.isNotEmpty &&
        data.fromRegionId != null &&
        data.fromDistrictId != null &&
        data.toRegionId != null &&
        data.toDistrictId != null &&
        data.lat != null &&
        data.lon != null) {
      final confirmationPhone =
          data.receiverPhoneNumber.text.replaceAll(' ', '').replaceAll('+', '');
      await _newAdvertApiClient
          .addAdvert(
        title: data.title.text,
        fromLat: data.lat.toString(),
        fromLong: data.lon.toString(),
        fromRegionId: data.fromRegionId!,
        fromDistrictId: data.fromDistrictId!,
        toRegionId: data.toRegionId!,
        toDistrictId: data.toDistrictId!,
        receiverFullName: data.receiverFullName.text,
        receiverAddress: data.receiverAddress.text,
        receiverPhoneNumber: confirmationPhone,
        comment: data.comment.text,
        image: data.images,
        weightId: data.weightId,
      )
          .whenComplete(() {
        data.title.clear();
        data.receiverFullName.clear();
        data.receiverAddress.clear();
        data.receiverPhoneNumber.clear();
        data.comment.clear();
        data.mapAddress.clear();
        data.success = 'Заказ успешно создан!';
      });
    } else {
      data.error = "Заполните все поля";
    }
    data.isLoading = false;
    notifyListeners();
  }
}
