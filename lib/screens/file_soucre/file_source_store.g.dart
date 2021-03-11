// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_source_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileSourceStore on _FileSourceStore, Store {
  final _$selectDriveAtom = Atom(name: '_FileSourceStore.selectDrive');

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

  final _$selectedAtom = Atom(name: '_FileSourceStore.selected');

  @override
  bool get selected {
    _$selectedAtom.reportRead();
    return super.selected;
  }

  @override
  set selected(bool value) {
    _$selectedAtom.reportWrite(value, super.selected, () {
      super.selected = value;
    });
  }

  final _$_FileSourceStoreActionController =
      ActionController(name: '_FileSourceStore');

  @override
  dynamic setDrive(UserDrive drive) {
    final _$actionInfo = _$_FileSourceStoreActionController.startAction(
        name: '_FileSourceStore.setDrive');
    try {
      return super.setDrive(drive);
    } finally {
      _$_FileSourceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addService() {
    final _$actionInfo = _$_FileSourceStoreActionController.startAction(
        name: '_FileSourceStore.addService');
    try {
      return super.addService();
    } finally {
      _$_FileSourceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectDrive: ${selectDrive},
selected: ${selected}
    ''';
  }
}
