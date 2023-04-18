// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Advert _$AdvertFromJson(Map<String, dynamic> json) => Advert(
      id: json['id'] as int,
      title: json['title'] as String,
      fromRegion: json['fromRegion'] as String,
      fromDistrict: json['fromDistrict'] as String,
      toRegion: json['toRegion'] as String,
      toDistrict: json['toDistrict'] as String,
      status: json['status'] as String,
      requestsCount: json['requestsCount'] as int,
      createdTime: json['createdTime'] as String,
    );

Map<String, dynamic> _$AdvertToJson(Advert instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'fromRegion': instance.fromRegion,
      'fromDistrict': instance.fromDistrict,
      'toRegion': instance.toRegion,
      'toDistrict': instance.toDistrict,
      'status': instance.status,
      'requestsCount': instance.requestsCount,
      'createdTime': instance.createdTime,
    };
