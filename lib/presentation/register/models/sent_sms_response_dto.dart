import 'package:json_annotation/json_annotation.dart';

part 'sent_sms_response_dto.g.dart';

@JsonSerializable()
class SentSmsResponseDto {
  SentSmsResponseDto({
    required this.success,
    required this.message,
    required this.error,
    required this.result,
  });

  bool success;
  String? message;
  Error? error;
  Result? result;

  factory SentSmsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SentSmsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SentSmsResponseDtoToJson(this);
}

@JsonSerializable()
class Error {
  Error({
    required this.message,
  });

  String message;

  factory Error.fromJson(Map<String, dynamic> json) =>
      _$ErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorToJson(this);
}

@JsonSerializable()
class Result {
  Result({
    required this.token,
  });

  String token;

  factory Result.fromJson(Map<String, dynamic> json) =>
      _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}


