// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on _HomeStore, Store {
  final _$selectDriveAtom = Atom(name: '_HomeStore.selectDrive');

  @override
  UserDrive get selectDrive {
    _$selectDriveAtom.reportRead();
    return super.selectDrive;
  }

  @override
  set selectDrive(UserDrive value) {
    _$selectDriveAtom.reportWrite(value, super.selectDrive, () {
      super.selectDrive = value;
    });
  }

  final _$_HomeStoreActionController = ActionController(name: '_HomeStore');

  @override
  dynamic setDrive(UserDrive value) {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.setDrive');
    try {
      return super.setDrive(value);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectDrive: ${selectDrive}
    ''';
  }
}
