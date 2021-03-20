// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileUploadStore on _FileUploadStore, Store {
  final _$sessionIdAtom = Atom(name: '_FileUploadStore.sessionId');

  @override
  String get sessionId {
    _$sessionIdAtom.reportRead();
    return super.sessionId;
  }

  @override
  set sessionId(String value) {
    _$sessionIdAtom.reportWrite(value, super.sessionId, () {
      super.sessionId = value;
    });
  }

  final _$stepIndexAtom = Atom(name: '_FileUploadStore.stepIndex');

  @override
  int get stepIndex {
    _$stepIndexAtom.reportRead();
    return super.stepIndex;
  }

  @override
  set stepIndex(int value) {
    _$stepIndexAtom.reportWrite(value, super.stepIndex, () {
      super.stepIndex = value;
    });
  }

  final _$statusAtom = Atom(name: '_FileUploadStore.status');

  @override
  UploadStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(UploadStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  @override
  String toString() {
    return '''
sessionId: ${sessionId},
stepIndex: ${stepIndex},
status: ${status}
    ''';
  }
}
