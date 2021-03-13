import 'package:boxes/models/user_drive.dart';
import 'package:boxes/responsive.dart';
import 'package:boxes/screens/home/components/sliverappbar_delegate.dart';
import 'package:boxes/settings/settings_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Menu extends StatelessWidget {
  final SettingsStore store;
  final Function onAddService;
  final Function(UserDrive) onDriveTap;

  const Menu({Key key, this.store, this.onAddService, this.onDriveTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _dark = _mediaQuery.platformBrightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
          color: _dark ? kBgDarkColor : Color(0xFFE0E0E0E0),
          border: Border(
            right: BorderSide(
              color: kLineColor.withAlpha(20),
              width: 1.0,
            ),
          )),
      child: CustomScrollView(
        slivers: [
          _CustomAppBar(
            title: 'Add Service',
            showCloseButton: Responsive.isMobile(context),
          ),
          SliverToBoxAdapter(
              child: Container(
            height: 40,
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, bottom: 8.0, top: 15.0),
            child: const Text('Cloud Services'),
          )),
          Observer(
            builder: (_) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  if (index < store.appUser.userDrives.length) {
                    final _d = store.appUser.userDrives[index];
                    return _DriveItem(
                      d: _d,
                      onTap: onDriveTap,
                    );
                  }
                  return AddServiceItem(
                    onTap: onAddService,
                  );
                },
                childCount: store.appUser.userDrives.length + 1,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({
    Key key,
    this.showCloseButton,
    this.title,
  }) : super(key: key);

  final bool showCloseButton;
  final String title;

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _dark = _mediaQuery.platformBrightness == Brightness.dark;
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 60,
        maxHeight: 60,
        child: Container(
          padding: EdgeInsets.all(kDefaultPadding),
          color: _dark ? kBgLightColor : Colors.white,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddServiceItem extends StatelessWidget {
  final Function onTap;
  const AddServiceItem({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _dark = _mediaQuery.platformBrightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: _dark ? kBgLightColor : Color(0xFFFFFFFF),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
        child: Row(
          children: [
            Icon(Icons.add, size: 20),
            SizedBox(width: 20),
            const Text(
              'Add Service',
              style: TextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DriveItem extends StatelessWidget {
  const _DriveItem({
    Key key,
    @required UserDrive d,
    this.onTap,
  })  : _d = d,
        super(key: key);

  final UserDrive _d;
  final Function(UserDrive) onTap;

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _dark = _mediaQuery.platformBrightness == Brightness.dark;

    return InkWell(
      onTap: () => onTap(_d),
      child: Container(
        color: _dark ? kBgLightColor : Color(0xFFFFFFFF),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9.0),
              child: Row(
                children: [
                  Icon(
                    _getIcon(_d.driveType.name),
                    size: 20,
                  ),
                  SizedBox(width: 20),
                  Text(
                    _d.name ?? _d.driveType.name,
                    style: TextStyle(),
                  ),
                  Spacer(),
                  Icon(Icons.info_outline, size: 16)
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}

_getIcon(String driveName) {
  switch (driveName) {
    case 'Google Drive':
      return FontAwesomeIcons.googleDrive;
    case 'Dropbox':
      return FontAwesomeIcons.dropbox;
    case 'One Drive':
      return FontAwesomeIcons.microsoft;
    default:
      return FontAwesomeIcons.server;
  }
}
