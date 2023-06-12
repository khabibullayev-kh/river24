import 'package:flutter/cupertino.dart';
import 'package:outsource/data/http/advert_api_client.dart';
import 'package:outsource/data/http/dio_provider.dart';
import 'package:outsource/presentation/adverts/models/advert.dart';

class AdvertsBlocData {
  bool isLoading = false;
  List<Advert> adverts = [];

  int? slideIndex = 0;
}

class AdvertsBloc extends ChangeNotifier {
  final data = AdvertsBlocData();
  final _advertApiClient = AdvertApiClient(DioBuilder().build());

  AdvertsBloc() {
    getData(0);
  }

  Future<void> loadActive() async {
    data.isLoading = true;
    notifyListeners();

    data.adverts = await _advertApiClient.getAllAdverts();
    data.isLoading = false;
    notifyListeners();
  }

  Future<void> loadCompleted() async {
    data.isLoading = true;
    notifyListeners();

    data.adverts = await _advertApiClient.getCompleted();
    print(data.adverts);
    data.isLoading = false;
    notifyListeners();
  }

  Future<void> rateAdvert({
    required int advertId,
    required int driverId,
    required int rate,
  }) async {
    await _advertApiClient.rateAdvert(
      driverId: driverId,
      advertId: advertId,
      value: rate,
    ).whenComplete(() {
      loadCompleted();
    });
  }

  Future<void> getData(int sliding) async {
    switch (sliding) {
      case 0:
        await loadActive();
        break;
      case 1:
        await loadCompleted();
        break;
    }
  }
}
