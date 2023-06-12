import 'package:dio/dio.dart';
import 'package:outsource/data/models/request_dto.dart';
import 'package:outsource/presentation/adverts/models/advert.dart';

class AdvertInfoApiClient {
  final Dio _dio;

  AdvertInfoApiClient(this._dio);

  Future<Advert> getAdvert(int advertId) async {
    try {
      final response = await _dio.get('api/member/adverts/$advertId/get');
      return Advert.fromJson(response.data["result"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RequestDto>> getRequests(int advertId) async {
    try {
      final response = await _dio.get('api/member/adverts/$advertId/requests');
      return List<RequestDto>.from(
        response.data["result"].map(
              (x) => RequestDto.fromJson(x),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> acceptRequest(int requestId) async {
    try {
      final response = await _dio.post('api/member/adverts/accept-request/$requestId');
      return response.data["success"];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> cancelAdvert(int requestId) async {
    try {
      final response = await _dio.post('api/member/adverts/cancel-advert/$requestId');
      return response.data["success"];
    } catch (e) {
      rethrow;
    }
  }
}
