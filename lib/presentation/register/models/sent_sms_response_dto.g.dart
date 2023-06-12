// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sent_sms_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SentSmsResponseDto _$SentSmsResponseDtoFromJson(Map<String, dynamic> json) =>
    SentSmsResponseDto(
      success: json['success'] as bool,
      error: json['error'] == null
          ? null
          : Error.fromJson(json['error'] as Map<String, dynamic>),
      result: json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SentSmsResponseDtoToJson(SentSmsResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'result': instance.result,
    };

Error _$ErrorFromJson(Map<String, dynamic> json) => Error(
      message: json['message'] as String,
    );

Map<String, dynamic> _$ErrorToJson(Error instance) => <String, dynamic>{
      'message': instance.message,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      token: json['token'] as String?,
      message: json['message'] as String?,
      phone: json['phone'] as String?,
      isLogin: json['isLogin'] as bool?,
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'token': instance.token,
      'message': instance.message,
      'phone': instance.phone,
      'isLogin': instance.isLogin,
    };
