import 'package:boxes/models/models.dart';
import 'package:boxes/services/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'settings_store.g.dart';

class SettingsStore = _SettingsStore with _$SettingsStore;

abstract class _SettingsStore with Store {
  _SettingsStore(this._preferencesService) {
    useDarkMode = _preferencesService.useDarkMode;
    appUser = _preferencesService.appUser;
  }

  final PreferencesService _preferencesService;

  @observable
  User appUser;

  @observable
  bool useDarkMode = false;

  @action
  Future<void> setDarkMode({@required bool value}) async {
    _preferencesService.useDarkMode = value;
    useDarkMode = value;
  }

  @action
  Future<void> setAppUser({@required User value}) async {
    _preferencesService.appUser = value;
    appUser = value;
  }
}
