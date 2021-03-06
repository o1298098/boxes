// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SettingsStore on _SettingsStore, Store {
  final _$appUserAtom = Atom(name: '_SettingsStore.appUser');

  @override
  User get appUser {
    _$appUserAtom.reportRead();
    return super.appUser;
  }

  @override
  set appUser(User value) {
    _$appUserAtom.reportWrite(value, super.appUser, () {
      super.appUser = value;
    });
  }

  final _$useDarkModeAtom = Atom(name: '_SettingsStore.useDarkMode');

  @override
  bool get useDarkMode {
    _$useDarkModeAtom.reportRead();
    return super.useDarkMode;
  }

  @override
  set useDarkMode(bool value) {
    _$useDarkModeAtom.reportWrite(value, super.useDarkMode, () {
      super.useDarkMode = value;
    });
  }

  final _$setDarkModeAsyncAction = AsyncAction('_SettingsStore.setDarkMode');

  @override
  Future<void> setDarkMode({@required bool value}) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(value: value));
  }

  final _$setAppUserAsyncAction = AsyncAction('_SettingsStore.setAppUser');

  @override
  Future<void> setAppUser({@required User value}) {
    return _$setAppUserAsyncAction.run(() => super.setAppUser(value: value));
  }

  @override
  String toString() {
    return '''
appUser: ${appUser},
useDarkMode: ${useDarkMode}
    ''';
  }
}
