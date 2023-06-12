// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonDto _$CommonDtoFromJson(Map<String, dynamic> json) => CommonDto(
      id: json['id'] as int,
      title: Title.fromJson(json['title'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommonDtoToJson(CommonDto instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };

Title _$TitleFromJson(Map<String, dynamic> json) => Title(
      oz: json['oz'] as String,
      ru: json['ru'] as String,
      uz: json['uz'] as String,
    );

Map<String, dynamic> _$TitleToJson(Title instance) => <String, dynamic>{
      'oz': instance.oz,
      'ru': instance.ru,
      'uz': instance.uz,
    };
