import 'package:outsource/data/repository/shared_preference_data.dart';

class UserRepository  {
  final SharedPreferenceData spData;

  static UserRepository? _instance;

  factory UserRepository.getInstance() => _instance ??=
      UserRepository._internal(SharedPreferenceData.getInstance());

  UserRepository._internal(this.spData);

  Future<String> getUser() => spData.getUser();

  Future<bool> saveUser(String user) => spData.setUser(user);

}
