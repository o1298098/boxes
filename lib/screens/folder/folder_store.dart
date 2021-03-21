import 'package:boxes/models/enums/upload_status.dart';
import 'package:boxes/models/models.dart';
import 'package:boxes/models/response_model.dart';
import 'package:boxes/services/database_service.dart';
import 'package:boxes/services/upload_service.dart';
import 'package:boxes/utils/api/drive/drive_api_factory.dart';
import 'package:boxes/utils/api/drive/drive_base_api.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'folder_store.g.dart';

class FolderStore = _FolderStore with _$FolderStore;

abstract class _FolderStore with Store {
  _FolderStore(this.drive, {this.uploadService}) {
    _api = DriveApiFactory.getInstance(drive.driveType.id);
    if (uploadService != null)
      uploadService.callbackWhenUploadFinsh =
          (file) async => await _uploadFinshCallBack(file);
    _init();
  }

  DriveBaseApi _api;

  UploadService uploadService;

  final List<DriveFile> _fileIndex = [];

  final DatabaseService _db = DatabaseService();

  String _currectFolderId;

  DriveFile _rootFolder = DriveFile(name: 'Home');

  bool get _isRoot => _currectFolderId == null;

  @observable
  ObservableList<Item> path = ObservableList<Item>();

  @observable
  bool loading = false;

  @observable
  UserDrive drive;

  @observable
  ObservableList<DriveFile> folders;

  @observable
  ObservableList<DriveFile> files;

  @observable
  DriveFile selectedFile;

  @observable
  bool displayAsList = false;

  ObservableList<DriveFile> get foldersAndFiles =>
      ObservableList()..addAll(folders)..addAll(files);

  Function previewShow = () {};

  _init() async {
    if (drive == null) return;
    await loadFolder(_rootFolder);
  }

  @action
  Future pathChanged(Item path) async {
    if (path == null) return;
    if (path.value == null) {
      await loadFolder(_rootFolder);
    } else {
      final _folder = _fileIndex.firstWhere((e) => e.fileId == path.value,
          orElse: () => null);
      if (_folder != null) await loadFolder(_folder);
    }
  }

  @action
  Future loadFolder(DriveFile folder) async {
    loading = true;
    _currectFolderId = folder?.fileId;
    _updatePath(
        folder: _isRoot ? null : Item(name: folder.name, value: folder.fileId));
    if (!_fileExists(folder)) {
      List<DriveFile> _dbFiles = [];
      if (!kIsWeb)
        _dbFiles = _isRoot
            ? await _db.getRootFiles(drive.id)
            : await _db.getFolderFiles(drive.id, folder.fileId);
      _setCurrectFolder(_dbFiles, folderId: folder?.fileId);
    } else
      _getFileFromIndex(folder?.fileId);
    if (!_shouldAutoRefresh(folder)) return;
    final DriveFilesResponse _response = _isRoot
        ? await _api.listRootFolder(drive)
        : await _api.openFolder(drive, folder);
    final _result = _response.files;
    _result.sort((a, b) => (b.modifiedDate.isBefore(a.modifiedDate) ? 0 : 1));
    final _files = _result.where((e) => e.type != 'folder').toList();
    final _folders = _result.where((e) => e.type == 'folder').toList();
    if (_files.length > 0) {
      if (_currectFolderId == folder?.fileId) {
        if (_isRoot) {
          _rootFolder.nextPageToken = _response.nextPageToken;
          _rootFolder.hasMoreFiles = _response.hasMore;
          _rootFolder.firstLoading = false;
        } else {
          folder.nextPageToken = _response.nextPageToken;
          folder.hasMoreFiles = _response.hasMore;
          folder.firstLoading = false;
        }
        _files.removeWhere((e) => files.any((d) => d.fileId == e.fileId));
        _folders.removeWhere((e) => folders.any((d) => d.fileId == e.fileId));
        files.insertAll(0, _files);
        folders.insertAll(0, _folders);
        //files.sort((a, b) => (b.modifiedDate.isBefore(a.modifiedDate) ? 0 : 1));
      }
      loading = false;
      if (_currectFolderId == folder?.fileId) {
        _fileIndex.removeWhere((e) => e.parentId == folder?.fileId);
        _fileIndex.addAll(files);
        _fileIndex.addAll(folders);

        /*_isRoot
          ? await _db.cleanRoot(drive.id)
          : await _db.cleanFolder(drive.id, folder.fileId);*/
      }
      await _getThumbnail(files);
      for (var e in files) {
        await _db.insertFile(e);
      }
      for (var e in folders) {
        await _db.insertFile(e);
      }
    }
    loading = false;
  }

