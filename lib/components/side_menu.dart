import 'package:boxes/services/settings_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  final int selectIndex;
  final Function(int) onTap;
  const SideMenu({this.onTap, this.selectIndex});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _mediaQuery = MediaQuery.of(context);
    final _menuHeight = 530 + _mediaQuery.padding.top;
    final _userHeight = _mediaQuery.size.height - _menuHeight > 0
        ? _mediaQuery.size.height - _menuHeight
        : 0.0;
    /*final List _menuItems = [
    {'name': 'HOME', 'icon': Icons.home_outlined},
    {'name': 'ALL FILES', 'icon': Icons.folder_open_rounded},
    {'name': 'VIDEOS', 'icon': Icons.slow_motion_video_outlined},
    {'name': 'PHOTOS', 'icon': Icons.photo_size_select_actual_outlined},
    {'name': 'RECENT', 'icon': Icons.access_time_outlined},
    {'name': 'SETTINGS', 'icon': Icons.settings_outlined},
  ];*/
    return Container(
      width: 65 + _mediaQuery.padding.left,
      color: _theme.cardColor,
      child: SafeArea(
        top: true,
        bottom: false,
        right: false,
        left: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.sports_baseball_rounded,
                  color: _theme.colorScheme.onPrimary,
                  size: 20,
                ),
                SizedBox(height: kDefaultPadding * 1.6),
                _MenuItem(
                  icon: Icons.home_outlined,
                  title: 'HOME',
                  selected: selectIndex == 0,
                  index: 0,
                  onTap: onTap,
                ),
                _MenuItem(
                  icon: Icons.folder_open_rounded,
                  title: 'ALL FILES',
                  selected: selectIndex == 1,
                  index: 1,
                  onTap: onTap,
                ),
                _MenuItem(
                  icon: Icons.slow_motion_video_outlined,
                  title: 'VIDEOS',
                  selected: selectIndex == 2,
                  index: 2,
                  onTap: onTap,
                ),
                _MenuItem(
                  icon: Icons.photo_size_select_actual_outlined,
                  title: 'PHOTOS',
                  selected: selectIndex == 3,
                  index: 3,
                  onTap: onTap,
                ),
                _MenuItem(
                  icon: Icons.access_time_outlined,
                  title: 'RECENT',
                  selected: selectIndex == 4,
                  index: 4,
                  onTap: onTap,
                ),
                _MenuItem(
                  icon: Icons.settings_outlined,
                  title: 'SETTINGS',
                  selected: selectIndex == 5,
                  index: 5,
                  onTap: onTap,
                ),
                SizedBox(height: _userHeight),
                Consumer<SettingsStore>(
                  builder: (_, store, __) => InkWell(
                    onTap: () async {
                      store.appUser == null
                          ? await Navigator.of(context).pushNamed('/signin')
                          : await Navigator.of(context)
                              .pushNamed('/account', arguments: store);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: Icon(
                        FontAwesomeIcons.userCircle,
                        color: kIconColor,
                        size: 15,
                      ),
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
  final int index;
  final Function(int) onTap;
  const _MenuItem({
    this.icon,
    this.title,
    this.selected = false,
    this.index,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _color =
        selected ? _theme.colorScheme.onPrimary : _theme.colorScheme.primary;
    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: kDefaultPadding * .8),
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
            const SizedBox(
              height: kDefaultPadding * 0.4,
            ),
            Text(
              title,
              style: TextStyle(
                color: _color,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
