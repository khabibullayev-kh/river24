import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:outsource/data/repository/lang_repository.dart';
import 'package:outsource/data/repository/token_repository.dart';
import 'package:outsource/domain/interactors/logout_interactor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioBuilder {
  static final baseUrl = dotenv.env['MAIN_URL'];

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '$baseUrl',
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
      sendTimeout: const Duration(milliseconds: 10000),
    ),
  );

  DioBuilder() {
    _dio.interceptors.add(AuthorizationInterceptor());
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          request: true,
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false,
          error: true,
        ),
      );
    }
  }

  Dio build() => _dio;

  DioBuilder addAuthorizationInterceptor(
      final AuthorizationInterceptor interceptor) {
    _dio.interceptors.add(interceptor);
    return this;
  }
}

class AuthorizationInterceptor extends Interceptor {

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = await TokenRepository.getInstance().getToken();
    String? lang = await LangRepository.getInstance().getLang();
    lang ??= 'ru';
    if (token == null) {
      await LogoutInteractor.logout();
      return handler.next(options);
    }
    options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    options.headers["locale"] = lang;
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 403) {
      await LogoutInteractor.logout();
    }
    return handler.next(err);
  }
}

