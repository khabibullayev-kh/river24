import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outsource/presentation/advert_info/bloc/advert_info_bloc.dart';
import 'package:outsource/presentation/advert_info/view/advert_info.dart';
import 'package:outsource/presentation/home/bloc/home_bloc.dart';
import 'package:outsource/presentation/new_order/view/new_order_page.dart';
import 'package:outsource/presentation/adverts/view/orders_page.dart';
import 'package:outsource/presentation/profile/view/profile_page.dart';
import 'package:outsource/resources/app_icons.dart';
import 'package:outsource/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<HomeBloc>();
    final data = bloc.data;
    final selectedIndex = data.selectedIndex;
    return WillPopScope(
      onWillPop: () async {
        print("CURRENT STATE ${navigatorKey.currentContext}");
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState!.maybePop();
          return false;
        }

        return true;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: <BottomNavigationBarItem>[
            _createBottomNavBarItem(
              LocaleKeys.my_adverts.tr(),
              AppIcons.files,
              0,
              selectedIndex,
            ),
            _createBottomNavBarItem(
              LocaleKeys.new_adverts.tr(),
              AppIcons.addFile,
              1,
              selectedIndex,
            ),
            _createBottomNavBarItem(
              LocaleKeys.profile.tr(),
              AppIcons.account,
              2,
              selectedIndex,
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (index) =>
              bloc.changeTab(index: index, advertsBloc: bloc.advertsBloc),
        ),
        body: IndexedStack(
          index: data.currentTab.index,
          children: [
            Navigator(
              key: navigatorKey,
              onGenerateRoute: (settings) {
                Widget page = ChangeNotifierProvider.value(
                  value: bloc.advertsBloc,
                  child: const OrdersPage(),
                );
                print(settings.name);
                if (settings.name == '/home/adverts/advert_info') {
                  page = ChangeNotifierProvider(
                    create: (context) =>
                        AdvertInfoBloc(settings.arguments as int),
                    child: AdvertInfoPage(advertId: settings.arguments as int),
                  );
                }
                return MaterialPageRoute(builder: (_) => page);
              },
            ),
            ChangeNotifierProvider.value(
              value: bloc,
              child: ChangeNotifierProvider.value(
                value: bloc.newOrderBloc,
                child: const NewOrderPage(),
              ),
            ),
            ChangeNotifierProvider.value(
              value: bloc.profileBloc,
              child: const ProfilePage(),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _createBottomNavBarItem(
    String label,
    String icon,
    int index,
    int selectedIndex,
  ) {
    return BottomNavigationBarItem(
      label: label,
      icon: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SvgPicture.asset(
          icon,
          width: 33,
          height: 33,
          color: selectedIndex != index ? Colors.grey : Colors.black,
        ),
      ),
    );
  }
}
