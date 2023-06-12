import 'package:flutter/material.dart';
import 'package:outsource/navigation/route_name.dart';
import 'package:outsource/presentation/advert_info/view/advert_info.dart';
import 'package:outsource/presentation/edit_advert/bloc/edit_advert_bloc.dart';
import 'package:outsource/presentation/edit_advert/view/edit_advert.dart';
import 'package:outsource/presentation/home/bloc/home_bloc.dart';
import 'package:outsource/presentation/home/view/home_page.dart';
import 'package:outsource/presentation/pin/view/pin_page.dart';
import 'package:outsource/presentation/profile/bloc/profile_bloc.dart';
import 'package:outsource/presentation/profile/view/change_pin_page.dart';
import 'package:outsource/presentation/profile/view/confirm_number_to_update_page.dart';
import 'package:outsource/presentation/profile/view/crop_image_to_update.dart';
import 'package:outsource/presentation/register/bloc/register_bloc.dart';
import 'package:outsource/presentation/register/view/confirm_number_page.dart';
import 'package:outsource/presentation/register/view/crop_image.dart';
import 'package:outsource/presentation/register/view/last_step_page.dart';
import 'package:outsource/presentation/register/view/login_pin_page.dart';
import 'package:outsource/presentation/register/view/register_page.dart';
import 'package:outsource/presentation/splash/view/splash_page.dart';
import 'package:provider/provider.dart';

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
      case RouteName.loginPin:
        final args = settings.arguments is RegisterBloc
            ? settings.arguments as RegisterBloc
            : null;
        if (args == null) {
          debugPrint('ADD ARGUMENTS!!!');
        }
        return _createPageRoute(
          LoginPinPage(bloc: args ?? RegisterBloc()),
          routeName,
        );
      case RouteName.home:
        return _createPageRoute(
            ChangeNotifierProvider(
                create: (BuildContext context) => HomeBloc(),
                child: const HomePage()),
            routeName);
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
      case RouteName.updatePhone:
        final args = settings.arguments is ProfileBloc
            ? settings.arguments as ProfileBloc
            : null;
        if (args == null) {
          debugPrint('ADD ARGUMENTS!!!');
        }
        return _createPageRoute(
            ConfirmNumberToUpdatePage(
              bloc: args ?? ProfileBloc(),
            ),
            routeName);
      case RouteName.cropToUpdateProfile:
        final args = settings.arguments is ProfileBloc
            ? settings.arguments as ProfileBloc
            : null;
        if (args == null) {
          debugPrint('ADD ARGUMENTS!!!');
        }
        return _createPageRoute(
            CropImageToUpdatePage(
              bloc: args ?? ProfileBloc(),
            ),
            routeName);
      case RouteName.changePin:
        return _createPageRoute(const ChangePinPage(), routeName);
      case RouteName.advertInfo:
        final args =
            settings.arguments is int ? settings.arguments as int : null;
        if (args == null) {
          debugPrint('ADD ARGUMENTS!!!');
        }
        return _createPageRoute(AdvertInfoPage(advertId: args ?? 1), routeName);
      case RouteName.editAdvert:
        final args =
            settings.arguments is int ? settings.arguments as int : null;
        if (args == null) {
          debugPrint('ADD ARGUMENTS!!!');
        }
        return _createPageRoute(
            ChangeNotifierProvider(
              create: (context) => EditAdvertBloc(args ?? 1),
              child: EditAdvertPage(advertId: args ?? 1),
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
