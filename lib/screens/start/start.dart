import 'package:boxes/screens/main/main.dart';
import 'package:boxes/settings/settings_store.dart';
import 'package:boxes/utils/api/drive/dropbox_api.dart';
import 'package:boxes/utils/api/drive/google_drive_api.dart';
import 'package:boxes/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Future _init() async {
    await AppConfig.instance.init(context);
    final _store = Provider.of<SettingsStore>(context, listen: false);
    DropboxApi.instance.store = _store;
    GoogleDriveApi.instance.store = _store;
  }

  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 100),
      () async => Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) {
            Navigator.of(context).maybePop(false);
            return MainScreen();
          },
        ),
      ),
    );
    super.initState();
  }

  Future<double> _checkContextInit(Stream<double> source) async {
    await _init();
    await for (double value in source) {
      if (value > 0) {
        return value;
      }
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkContextInit(
          Stream<double>.periodic(Duration(milliseconds: 50),
              (x) => MediaQuery.of(context).size.height),
        ),
        builder: (_, snapshot) {
          return Container();
        });
  }
}
