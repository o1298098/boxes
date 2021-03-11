import 'package:boxes/screens/file_soucre/file_source.dart';
import 'package:boxes/screens/folder/folder.dart';
import 'package:boxes/screens/start/start.dart';
import 'package:boxes/screens/user/account.dart';
import 'package:boxes/utils/database_service.dart';
import 'package:boxes/utils/platform_config.dart';
import 'package:flutter/foundation.dart';

import 'package:boxes/screens/main/main.dart';
import 'package:boxes/screens/user/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings/settings_store.dart';
import 'settings/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DatabaseService();
  final _sharedPreferences = await SharedPreferences.getInstance();
  if (!kIsWeb) PlatformConfig().set();
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
        onGenerateRoute: (RouteSettings settings) {
          //print('build route for ${settings.name}');
          var routes = <String, WidgetBuilder>{
            '/': (_) => MainScreen(),
            '/signin': (_) => SignInScreen(),
            '/start': (_) => StartScreen(),
            '/filesource': (_) => FileSourceScreen(),
            '/folder': (context) => FolderScreen(
                  drive: settings.arguments,
                ),
            '/account': (_) => AccountSrceen(
                  settings: settings.arguments,
                ),
          };
          WidgetBuilder builder = routes[settings.name];
          return MaterialPageRoute(builder: (ctx) => builder(ctx));
        },
        initialRoute: '/start',
      ),
    );
  }
}
