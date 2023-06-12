import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:outsource/data/repository/lang_repository.dart';
import 'package:outsource/data/repository/token_repository.dart';
import 'package:outsource/presentation/register/models/sent_sms_response_dto.dart';

class AuthApiClient {
  static final baseUrl = dotenv.env['MAIN_URL'];

  Dio dio = Dio();

  AuthApiClient() {
    dio.options.baseUrl = '$baseUrl';
    dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 10000);
  }

  Future<SentSmsResponseDto> registerViaPhone(String phone) async {
    try {
      dio.options.headers["locale"] =
          await LangRepository.getInstance().getLang();

      final response = await dio.post(
        'api/member/auth/register',
        queryParameters: {
          'phone': phone,
        },
      );
      print(response);
      return SentSmsResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<SentSmsResponseDto> confirmAuthMember(
    String phone,
    String code,
  ) async {
    try {
      dio.options.headers["locale"] =
          await LangRepository.getInstance().getLang();

      final response = await dio.post(
        'api/member/auth/confirm',
        queryParameters: {
          'phone': phone,
          'code': code,
        },
      );
      return SentSmsResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<SentSmsResponseDto> resendSms(String phone) async {
    try {
      dio.options.headers["locale"] =
          await LangRepository.getInstance().getLang();
      final response = await dio.post(
        'api/member/auth/resend-sms',
        queryParameters: {
          'phone': phone,
        },
      );
      return SentSmsResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> saveUserData({
    required String? image,
    required String fullName,
  }) async {
    try {
      dio.options.headers["locale"] =
          await LangRepository.getInstance().getLang();
      dio.options.headers['Authorization'] =
          'Bearer ${await TokenRepository.getInstance().getToken()}';
      FormData? formData;
      if (image != null) {
        formData = FormData.fromMap({
          'avatar': await MultipartFile.fromFile(image),
        });
      }
      final response = await dio.post(
        'api/member/auth/save-data',
        queryParameters: {
          "full_name": fullName,
        },
        data: formData ?? {},
      );
      return response.data["success"];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> savePin({
    required String code,
  }) async {
    try {
      dio.options.headers['Authorization'] =
          'Bearer ${await TokenRepository.getInstance().getToken()}';
      final response = await dio.post(
        'api/member/users/save-pin',
        queryParameters: {
          "code": code,
        },
      );
      return response.data["success"];
    } catch (e) {
      rethrow;
    }
  }

  Future<SentSmsResponseDto> checkPin({
    required String phone,
    required String code,
  }) async {
    try {
      dio.options.headers["locale"] =
          await LangRepository.getInstance().getLang();

      final response = await dio.post(
        'api/member/auth/check-pin',
        queryParameters: {
          "code": code,
          "phone": phone,
        },
      );
      return SentSmsResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
