import 'package:dio/dio.dart';
import 'package:outsource/presentation/profile/models/user.dart';
import 'package:outsource/presentation/register/models/sent_sms_response_dto.dart';

class ProfileApiClient {
  final Dio _dio;

  ProfileApiClient(this._dio);

  Future<User> getUser() async {
    try {
      final response = await _dio.get('api/member/users/me');
      print(response);
      return User.fromJson(response.data["result"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateUser({
    required String? image,
    required String fullName,
  }) async {
    try {
      print("IMAGE: $image");
      FormData? formData;
      if (image != null && image.isNotEmpty) {
        formData = FormData.fromMap({
          'avatar': await MultipartFile.fromFile(image),
        });
      }
      final response = await _dio.post(
        'api/member/users/update-profile',
        queryParameters: {
          "full_name": fullName,
        },
        data: formData ?? {},
      );
      print("FUCK " + '$response');
      return response.data["success"];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updatePin({
    required String oldCode,
    required String code,
    required String codeConfirm,
  }) async {
    try {
      final response = await _dio.post(
        '/api/member/users/update-pin',
        queryParameters: {
          "old_code": oldCode,
          "code": code,
          "code_confirm": codeConfirm,
        },
      );
      print(response);
      return response.data["success"];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updatePhone({
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        'api/member/users/update-phone',
        queryParameters: {
          "phone": phone,
        },
      );
      print(response);
      return response.data["success"];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> confirmAuthMember(
      String phone, String code) async {
    try {
      final response = await _dio.post(
        'api/member/users/confirm-new-phone',
        queryParameters: {
          'phone': phone,
          'code': code,
        },
      );
      print(response);
      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }
}