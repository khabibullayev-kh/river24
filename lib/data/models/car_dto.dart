
import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_dto.g.dart';

@JsonSerializable()
class CarDto {
  final int id;
  final String title;
  final String brand;

  CarDto({
    required this.id,
    required this.title,
    required this.brand,
  });

  factory CarDto.fromJson(Map<String, dynamic> json) =>
      _$CarDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CarDtoToJson(this);
}
