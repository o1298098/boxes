import 'package:boxes/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;

class PreferencesService {
  PreferencesService(this._sharedPreferences);

  static const String _appUser = 'appUser';
  static const String _useDarkModeKey = 'useDarkMode';
  final SharedPreferences _sharedPreferences;

  set appUser(User user) {
    _sharedPreferences.setString(_appUser, user.toString());
  }

  User get appUser {
    //_sharedPreferences.clear();
    final _userStr = _sharedPreferences.getString(_appUser) ?? '';
    return _userStr.isNotEmpty ? User.fromJson(json.decode(_userStr)) : null;
  }

  set useDarkMode(bool useDarkMode) {
    _sharedPreferences.setBool(_useDarkModeKey, useDarkMode);
  }

  bool get useDarkMode => _sharedPreferences.getBool(_useDarkModeKey) ?? false;
}
