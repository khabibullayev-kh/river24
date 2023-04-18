import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:outsource/presentation/adverts/models/advert.dart';

class AdvertApiClient {
  static final baseUrl = dotenv.env['MAIN_URL'];

  Dio dio = Dio();

  AdvertApiClient() {
    dio.options.baseUrl = '$baseUrl';
    dio.options.connectTimeout = const Duration(milliseconds: 5000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 3000);
    dio.options.headers[HttpHeaders.authorizationHeader] =
        'Bearer 9|CMwJQU4SmTyKFtt9qRrRbRssL7QTSaOXru5BuTMd';
  }

  Future<List<Advert>> getAllAdverts() async {
    try {
      final response = await dio.get('api/member/adverts/all');
      return List<Advert>.from(
        response.data["result"].map(
          (x) => Advert.fromJson(x),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
