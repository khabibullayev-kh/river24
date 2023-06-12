import 'package:json_annotation/json_annotation.dart';

part 'advert.g.dart';

@JsonSerializable()
class Advert {
  Advert({
    required this.id,
    required this.title,
    required this.fromRegion,
    required this.fromDistrict,
    required this.fromRegionId,
    required this.fromDistrictId,
    required this.toRegion,
    required this.toDistrict,
    required this.toRegionId,
    required this.toDistrictId,
    required this.status,
    required this.requestsCount,
    required this.createdTime,
    required this.offerAmount,
    required this.driverId,
    required this.fromLat,
    required this.fromLng,
    required this.driverFullName,
    required this.driverPhoneNumber,
    required this.senderFullName,
    required this.senderPhoneNumber,
    required this.receiverFullName,
    required this.receiverAddress,
    required this.receiverPhoneNumber,
    required this.images,
    required this.comment,
    required this.weight,
    required this.weightType,
    required this.canEdit,
    required this.canCancel,
    required this.canRate,
  });

  int id;
  String title;
  String fromRegion;
  String fromDistrict;
  int? fromRegionId;
  int? fromDistrictId;
  String toRegion;
  String toDistrict;
  int? toRegionId;
  int? toDistrictId;
  String? status;
  int? requestsCount;
  String? createdTime;
  int? offerAmount;
  int? driverId;
  double? fromLat;
  double? fromLng;
  String? driverFullName;
  String? driverPhoneNumber;
  String? senderFullName;
  String? senderPhoneNumber;
  String? receiverFullName;
  String? receiverAddress;
  String? receiverPhoneNumber;
  List<ImagesDto>? images;
  String? comment;
  String? weight;
  String? weightType;
  bool? canEdit;
  bool? canCancel;
  bool? canRate;



  factory Advert.fromJson(Map<String, dynamic> json) =>
      _$AdvertFromJson(json);

  Map<String, dynamic> toJson() => _$AdvertToJson(this);
}


@JsonSerializable()
class ImagesDto {
  final int id;
  final String path;
  final String urlPath;

  ImagesDto({
    required this.id,
    required this.path,
    required this.urlPath,
  });

  factory ImagesDto.fromJson(Map<String, dynamic> json) =>
      _$ImagesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesDtoToJson(this);
}