  @action
  Future loadMoreFiles() async {
    DriveFile _folder;
    if (_isRoot)
      _folder = _rootFolder;
    else
      _folder = _fileIndex.firstWhere((e) => e.fileId == _currectFolderId,
          orElse: () => null);
    if (!(_folder?.hasMoreFiles ?? false)) return;
    final _response = await _api.loadMoreFiles(drive, _folder);
    final _result = _response.files;
    final List<DriveFile> _files =
        _result.where((e) => e.type != 'folder').toList();
    final List<DriveFile> _folders =
        _result.where((e) => e.type == 'folder').toList();
    if (_files.length > 0) {
      if (_currectFolderId == _folder?.fileId) {
        if (_isRoot) {
          _rootFolder.nextPageToken = _response.nextPageToken;
          _rootFolder.hasMoreFiles = _response.hasMore;
          _rootFolder.firstLoading = false;
        } else {
          _folder.nextPageToken = _response.nextPageToken;
          _folder.hasMoreFiles = _response.hasMore;
          _folder.firstLoading = false;
        }
        _files.removeWhere((e) => files.any((d) => d.fileId == e.fileId));
        _folders.removeWhere((e) => folders.any((d) => d.fileId == e.fileId));
        files.addAll(_files);
        folders.addAll(_folders);
      }
      _fileIndex.addAll(_files);
      _fileIndex.addAll(_folders);
      await _getThumbnail(_files);
      for (var e in _result) {
        await _db.insertFile(e);
      }
    }
    loading = false;
  }

  @action
  Future fileTap(DriveFile file) async {
    previewShow();
    if (selectedFile == file) return;
    selectedFile = file;
    if (selectedFile.isVideo && selectedFile.mediaMetaData == null) {
      final _result = await _api.getFileMetadata(drive, selectedFile.fileId);
      if (_result is Map) {
        if (file.fileId != selectedFile.fileId) return;
        file.mediaMetaData = _result;
        selectedFile = file;
        await _db.insertFile(selectedFile);
      }
    }
    if (selectedFile.isVideo && selectedFile.downloadLink == null) {
      final _api =
          DriveApiFactory.getInstance(selectedFile.driveType.index + 1);
      final ResponseModel _result =
          await _api.getTemporaryLink(drive, selectedFile.fileId);
      if (_result.success) {
        if (file.fileId != selectedFile.fileId) return;
        file.downloadLink = _result.result["link"];
        selectedFile = file;
      }
    }
  }

  bool _fileExists(DriveFile folder) {
    return _fileIndex.any((e) => e.parentId == folder?.fileId);
  }

  void _setCurrectFolder(List<DriveFile> folderFiles, {String folderId}) {
    files = ObservableList<DriveFile>();
    folders = ObservableList<DriveFile>();
    if ((folderFiles.length ?? 0) > 0) {
      if (_currectFolderId == folderId) {
        folderFiles
            .sort((a, b) => (b.modifiedDate.isBefore(a.modifiedDate) ? 0 : 1));

        final _files = folderFiles.where((e) => e.type != 'folder').toList();
        final _folders = folderFiles.where((e) => e.type == 'folder').toList();

        files.addAll(_files);
        folders.addAll(_folders);
      }
      _fileIndex.addAll(folderFiles);
      loading = false;
    }
  }

