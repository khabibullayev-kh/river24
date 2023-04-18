import 'package:outsource/resources/app_icons.dart';

enum BottomTab {
  orders('Мои заказы', AppIcons.files),
  newOrder('Новые заказы', AppIcons.addFile),
  profile('Профиль', AppIcons.account);

  const BottomTab(this.label, this.icon);

  final String label;
  final String icon;
}
