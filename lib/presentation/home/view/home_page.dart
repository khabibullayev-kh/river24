import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outsource/presentation/home/models/bottom_tab.dart';
import 'package:outsource/presentation/new_order/view/new_order_page.dart';
import 'package:outsource/presentation/adverts/view/orders_page.dart';
import 'package:outsource/presentation/profile/view/profile_page.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/resources/app_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final _pages = const <Widget>[
    OrdersPage(),
    NewOrderPage(),
    ProfilePage(),
  ];

  BottomTab _currentTab = BottomTab.orders;

  void _changeTab(int index) {
    setState(() {
      _currentTab = BottomTab.values[index];
      _selectedIndex = _currentTab.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          _createBottomNavBarItem(BottomTab.orders),
          _createBottomNavBarItem(BottomTab.newOrder),
          _createBottomNavBarItem(BottomTab.profile),
        ],
        currentIndex: _selectedIndex,
        onTap: _changeTab,
      ),
      body: IndexedStack(
        index: _currentTab.index,
        children: _pages,
      ),
    );
  }


  BottomNavigationBarItem _createBottomNavBarItem(BottomTab tab) {
    return BottomNavigationBarItem(
      label: tab.label,
      icon: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SvgPicture.asset(
          tab.icon,
          width: 33,
          height: 33,
          color: _selectedIndex != tab.index ? Colors.grey : Colors.black,
        ),
      ),
    );
  }
}
