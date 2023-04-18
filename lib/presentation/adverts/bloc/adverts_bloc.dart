import 'package:flutter/cupertino.dart';
import 'package:outsource/data/http/advert_api_client.dart';
import 'package:outsource/presentation/adverts/models/advert.dart';

class AdvertsBlocData {
  bool isLoading = false;
  List<Advert> adverts = [];
}

class AdvertsBloc extends ChangeNotifier {
  final data = AdvertsBlocData();
  final _advertApiClient = AdvertApiClient();

  AdvertsBloc() {
    load();
  }

  Future<void> load() async {
    data.isLoading = true;
    notifyListeners();

    data.adverts = await _advertApiClient.getAllAdverts();
    print(data.adverts);
    data.isLoading = false;
    notifyListeners();
  }
}