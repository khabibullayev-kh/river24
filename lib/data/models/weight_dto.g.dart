// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeightDto _$WeightDtoFromJson(Map<String, dynamic> json) => WeightDto(
      id: json['id'] as int,
      value: json['value'] as int,
      type: json['type'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$WeightDtoToJson(WeightDto instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'type': instance.type,
      'description': instance.description,
    };
