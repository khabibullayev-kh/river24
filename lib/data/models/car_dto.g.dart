// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarDto _$CarDtoFromJson(Map<String, dynamic> json) => CarDto(
      id: json['id'] as int,
      title: json['title'] as String,
      brand: json['brand'] as String,
    );

Map<String, dynamic> _$CarDtoToJson(CarDto instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'brand': instance.brand,
    };
