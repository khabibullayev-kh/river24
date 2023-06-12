import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_dto.g.dart';

@JsonSerializable()
class WeightDto {
  final int id;
  final int value;
  final String type;
  final String description;

  WeightDto({
    required this.id,
    required this.value,
    required this.type,
    required this.description,
  });

  factory WeightDto.fromJson(Map<String, dynamic> json) =>
      _$WeightDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WeightDtoToJson(this);
}
