import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceData {
  static const tokenKey = "token_key";
  static const pinKey = "pin_key";
  static const userKey = "user_key";

  static SharedPreferenceData? _instance;

  factory SharedPreferenceData.getInstance() =>
      _instance ??= SharedPreferenceData._internal();

  SharedPreferenceData._internal();

  Future<bool> setToken(final String token) =>
      setItem(tokenKey, token);

  Future<String> getToken() => getItem(tokenKey);

  Future<bool> setPin(final String token) =>
      setItem(pinKey, token);

  Future<String> getPin() => getItem(pinKey);

  Future<bool> setUser(final String user) =>
      setItem(pinKey, user);

  Future<String> getUser() => getItem(pinKey);

  Future<bool> setItem(final String key, final String item) async {
    final sp = await SharedPreferences.getInstance();
    final result = sp.setString(key, item);
    return result;
  }

  Future<String> getItem(final String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(key) ?? '';
  }
}
