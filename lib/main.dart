import 'package:boxes/screens/folder/folder.dart';
import 'package:boxes/screens/start/start.dart';
import 'package:boxes/utils/api/drive/dropbox_api.dart';
import 'package:boxes/utils/api/drive/google_drive_api.dart';
import 'package:boxes/utils/desktop_size.dart';
import 'package:flutter/foundation.dart';

import 'package:boxes/screens/main/main.dart';
import 'package:boxes/screens/user/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings/settings_store.dart';
import 'settings/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final _sharedPreferences = await SharedPreferences.getInstance();
  if (!kIsWeb) DesktopSize().set();
  runApp(MyApp(_sharedPreferences));
}

class MyApp extends StatelessWidget {
  const MyApp(this.sharedPreferences);
  final SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PreferencesService>(
          create: (_) => PreferencesService(sharedPreferences),
        ),
        ProxyProvider<PreferencesService, SettingsStore>(
            update: (_, preferencesService, __) =>
                SettingsStore(preferencesService)),
      ],
      child: MaterialApp(
        title: 'Boxes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        routes: <String, WidgetBuilder>{
          '/': (_) => MainScreen(),
          '/login': (_) => LoginScreen(),
          '/start': (_) => StartScreen(),
          '/folder': (_) => FolderScreen(),
        },
        initialRoute: '/start',
      ),
    );
  }
}
