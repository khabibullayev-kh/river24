import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:outsource/data/repository/token_repository.dart';
import 'package:outsource/presentation/register/models/sent_sms_response_dto.dart';

class AuthApiClient {
  static final baseUrl = dotenv.env['MAIN_URL'];

  Dio dio = Dio();

  AuthApiClient() {
    dio.options.baseUrl = '$baseUrl';
    dio.options.connectTimeout = const Duration(milliseconds: 5000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 3000);
  }

  Future<SentSmsResponseDto> registerViaPhone(String phone) async {
    try {
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
      String phone, String code) async {
    try {
      final response = await dio.post(
        'api/member/auth/confirm',
        queryParameters: {
          'phone': phone,
          'code': code,
        },
      );
      print(response);
      return SentSmsResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<SentSmsResponseDto> resendSms(String phone) async {
    try {
      final response = await dio.post(
        'api/member/auth/resend-sms',
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

  Future<bool> saveUserData({
    required String? image,
    required String fullName,
  }) async {
    try {
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
      print(response);
      return response.data["success"];
    } catch (e) {
      rethrow;
    }
  }
}
