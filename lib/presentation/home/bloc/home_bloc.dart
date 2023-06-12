import 'package:flutter/cupertino.dart';
import 'package:outsource/presentation/adverts/bloc/adverts_bloc.dart';
import 'package:outsource/presentation/home/models/bottom_tab.dart';
import 'package:outsource/presentation/new_order/bloc/new_order_bloc.dart';
import 'package:outsource/presentation/profile/bloc/profile_bloc.dart';

class HomeBlocData {
  int selectedIndex = 0;

  BottomTab currentTab = BottomTab.orders;
}

class HomeBloc extends ChangeNotifier {
  final data = HomeBlocData();
  AdvertsBloc advertsBloc = AdvertsBloc();
  NewOrderBloc newOrderBloc = NewOrderBloc();
  ProfileBloc profileBloc = ProfileBloc();

  void changeTab({
    required int index,
    AdvertsBloc? advertsBloc,
  }) {
    data.currentTab = BottomTab.values[index];
    data.selectedIndex = data.currentTab.index;
    if (data.currentTab.index == 0) {
      advertsBloc?.getData(advertsBloc.data.slideIndex ?? 0);
    }
    notifyListeners();
  }
}
