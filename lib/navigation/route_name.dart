import 'package:collection/collection.dart';

enum RouteName {
  splash(route: "/"),
  login(route: "/login"),
  signIn(route: "/sign_in"),
  confirmNumberPage(route: "/confirm_number"),
  lastStep(route: "/last_step"),
  cropImage(route: "/crop_image"),
  enterPin(route: "/enter_pin"),
  home(route: "/home"),
  ;

  static RouteName? find(String name) =>
      values.firstWhereOrNull((routeName) => routeName.route == name);

  const RouteName({required this.route});

  final String route;
}
