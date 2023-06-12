import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outsource/data/http/dio_provider.dart';
import 'package:outsource/data/http/new_advert_client.dart';
import 'package:outsource/data/models/common_dto.dart';
import 'package:outsource/data/models/weight_dto.dart';
import 'package:outsource/data/repository/lang_repository.dart';
import 'package:outsource/presentation/adverts/models/advert.dart';

class EditAdvertData {
  Advert? advert;

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

class EditAdvertBloc extends ChangeNotifier {
  final int advertId;

  EditAdvertBloc(this.advertId) {
    load();
  }

  final data = EditAdvertData();
  final _newAdvertApiClient = NewAdvertClient(DioBuilder().build());

  Future<void> load() async {
    data.isLoading = true;
    notifyListeners();
    data.advert = await _newAdvertApiClient.getAdvert(advertId);
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
    final advert = data.advert;
    if (advert != null) {
      data.title.text = advert.title;
      if (data.weights.isNotEmpty) {
        data.weightId = data.weights
            .firstWhere((element) => element.value.toString() == advert.weight)
            .id;
      }
      data.receiverFullName.text = advert.receiverFullName ?? '';
      data.receiverAddress.text = advert.receiverAddress ?? '';
      data.receiverPhoneNumber.text = "+${advert.receiverPhoneNumber}";
      data.comment.text = advert.comment ?? '';
      data.lat = advert.fromLat;
      data.lon = advert.fromLng;
      final placeMarks = await placemarkFromCoordinates(
        data.lat!,
        data.lon!,
        localeIdentifier: '${await LangRepository.getInstance().getLang()}',
      );
      data.mapAddress.text =
          "${placeMarks[0].locality}, ${placeMarks[0].subLocality}";
      data.fromRegionId = advert.fromRegionId;
      await _newAdvertApiClient
          .getDistrictsById(data.fromRegionId!)
          .then((value) {
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
        data.fromDistrictId = advert.fromDistrictId;
      });
      data.toRegionId = advert.toRegionId;
      await _newAdvertApiClient
          .getDistrictsById(data.toRegionId!)
          .then((value) {
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
        data.toDistrictId = advert.toDistrictId;
      });
    }
    data.isLoading = false;
    notifyListeners();
  }

  // Future<void> getLatLong() async {
  //   await getCurrentLocation().then((value) async {
  //     print(value);
  //     lat = value.latitude;
  //     long = value.longitude;
  //     widget.bloc.data.lat = value.latitude;
  //     widget.bloc.data.lon = value.longitude;
  //     placeMarks = await placemarkFromCoordinates(
  //       lat,
  //       long,
  //       localeIdentifier: '${await LangRepository.getInstance().getLang()}',
  //     );
  //     print(placeMarks[0]);
  //     print(placeMarks);
  //
  //     mapController?.animateCamera(
  //       CameraUpdate.newLatLngZoom(LatLng(lat, long), 18),
  //     );
  //     setState(() {});
  //   });
  // }

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
    if (data.title.text.isNotEmpty ||
        data.receiverFullName.text.isNotEmpty ||
        data.receiverAddress.text.isNotEmpty ||
        data.receiverPhoneNumber.text.isNotEmpty ||
        data.comment.text.isNotEmpty ||
        data.mapAddress.text.isNotEmpty ||
        data.fromRegionId != null ||
        data.fromDistrictId != null ||
        data.toRegionId != null ||
        data.toDistrictId != null ||
        data.lat != null ||
        data.lon != null) {
      final confirmationPhone =
          data.receiverPhoneNumber.text.replaceAll(' ', '').replaceAll('+', '');
      await _newAdvertApiClient
          .editAdvert(
        advertId: advertId,
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
