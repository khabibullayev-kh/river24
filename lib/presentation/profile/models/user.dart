import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String? fullName;
  String phoneNumber;
  String? avatar;

  User({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
