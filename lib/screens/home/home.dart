import 'dart:convert';

import 'package:boxes/models/models.dart';
import 'package:boxes/screens/home/components/drives_panel.dart';
import 'package:boxes/screens/home/components/dropbox_dialog.dart';
import 'package:boxes/screens/home/components/storage_card.dart';
import 'package:boxes/settings/settings_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:boxes/utils/api/base_api.dart';
import 'package:boxes/utils/api/drive/dropbox_api.dart';
import 'package:boxes/utils/api/drive/google_drive_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _dropboxCodeSubmit(String code) async {
      var _store = Provider.of<SettingsStore>(context, listen: false);
      var _user = _store.appUser;
      var _dateTime = DateTime.now();
      var _result = await DropboxApi.instance.getToken(code);
      if (_result.success) {
        var _data = json.decode(_result.result);
        print(_result.result);
        final _userDropbox = UserDrive(
            accessToken: _data['access_token'].toString(),
            expiresIn: _dateTime.add(Duration(hours: 4)).toIso8601String(),
            scope: _data['scope'].toString(),
            refreshToken: _data['refresh_token'].toString(),
            driveId: _data['uid'].toString(),
            tokenType: _data['token_type'].toString());
        var _baseResult =
            await BaseApi.instance.updateUserDropbox(_user.uid, _userDropbox);
        if (_baseResult.success) {
          final User _newUser = _user.copyWith();
          _newUser.userDrives.add(_baseResult.result);
          _store.setAppUser(value: _newUser);
        }
        print(_baseResult.result);
      }

      print(_result);
    }

    _authorize() async {
      final _url =
          'https://www.dropbox.com/oauth2/authorize?client_id=y1amw5aqtb443qq&token_access_type=offline&response_type=code';
      if (await canLaunch(_url)) {
        await launch(_url);
        showDialog(
            context: context,
            builder: (_) => SimpleDialog(
                  backgroundColor: kBgLightColor,
                  children: [
                    DropboxDialog(
                      onSubmit: (s) async => await _dropboxCodeSubmit(s),
                    )
                  ],
                ));
      } else {
        throw 'Could not launch $_url';
      }
    }

    _getSpace() async {
      var _store = Provider.of<SettingsStore>(context, listen: false);
      var _user = _store.appUser;
      var _result = await DropboxApi.instance.listFolder(_user.userDrives[0]);
      print(_result);
    }

    _getGoogleApiToken() async {
      var _store = Provider.of<SettingsStore>(context, listen: false);
      var _user = _store.appUser;
      GoogleDriveApi.instance
        ..addGoogleDrive(_user?.uid ?? '').then((value) {
          print("get the code");
        });
    }

    _getGoogleDrives() async {
      var _store = Provider.of<SettingsStore>(context, listen: false);
      var _user = _store.appUser;

      var _drive =
          _user.userDrives.firstWhere((e) => e.driveType.id == 1, orElse: null);
      if (_drive == null) return;
      await GoogleDriveApi.instance.getSpaceUsage(_drive);
    }

    return Scaffold(
      backgroundColor: kBgDarkColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: CustomScrollView(
            slivers: [
              SliverStaggeredGrid.extent(
                staggeredTiles: [
                  StaggeredTile.extent(1, 160),
                  StaggeredTile.extent(1, 160),
                  StaggeredTile.extent(1, 160),
                  StaggeredTile.extent(1, 160),
                  StaggeredTile.extent(1, 160),
                  StaggeredTile.extent(1, 160),
                ],
                mainAxisSpacing: kDefaultPadding,
                crossAxisSpacing: kDefaultPadding,
                //childAspectRatio: Responsive.isMobile(context) ? 8 / 7 : 5 / 4,
                maxCrossAxisExtent: 180,
                children: [
                  StorageCard(
                    icon: 'assets/images/google_drive_logo.svg',
                    title: 'Google Drive',
                    used: 7.5,
                    total: 15.0,
                  ),
                  StorageCard(
                    icon: 'assets/images/dropbox_logo.svg',
                    title: 'Dropbox',
                    used: 1.23,
                    total: 2,
                  ),
                  StorageCard(
                    icon: 'assets/images/onedrive_logo.svg',
                    title: 'One Drive',
                    used: 5.23,
                    total: 20,
                  ),
                  StorageCard(
                    icon: 'assets/images/onedrive_logo.svg',
                    title: 'One Drive',
                    used: 6.23,
                    total: 20,
                  ),
                  StorageCard(
                    icon: 'assets/images/onedrive_logo.svg',
                    title: 'One Drive',
                    used: 18.5,
                    total: 20,
                  ),
                  StorageCard(
                    icon: 'assets/images/onedrive_logo.svg',
                    title: 'One Drive',
                    used: 10.5,
                    total: 20,
                  ),
                ],
              ),
              Consumer<SettingsStore>(
                builder: (_, store, __) => Observer(
                  builder: (_) => DrivesPanel(
                    drives: store.appUser?.userDrives ?? [],
                  ),
                ),
              ),
              /*SliverToBoxAdapter(
                child: Container(
                  height: 100,
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () async => await _getGoogleApiToken(),
                        child: Text('Dropbox')),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
