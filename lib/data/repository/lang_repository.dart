import 'package:outsource/data/repository/shared_preference_data.dart';

class LangRepository  {
  final SharedPreferenceData spData;

  static LangRepository? _instance;

  factory LangRepository.getInstance() => _instance ??=
      LangRepository._internal(SharedPreferenceData.getInstance());

  LangRepository._internal(this.spData);

  Future<String?> getLang() => spData.getLang();

  Future<bool> saveLang(String? lang) => spData.setLang(lang);

}
