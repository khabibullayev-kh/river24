import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:outsource/data/repository/lang_repository.dart';
import 'package:outsource/navigation/route_name.dart';

class ChooseLangBlocData {
  String currentLang = '';
}

class ChooseLangBloc extends ChangeNotifier {
  final data = ChooseLangBlocData();

  ChooseLangBloc() {
    load();
  }

  Future<void> load() async {
    data.currentLang = await LangRepository.getInstance().getLang() ?? 'ru';
    notifyListeners();
  }

  void setCurrentLang(int index) {
    data.currentLang = Languages.values[index].slug;
    notifyListeners();
  }

  Future<void> confirmLang(BuildContext context) async {
    await LangRepository.getInstance().saveLang(data.currentLang);
    if (data.currentLang == 'uz') {
      await context.setLocale(Locale('uz', 'Latn'));
    } else if (data.currentLang == 'oz') {
      await context.setLocale(Locale('uz', 'Cyrl'));
    } else if (data.currentLang == 'ru') {
      await context.setLocale(Locale('ru'));
    }
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteName.splash.route,
      (Route<dynamic> route) => false,
    );
  }
}

enum Languages {
  ru(name: 'Русский', slug: 'ru'),
  uz(name: 'Узбекча', slug: 'oz'),
  oz(name: 'O’zbekcha', slug: 'uz');

  final String name;
  final String slug;

  const Languages({required this.name, required this.slug});
}
