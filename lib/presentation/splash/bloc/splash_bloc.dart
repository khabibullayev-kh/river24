import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outsource/data/repository/pin_repository.dart';
import 'package:outsource/data/repository/token_repository.dart';
import 'package:outsource/navigation/route_name.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {

  SplashBloc() : super(SplashInitial()) {
    on<SplashLoaded>(_onSplashLoaded);
  }

  FutureOr<void> _onSplashLoaded(
    final SplashLoaded event,
    final Emitter<SplashState> emit,
  ) async {
    final token = await TokenRepository.getInstance().getToken();
    //TODO
    // TokenRepository.getInstance().saveToken(null);
    // PinRepository.getInstance().savePin(null);
    if (token == null || token.isEmpty) {
      emit(SplashNavigationRouteGenerated(route: RouteName.signIn.route));
    } else {
      emit(SplashNavigationRouteGenerated(route: RouteName.enterPin.route));
    }
  }
}
