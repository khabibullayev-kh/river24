import 'package:collection/collection.dart';

enum RouteName {
  splash(route: "/"),
  signIn(route: "/sign_in"),
  confirmNumberPage(route: "/confirm_number"),
  loginPin(route: "/login_pin"),
  lastStep(route: "/last_step"),
  cropImage(route: "/crop_image"),
  enterPin(route: "/enter_pin"),
  changePin(route: "/change_pin"),
  cropToUpdateProfile(route: "/crop_image_to_update"),
  updatePhone(route: '/update_phone'),
  home(route: "/home"),
  adverts(route: "/home/adverts"),
  advertInfo(route: "/home/adverts/advert_info"),
  editAdvert(route: "/home/adverts/advert_info/edit_advert"),
  ;

  static RouteName? find(String name) =>
      values.firstWhereOrNull((routeName) => routeName.route == name);

  const RouteName({required this.route});

  final String route;
}
