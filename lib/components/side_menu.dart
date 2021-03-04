import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userHeight = MediaQuery.of(context).size.height - 450 > 0
        ? MediaQuery.of(context).size.height - 450
        : 20;
    return Scaffold(
      backgroundColor: kMenuBackgroundColor,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Container(
          constraints: BoxConstraints(maxWidth: 100),
          padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.sports_baseball_rounded,
                  color: kSelectIconColor,
                  size: 20,
                ),
                SizedBox(height: kDefaultPadding * 1.2),
                _MenuItem(
                  icon: Icons.home_outlined,
                  title: 'HOME',
                  selected: true,
                ),
                _MenuItem(
                  icon: Icons.folder_open_rounded,
                  title: 'ALL FILES',
                ),
                _MenuItem(
                  icon: Icons.slow_motion_video_outlined,
                  title: 'VIDEOS',
                ),
                _MenuItem(
                  icon: Icons.photo_size_select_actual_outlined,
                  title: 'PHOTOS',
                ),
                _MenuItem(
                  icon: Icons.access_time_outlined,
                  title: 'RECENT',
                ),
                _MenuItem(
                  icon: Icons.settings_outlined,
                  title: 'SETTINGS',
                ),
                Container(
                  height: _userHeight as double,
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () async =>
                        await Navigator.of(context).pushNamed('/login'),
                    child: Icon(
                      FontAwesomeIcons.userCircle,
                      color: kIconColor,
                      size: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  const _MenuItem({
    this.icon,
    this.title,
    this.selected = false,
  });
  @override
  Widget build(BuildContext context) {
    final _color = selected ? kSelectIconColor : kIconColor;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: kDefaultPadding * 1.2),
      decoration: selected
          ? BoxDecoration(
              border: Border(
              right: BorderSide(width: 2.0, color: _color),
            ))
          : null,
      child: Column(
        children: [
          Icon(
            icon,
            size: 16,
            color: _color,
          ),
          SizedBox(
            height: kDefaultPadding * 0.4,
          ),
          Text(
            title,
            style: TextStyle(
              color: _color,
              fontSize: 6,
            ),
          ),
        ],
      ),
    );
  }
}
