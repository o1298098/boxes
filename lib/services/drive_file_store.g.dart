// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_file_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DriveFileStore on _DriveFileStore, Store {
  final _$mediaMetaDataAtom = Atom(name: '_DriveFileStore.mediaMetaData');

  @override
  Map<String, dynamic> get mediaMetaData {
    _$mediaMetaDataAtom.reportRead();
    return super.mediaMetaData;
  }

  @override
  set mediaMetaData(Map<String, dynamic> value) {
    _$mediaMetaDataAtom.reportWrite(value, super.mediaMetaData, () {
      super.mediaMetaData = value;
    });
  }

  final _$downloadLinkAtom = Atom(name: '_DriveFileStore.downloadLink');

  @override
  String get downloadLink {
    _$downloadLinkAtom.reportRead();
    return super.downloadLink;
  }

  @override
  set downloadLink(String value) {
    _$downloadLinkAtom.reportWrite(value, super.downloadLink, () {
      super.downloadLink = value;
    });
  }

  final _$thumbnailLinkAtom = Atom(name: '_DriveFileStore.thumbnailLink');

  @override
  dynamic get thumbnailLink {
    _$thumbnailLinkAtom.reportRead();
    return super.thumbnailLink;
  }

  @override
  set thumbnailLink(dynamic value) {
    _$thumbnailLinkAtom.reportWrite(value, super.thumbnailLink, () {
      super.thumbnailLink = value;
    });
  }

  @override
  String toString() {
    return '''
mediaMetaData: ${mediaMetaData},
downloadLink: ${downloadLink},
thumbnailLink: ${thumbnailLink}
    ''';
  }
}
