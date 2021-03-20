// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UploadService on _UploadService, Store {
  final _$queueAtom = Atom(name: '_UploadService.queue');

  @override
  ObservableList<FileUpload> get queue {
    _$queueAtom.reportRead();
    return super.queue;
  }

  @override
  set queue(ObservableList<FileUpload> value) {
    _$queueAtom.reportWrite(value, super.queue, () {
      super.queue = value;
    });
  }

  final _$_updateQueueAsyncAction = AsyncAction('_UploadService._updateQueue');

  @override
  Future _updateQueue(FileUpload file) {
    return _$_updateQueueAsyncAction.run(() => super._updateQueue(file));
  }

  @override
  String toString() {
    return '''
queue: ${queue}
    ''';
  }
}
