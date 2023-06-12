
import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_dto.g.dart';

@JsonSerializable()
class RequestDto {
  final int id;
  final int price;
  final String? fullName;
  final bool canRequest;
  final String? phoneNumber;
  final String status;
  final int rating;
  final int countOfRates;
  final int calculatedRating;

  RequestDto({
    required this.id,
    required this.price,
    required this.fullName,
    required this.canRequest,
    required this.phoneNumber,
    required this.status,
    required this.rating,
    required this.countOfRates,
    required this.calculatedRating,
  });

  factory RequestDto.fromJson(Map<String, dynamic> json) =>
      _$RequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RequestDtoToJson(this);
}
