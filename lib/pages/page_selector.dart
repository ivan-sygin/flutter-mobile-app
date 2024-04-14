import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sochi/api/main_api/main_api.dart';
import 'package:sochi/pages/main_pages/common_page.dart';
import 'package:sochi/pages/main_pages/profile_page.dart';
import 'package:sochi/pages/main_pages/request_page.dart';
import 'package:sochi/storages/requests_storage.dart';
import 'package:sochi/storages/user_storage.dart';
import 'package:provider/provider.dart';

class PageSelector extends StatefulWidget {
  const PageSelector({super.key});

  @override
  State<PageSelector> createState() => _PageSelector();
}

class _PageSelector extends State<PageSelector> {
  int _currentIndex = 0;
  String? token = "";
  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    final userStorage = Provider.of<UserStorage>(context, listen: false);
    MainApi.getUserInfo().then((value) => userStorage.setUserInfo(value));

    final requestsStorage = Provider.of<RequestStorage>(context, listen: false);
    requestsStorage.loadRequestsFromServer();

    _widgetOptions = [
      CommonPage(),
      RequestPage(),
      ProfilePage(),
      Placeholder()
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) _widgetOptions[0] = CommonPage();
      if (index == 1) _widgetOptions[1] = RequestPage();
      if (index == 2) _widgetOptions[2] = ProfilePage();
      if (index == 3) _widgetOptions[3] = Placeholder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _widgetOptions,
      ),
      extendBody: false,
      bottomNavigationBar: FloatingNavbar(
        backgroundColor: Colors.black54,
        iconSize: 18,
        fontSize: 10,
        margin: EdgeInsets.all(0),
        currentIndex: _currentIndex,
        items: [
          FloatingNavbarItem(icon: Icons.home_rounded, title: "Главная"),
          FloatingNavbarItem(icon: Icons.description, title: "Заявки"),
          FloatingNavbarItem(icon: Icons.person, title: "Профиль")
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
