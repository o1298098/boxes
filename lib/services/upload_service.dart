import 'package:boxes/models/enums/upload_status.dart';
import 'package:boxes/models/models.dart';
import 'package:boxes/models/user_drive.dart';
import 'package:boxes/utils/api/drive/drive_api_factory.dart';
import 'package:boxes/utils/api/drive/drive_base_api.dart';
import 'package:mobx/mobx.dart';
import 'package:cross_file/cross_file.dart';

import 'database_service.dart';

part 'upload_service.g.dart';

class UploadService = _UploadService with _$UploadService;

abstract class _UploadService with Store {
  @observable
  ObservableList<FileUpload> queue = ObservableList<FileUpload>();
  final DatabaseService _db = DatabaseService();
  final int _uploadSize = 256 * 1024;
  final List<UserDrive> _drives = [];
  //final int _maxUploadTask = 5;
  init() {
    _db.getUploadList().then((list) {
      if (list.length > 0)
        queue.addAll(
            list..sort((a, b) => a.uploadDate.isAfter(b.uploadDate) ? 0 : 1));
    });
  }

  uploadFile(UserDrive drive, FileUpload file) async {
    final _newfile = file.copyWith(uploadSize: _uploadSize);
    await _updateQueue(_newfile);
    _createUpdateSession(drive, _newfile);
  }

  start(String uploadId) async {
    final FileUpload _file = _getUploadFile(uploadId);
    if (_file == null) return;
    final _drive = await _getUserDrive(_file.driveId);
    if (_drive == null) return;
    if (_file.data == null) {
      assert(_file.filePath != null);
      final _data = XFile(_file.filePath);
      assert(_data != null);
      _file.data = (await _data.readAsBytes()).buffer;
    }
    if (_file.sessionId == null)
      _createUpdateSession(_drive, _file);
    else {
      _file.status = UploadStatus.uploading;
      _file.uploadSize = _uploadSize;
      await _updateQueue(_file);
      final _api = DriveApiFactory.getInstance(_drive.driveType.id);
      _uploading(_drive, _file, _api);
    }
  }

  startALl() {}
  stopAll() {}
  delete() {}
  retry() {}
  Future<bool> stop(String uploadId) async {
    final _file = _getUploadFile(uploadId);
    if (_file != null) {
      await _updateQueue(_file.copyWith(status: UploadStatus.stop));
      return true;
    }
    return false;
  }

  _createUpdateSession(UserDrive drive, FileUpload file) async {
    final _api = DriveApiFactory.getInstance(drive.driveType.id);
    final _result = await _api.createUpload(drive, file);
    if (_result == null) return;
    final _file = file.copyWith(
        stepIndex: 0, sessionId: _result, status: UploadStatus.uploading);
    await _updateQueue(_file);
    _uploading(drive, _file, _api);
  }

  _uploading(UserDrive drive, FileUpload file, DriveBaseApi api) async {
    if (file.status != UploadStatus.uploading) return;
    int _lenght = file.fileSize - file.stepIndex > _uploadSize
        ? _uploadSize
        : file.fileSize - file.stepIndex;
    if (_lenght == _uploadSize) {
      final _success = await api.appendUpload(drive, file);
      if (!_success) {
        //print('retry offset:${file.stepIndex}');
        await _uploading(drive, file, api);
      } else {
        //print('offset:${file.stepIndex + _lenght}');
        final _file = _getUploadFile(file.uploadId);
        _file.stepIndex = file.stepIndex + _lenght;
        await _updateQueue(_file);
        await _uploading(drive, _file, api);
      }
    } else
      await _finshUpload(drive, file, api);
  }

  _finshUpload(UserDrive drive, FileUpload file, DriveBaseApi api) async {
    if (file.status != UploadStatus.uploading) return;
    final _result = await api.finshUpload(drive, file);
    if (_result.success) {
      file.stepIndex = file.fileSize;
      file.status = UploadStatus.finsh;
      await _updateQueue(file);

      print(_result.result);
    } else
      print('upload false');
  }

  @action
  _updateQueue(FileUpload file) async {
    await _db.insertUploadFile(file);
    int _index = queue.indexWhere((e) => e.uploadId == file.uploadId);
    if (_index != -1)
      queue[_index] = file;
    else
      queue.insert(0, file);
  }

  FileUpload _getUploadFile(String uploadId) {
    return queue.firstWhere((e) => e.uploadId == uploadId, orElse: () => null);
  }

  Future<UserDrive> _getUserDrive(int driveId) async {
    UserDrive _drive =
        _drives.firstWhere((e) => e.id == driveId, orElse: () => null);
    if (_drive == null) {
      final _list = await _db.getDrive(driveId);
      if (_list.length > 0) {
        _drive = _list[0];
        _drives.add(_list[0]);
      }
    }
    return _drive;
  }
}
