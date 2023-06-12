// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestDto _$RequestDtoFromJson(Map<String, dynamic> json) => RequestDto(
      id: json['id'] as int,
      price: json['price'] as int,
      fullName: json['fullName'] as String?,
      canRequest: json['canRequest'] as bool,
      phoneNumber: json['phoneNumber'] as String?,
      status: json['status'] as String,
      rating: json['rating'] as int,
      countOfRates: json['countOfRates'] as int,
      calculatedRating: json['calculatedRating'] as int,
    );

Map<String, dynamic> _$RequestDtoToJson(RequestDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'fullName': instance.fullName,
      'canRequest': instance.canRequest,
      'phoneNumber': instance.phoneNumber,
      'status': instance.status,
      'rating': instance.rating,
      'countOfRates': instance.countOfRates,
      'calculatedRating': instance.calculatedRating,
    };
