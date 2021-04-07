import 'package:boxes/screens/file_soucre/file_source.dart';
import 'package:boxes/screens/folder/folder.dart';
import 'package:boxes/screens/start/start.dart';
import 'package:boxes/screens/user/account.dart';
import 'package:boxes/style/colors.dart';
import 'package:boxes/utils/platform_config.dart';
import 'package:flutter/foundation.dart';

import 'package:boxes/screens/main/main.dart';
import 'package:boxes/screens/user/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/database_service.dart';
import 'services/settings_store.dart';
import 'services/shared_preferences.dart';
import 'services/upload_service.dart';

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
        Provider<UploadService>(
          create: (_) => UploadService()..init(),
        ),
      ],
      child: MaterialApp(
        title: 'Boxes',
        debugShowCheckedModeBanner: false,
        theme: AppStyle.lightTheme,
        darkTheme: AppStyle.darkTheme,
        themeMode: ThemeMode.system,
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
