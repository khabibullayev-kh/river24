
import 'package:json_annotation/json_annotation.dart';

part 'advert.g.dart';

@JsonSerializable()
class Advert {
  Advert({
    required this.id,
    required this.title,
    required this.fromRegion,
    required this.fromDistrict,
    required this.toRegion,
    required this.toDistrict,
    required this.status,
    required this.requestsCount,
    required this.createdTime,
  });

  int id;
  String title;
  String fromRegion;
  String fromDistrict;
  String toRegion;
  String toDistrict;
  String status;
  int requestsCount;
  String createdTime;


  factory Advert.fromJson(Map<String, dynamic> json) =>
      _$AdvertFromJson(json);

  Map<String, dynamic> toJson() => _$AdvertToJson(this);
}