  void _getFileFromIndex(String folderId) {
    files = ObservableList<DriveFile>();
    folders = ObservableList<DriveFile>();
    final _files = _fileIndex.where((e) => e.parentId == folderId).toList();
    _files.sort((a, b) => (b.modifiedDate.isBefore(a.modifiedDate) ? 0 : 1));
    if (_currectFolderId == folderId) {
      files.addAll(_files.where((e) => e.type != 'folder'));
      folders.addAll(_files.where((e) => e.type == 'folder'));
      loading = false;
    }
  }

  @action
  Future _getThumbnail(List<DriveFile> f) async {
    if (drive.driveType.name == "Dropbox") {
      final _list = f.where((e) => e.thumbnailLink == null).toList();
      for (int i = 0; i < _list.length; i = i + 20) {
        int _range = (_list.length - (20 + i)) >= 0 ? 20 : _list.length - i;
        print('count:${_list.length}-----I:$i ------$_range');
        final ResponseModel<DropBoxThumbnails> _thumbnails =
            await _api.getThumbnails(drive,
                paths: _list
                    .getRange(i, i + _range)
                    .map((e) => e.filePath)
                    .toList());
        if (_thumbnails.success) {
          int _k = i;
          _thumbnails.result.entries.forEach((e) {
            if (e.tag == 'success') {
              _list[_k].thumbnailLink = e.thumbnail;
            }
            _k++;
          });
        }
      }
      print('finsh');
    }
  }

  @action
  int fileCount(String folderId) {
    return _fileIndex.where((e) => e.parentId == folderId).toList().length;
  }

  @action
  void layoutChange() {
    displayAsList = !displayAsList;
  }

  void onUploadFile() async {
    final _files = await FilePickerCross.importFromStorage();
    final _file = _files.toUint8List().buffer;
    final _pathStr = path.skip(1).map((e) => e.name).join('/');
    FileUpload _fileUpload = FileUpload(
        uploadId: Uuid().v1(),
        driveId: drive.id,
        name: _files.fileName,
        folderId: _currectFolderId,
        folderPath: '/${_pathStr.isEmpty ? '' : _pathStr + '/'}',
        filePath: _files.path,
        uploadDate: DateTime.now(),
        fileSize: _files.length,
        stepIndex: 0,
        status: UploadStatus.waiting,
        data: _file);
    uploadService.uploadFile(drive, _fileUpload);
  }

  void _updatePath({Item folder}) {
    if (folder == null) {
      path.clear();
      path = path..add(Item(name: 'Home'));
      return;
    }
    Item _r =
        path.firstWhere((e) => e.value == folder?.value, orElse: () => null);
    if (_r != null) {
      int _index = path.indexOf(_r);
      path = path..removeRange(_index + 1, path.length);
      return;
    } else
      path = path..add(Item(name: folder.name, value: folder.value));
  }

  @action
  Future<bool> createFolder(String folderName) async {
    print(folderName);
    if (folderName?.isNotEmpty == true) {
      final _pathStr = path.skip(1).map((e) => e.name).join('/');
      FileUpload _newFolder = FileUpload(
        uploadId: Uuid().v1(),
        driveId: drive.id,
        name: folderName,
        folderId: _currectFolderId,
        folderPath: '/${_pathStr.isEmpty ? '' : _pathStr + '/'}',
        filePath: '',
        uploadDate: DateTime.now(),
        fileSize: 0,
        stepIndex: 0,
      );
      final DriveFile _folder = await _api.createFolder(drive, _newFolder);
      if (_folder != null) {
        folders.insert(0, _folder);
        _fileIndex.add(_folder);
        await _db.insertFile(_folder);
        return true;
      }
    }
    return false;
  }

  Future _uploadFinshCallBack(FileUpload file) async {
    if (file.driveId != drive.id) return;
    if (_isRoot) await loadFolder(_rootFolder);
    final _folder = _fileIndex.firstWhere((e) => e.fileId == _currectFolderId,
        orElse: () => null);
    if (_folder != null) await loadFolder(_folder);
  }

  bool _shouldAutoRefresh(DriveFile folder) {
    return folder?.firstLoading ?? true;
  }
}
