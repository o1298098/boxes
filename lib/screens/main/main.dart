import 'package:boxes/components/keepalive_widget.dart';
import 'package:boxes/components/side_menu.dart';
import 'package:boxes/responsive.dart';
import 'package:boxes/screens/home/home.dart';
import 'package:boxes/screens/home/home_mobile.dart';
import 'package:boxes/screens/main/main_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainStore _store = MainStore();
  PageController _pageController;
  final _pages = [
    keepAliveWrapper(HomeScreen()),
    Container(
      height: double.infinity,
      alignment: Alignment.center,
      color: kBgDarkColor,
      child: Text(
        '1',
        style: TextStyle(color: Color(0xFFFFFFFF)),
      ),
    ),
    Container(
      height: double.infinity,
      alignment: Alignment.center,
      color: kBgDarkColor,
      child: Text(
        '2',
        style: TextStyle(color: Color(0xFFFFFFFF)),
      ),
    ),
    Container(
      height: double.infinity,
      alignment: Alignment.center,
      color: kBgDarkColor,
      child: Text(
        '3',
        style: TextStyle(color: Color(0xFFFFFFFF)),
      ),
    ),
    Container(
      height: double.infinity,
      alignment: Alignment.center,
      color: kBgDarkColor,
      child: Text(
        '4',
        style: TextStyle(color: Color(0xFFFFFFFF)),
      ),
    ),
    Container(
      height: double.infinity,
      alignment: Alignment.center,
      color: kBgDarkColor,
      child: Text(
        '5',
        style: TextStyle(color: Color(0xFFFFFFFF)),
      ),
    ),
  ];

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Responsive(
          desktop: Observer(
            builder: (_) => Row(
              children: [
                SideMenu(
                  selectIndex: _store.pageIndex,
                  onTap: (i) {
                    _store.setPageIndex(i);
                    _pageController.jumpToPage(i);
                  },
                ),
                Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: _pages,
                  ),
                )
              ],
            ),
          ),
          tablet: Observer(
            builder: (_) => Row(
              children: [
                SideMenu(
                  selectIndex: _store.pageIndex,
                  onTap: (i) {
                    _store.setPageIndex(i);
                    _pageController.jumpToPage(i);
                  },
                ),
                Expanded(
                  flex: 14,
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: _pages,
                  ),
                )
              ],
            ),
          ),
          mobile: HomeMobileScreen(),
        ),
      ),
    );
  }
}
