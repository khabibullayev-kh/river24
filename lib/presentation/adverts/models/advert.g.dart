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
      fromRegionId: json['fromRegionId'] as int?,
      fromDistrictId: json['fromDistrictId'] as int?,
      toRegion: json['toRegion'] as String,
      toDistrict: json['toDistrict'] as String,
      toRegionId: json['toRegionId'] as int?,
      toDistrictId: json['toDistrictId'] as int?,
      status: json['status'] as String?,
      requestsCount: json['requestsCount'] as int?,
      createdTime: json['createdTime'] as String?,
      offerAmount: json['offerAmount'] as int?,
      driverId: json['driverId'] as int?,
      fromLat: (json['fromLat'] as num?)?.toDouble(),
      fromLng: (json['fromLng'] as num?)?.toDouble(),
      driverFullName: json['driverFullName'] as String?,
      driverPhoneNumber: json['driverPhoneNumber'] as String?,
      senderFullName: json['senderFullName'] as String?,
      senderPhoneNumber: json['senderPhoneNumber'] as String?,
      receiverFullName: json['receiverFullName'] as String?,
      receiverAddress: json['receiverAddress'] as String?,
      receiverPhoneNumber: json['receiverPhoneNumber'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ImagesDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      comment: json['comment'] as String?,
      weight: json['weight'] as String?,
      weightType: json['weightType'] as String?,
      canEdit: json['canEdit'] as bool?,
      canCancel: json['canCancel'] as bool?,
      canRate: json['canRate'] as bool?,
    );

Map<String, dynamic> _$AdvertToJson(Advert instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'fromRegion': instance.fromRegion,
      'fromDistrict': instance.fromDistrict,
      'fromRegionId': instance.fromRegionId,
      'fromDistrictId': instance.fromDistrictId,
      'toRegion': instance.toRegion,
      'toDistrict': instance.toDistrict,
      'toRegionId': instance.toRegionId,
      'toDistrictId': instance.toDistrictId,
      'status': instance.status,
      'requestsCount': instance.requestsCount,
      'createdTime': instance.createdTime,
      'offerAmount': instance.offerAmount,
      'driverId': instance.driverId,
      'fromLat': instance.fromLat,
      'fromLng': instance.fromLng,
      'driverFullName': instance.driverFullName,
      'driverPhoneNumber': instance.driverPhoneNumber,
      'senderFullName': instance.senderFullName,
      'senderPhoneNumber': instance.senderPhoneNumber,
      'receiverFullName': instance.receiverFullName,
      'receiverAddress': instance.receiverAddress,
      'receiverPhoneNumber': instance.receiverPhoneNumber,
      'images': instance.images,
      'comment': instance.comment,
      'weight': instance.weight,
      'weightType': instance.weightType,
      'canEdit': instance.canEdit,
      'canCancel': instance.canCancel,
      'canRate': instance.canRate,
    };

ImagesDto _$ImagesDtoFromJson(Map<String, dynamic> json) => ImagesDto(
      id: json['id'] as int,
      path: json['path'] as String,
      urlPath: json['urlPath'] as String,
    );

Map<String, dynamic> _$ImagesDtoToJson(ImagesDto instance) => <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'urlPath': instance.urlPath,
    };
