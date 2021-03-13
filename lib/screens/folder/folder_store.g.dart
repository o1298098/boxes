// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FolderStore on _FolderStore, Store {
  final _$pathAtom = Atom(name: '_FolderStore.path');

  @override
  ObservableList<Item> get path {
    _$pathAtom.reportRead();
    return super.path;
  }

  @override
  set path(ObservableList<Item> value) {
    _$pathAtom.reportWrite(value, super.path, () {
      super.path = value;
    });
  }

  final _$loadingAtom = Atom(name: '_FolderStore.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$driveAtom = Atom(name: '_FolderStore.drive');

  @override
  UserDrive get drive {
    _$driveAtom.reportRead();
    return super.drive;
  }

  @override
  set drive(UserDrive value) {
    _$driveAtom.reportWrite(value, super.drive, () {
      super.drive = value;
    });
  }

  final _$foldersAtom = Atom(name: '_FolderStore.folders');

  @override
  ObservableList<DriveFile> get folders {
    _$foldersAtom.reportRead();
    return super.folders;
  }

  @override
  set folders(ObservableList<DriveFile> value) {
    _$foldersAtom.reportWrite(value, super.folders, () {
      super.folders = value;
    });
  }

  final _$filesAtom = Atom(name: '_FolderStore.files');

  @override
  ObservableList<DriveFile> get files {
    _$filesAtom.reportRead();
    return super.files;
  }

  @override
  set files(ObservableList<DriveFile> value) {
    _$filesAtom.reportWrite(value, super.files, () {
      super.files = value;
    });
  }

  final _$selectedFileAtom = Atom(name: '_FolderStore.selectedFile');

  @override
  DriveFile get selectedFile {
    _$selectedFileAtom.reportRead();
    return super.selectedFile;
  }

  @override
  set selectedFile(DriveFile value) {
    _$selectedFileAtom.reportWrite(value, super.selectedFile, () {
      super.selectedFile = value;
    });
  }

  final _$displayAsListAtom = Atom(name: '_FolderStore.displayAsList');

  @override
  bool get displayAsList {
    _$displayAsListAtom.reportRead();
    return super.displayAsList;
  }

  @override
  set displayAsList(bool value) {
    _$displayAsListAtom.reportWrite(value, super.displayAsList, () {
      super.displayAsList = value;
    });
  }

  final _$pathChangedAsyncAction = AsyncAction('_FolderStore.pathChanged');

  @override
  Future<dynamic> pathChanged(Item path) {
    return _$pathChangedAsyncAction.run(() => super.pathChanged(path));
  }

  final _$loadFolderAsyncAction = AsyncAction('_FolderStore.loadFolder');

  @override
  Future<dynamic> loadFolder(DriveFile folder) {
    return _$loadFolderAsyncAction.run(() => super.loadFolder(folder));
  }

  final _$loadMoreFilesAsyncAction = AsyncAction('_FolderStore.loadMoreFiles');

  @override
  Future<dynamic> loadMoreFiles() {
    return _$loadMoreFilesAsyncAction.run(() => super.loadMoreFiles());
  }

  final _$fileTapAsyncAction = AsyncAction('_FolderStore.fileTap');

  @override
  Future<dynamic> fileTap(DriveFile file) {
    return _$fileTapAsyncAction.run(() => super.fileTap(file));
  }

  final _$_getThumbnailAsyncAction = AsyncAction('_FolderStore._getThumbnail');

  @override
  Future<dynamic> _getThumbnail(List<DriveFile> f) {
    return _$_getThumbnailAsyncAction.run(() => super._getThumbnail(f));
  }

  final _$_FolderStoreActionController = ActionController(name: '_FolderStore');

  @override
  int fileCount(String folderId) {
    final _$actionInfo = _$_FolderStoreActionController.startAction(
        name: '_FolderStore.fileCount');
    try {
      return super.fileCount(folderId);
    } finally {
      _$_FolderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void layoutChange() {
    final _$actionInfo = _$_FolderStoreActionController.startAction(
        name: '_FolderStore.layoutChange');
    try {
      return super.layoutChange();
    } finally {
      _$_FolderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
path: ${path},
loading: ${loading},
drive: ${drive},
folders: ${folders},
files: ${files},
selectedFile: ${selectedFile},
displayAsList: ${displayAsList}
    ''';
  }
}
