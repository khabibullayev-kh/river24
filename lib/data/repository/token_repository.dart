import 'package:outsource/data/repository/shared_preference_data.dart';

class TokenRepository  {
  final SharedPreferenceData spData;

  static TokenRepository? _instance;

  factory TokenRepository.getInstance() => _instance ??=
      TokenRepository._internal(SharedPreferenceData.getInstance());

  TokenRepository._internal(this.spData);

  Future<String> getToken() => spData.getToken();

  Future<bool> saveToken(String token) => spData.setToken(token);

}
