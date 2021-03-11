import 'package:boxes/models/models.dart';
import 'package:boxes/screens/folder/folder.dart';
import 'package:boxes/screens/home/components/drives_panel.dart';
import 'package:boxes/screens/home/home_store.dart';
import 'package:boxes/settings/settings_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../components/custom_app_bar.dart';
import 'components/sliverappbar_delegate.dart';

class HomeScreen extends StatelessWidget {
  final _store = HomeStore();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDarkColor,
      body: Observer(
        builder: (_) => _store.selectDrive == null
            ? _DrivePanel(onTap: _store.setDrive)
            : FolderScreen(
                drive: _store.selectDrive,
                onPop: () => _store.setDrive(null),
              ),
      ),
    );
  }
}

class _DrivePanel extends StatelessWidget {
  const _DrivePanel({
    Key key,
    this.onTap,
  }) : super(key: key);
  final Function(UserDrive) onTap;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.5 * kDefaultPadding),
        child: Consumer<SettingsStore>(
          builder: (_, store, __) => CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    maxHeight: 60,
                    minHeight: 60,
                    child: CustomAppBar(
                      title: 'Home',
                      actions: [
                        InkWell(
                          onTap: () async {
                            store.appUser == null
                                ? await Navigator.of(context)
                                    .pushNamed('/signin')
                                : await Navigator.of(context)
                                    .pushNamed('/filesource');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(kDefaultPadding * .5),
                            child: Icon(
                              CupertinoIcons.add_circled,
                              color: kIconColor,
                              size: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(kDefaultPadding * .5),
                          child: Icon(
                            CupertinoIcons.search,
                            color: kIconColor,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  )),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 1.5 * kDefaultPadding,
                ),
              ),
              Observer(
                builder: (_) => DrivesPanel(
                  drives: store.appUser?.userDrives ?? [],
                  onTap: onTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
