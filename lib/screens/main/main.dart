import 'package:boxes/components/side_menu.dart';
import 'package:boxes/responsive.dart';
import 'package:boxes/screens/detail/detail.dart';
import 'package:boxes/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Responsive(
          desktop: Row(
            children: [
              Expanded(
                flex: 1,
                child: SideMenu(),
              ),
              Expanded(
                flex: 14,
                child: HomeScreen(),
              )
            ],
          ),
          tablet: Row(
            children: [
              Expanded(
                flex: 10,
                child: HomeScreen(),
              ),
              Expanded(
                flex: 4,
                child: Detail(),
              ),
            ],
          ),
          mobile: HomeScreen(),
        ),
      ),
    );
  }
}
