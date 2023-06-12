
import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_dto.g.dart';

@JsonSerializable()
class CommonDto {
  final int id;
  final Title title;

  CommonDto({
    required this.id,
    required this.title
  });

  factory CommonDto.fromJson(Map<String, dynamic> json) =>
      _$CommonDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommonDtoToJson(this);
}

@JsonSerializable()
class Title{
  final String oz;
  final String ru;
  final String uz;

  Title({
    required this.oz,
    required this.ru,
    required this.uz,
  });

  factory Title.fromJson(Map<String, dynamic> json) =>
      _$TitleFromJson(json);

  Map<String, dynamic> toJson() => _$TitleToJson(this);
}
