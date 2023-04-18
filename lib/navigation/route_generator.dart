import 'package:flutter/material.dart';
import 'package:outsource/navigation/route_name.dart';
import 'package:outsource/presentation/home/view/home_page.dart';
import 'package:outsource/presentation/login/view/login.dart';
import 'package:outsource/presentation/pin/view/pin_page.dart';
import 'package:outsource/presentation/register/bloc/register_bloc.dart';
import 'package:outsource/presentation/register/view/confirm_number_page.dart';
import 'package:outsource/presentation/register/view/crop_image.dart';
import 'package:outsource/presentation/register/view/last_step_page.dart';
import 'package:outsource/presentation/register/view/register_page.dart';
import 'package:outsource/presentation/splash/view/splash_page.dart';

RouteFactory generateRoute() {
  return (settings) {
    final name = settings.name;
    if (name == null) {
      return MaterialPageRoute(builder: (_) => const SplashPage());
    }
    final routeName = RouteName.find(name);
    if (routeName == null) {
      return MaterialPageRoute(builder: (_) => const SplashPage());
    }
    switch (routeName) {
      case RouteName.login:
        return _createPageRoute(const LoginPage(), routeName);
      case RouteName.splash:
        return _createPageRoute(const SplashPage(), routeName);
      case RouteName.signIn:
        return _createPageRoute(const RegisterPage(), routeName);
      case RouteName.enterPin:
        return _createPageRoute(const PinPage(), routeName);
      case RouteName.confirmNumberPage:
        final args = settings.arguments is RegisterBloc
            ? settings.arguments as RegisterBloc
            : null;
        if (args == null) {
          debugPrint('ADD ARGUMENTS!!!');
        }
        return _createPageRoute(
            ConfirmNumberPage(
              bloc: args ?? RegisterBloc(),
            ),
            routeName);
      case RouteName.lastStep:
        final args = settings.arguments is RegisterBloc
            ? settings.arguments as RegisterBloc
            : null;
        if (args == null) {
          debugPrint('ADD ARGUMENTS!!!');
        }
        return _createPageRoute(
          LastStepPage(bloc: args ?? RegisterBloc()),
          routeName,
        );
      case RouteName.home:
        return _createPageRoute(const HomePage(), routeName);
      case RouteName.cropImage:
        final args = settings.arguments is RegisterBloc
            ? settings.arguments as RegisterBloc
            : null;
        if (args == null) {
          debugPrint('ADD ARGUMENTS!!!');
        }
        return _createPageRoute(
            CropImagePage(
              bloc: args ?? RegisterBloc(),
            ),
            routeName);
    }
  };
}

Route _createPageRoute(Widget page, RouteName routeName) {
  return MaterialPageRoute(
    builder: (_) => page,
    settings: RouteSettings(name: routeName.name),
  );
}
