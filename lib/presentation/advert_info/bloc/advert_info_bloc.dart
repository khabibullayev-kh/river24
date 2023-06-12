import 'package:flutter/material.dart';
import 'package:outsource/data/http/adver_info_client.dart';
import 'package:outsource/data/http/dio_provider.dart';
import 'package:outsource/data/models/request_dto.dart';
import 'package:outsource/presentation/adverts/models/advert.dart';

class AdvertInfoBlocData {
  Advert? advert;

  List<RequestDto> requests = [];

  bool isAccepted = false;
  bool isLoading = true;

  int? slideIndex = 0;
}

class AdvertInfoBloc extends ChangeNotifier {
  final AdvertInfoBlocData data = AdvertInfoBlocData();
  final _advertInfoApiClient = AdvertInfoApiClient(DioBuilder().build());

  final int advertId;

  AdvertInfoBloc(this.advertId){
    getAdvert();
    getMyRequests();

  }


  Future<void> getAdvert() async {
    data.advert = await _advertInfoApiClient.getAdvert(advertId);
    data.isLoading = false;
    notifyListeners();
  }

  Future<void> getMyRequests() async {
    data.requests = await _advertInfoApiClient.getRequests(advertId);
    notifyListeners();
  }

  Future<void> acceptRequest(int requestId) async {
    data.isLoading = true;
    notifyListeners();
    data.isAccepted = await _advertInfoApiClient.acceptRequest(requestId);
    await getMyRequests();
    data.isLoading = false;
    notifyListeners();
  }

  Future<void> cancelAdvert() async {
    data.isLoading = true;
    notifyListeners();
    await _advertInfoApiClient.cancelAdvert(advertId);
    await getAdvert();
    data.isLoading = false;
    notifyListeners();
  }

  Future<void> getData(int sliding) async {
    switch(sliding){
      case 0:
        await getAdvert();
        break;
      case 1:
        await getMyRequests();
        break;
    }
  }

}