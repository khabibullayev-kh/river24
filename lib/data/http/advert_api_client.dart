import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:outsource/presentation/adverts/models/advert.dart';

class AdvertApiClient {
  final Dio _dio;

  AdvertApiClient(this._dio);

  Future<List<Advert>> getAllAdverts() async {
    try {
      final response = await _dio.get('api/member/adverts/all');
      return List<Advert>.from(
        response.data["result"]["items"].map(
          (x) => Advert.fromJson(x),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Advert>> getCompleted() async {
    try {
      final response = await _dio.get('api/member/adverts/all/completed');
      return List<Advert>.from(
        response.data["result"].map(
          (x) => Advert.fromJson(x),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rateAdvert({
    required int driverId,
    required int advertId,
    required int value,
  }) async {
    try {
      await _dio.post(
        'api/member/rates/rate',
        queryParameters: {
          "rated_id" : driverId.toString(),
          "advert_id" : advertId.toString(),
          "value" : value.toString(),
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
