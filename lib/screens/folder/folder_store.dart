import 'package:boxes/models/models.dart';
import 'package:boxes/utils/api/drive/drive_api_factory.dart';
import 'package:boxes/utils/api/drive/drive_base_api.dart';
import 'package:mobx/mobx.dart';

part 'folder_store.g.dart';

class FolderStore = _FolderStore with _$FolderStore;

abstract class _FolderStore with Store {
  _FolderStore(this.drive) {
    files.addAll(drive.files ?? []);
    _init();
  }

  _init() async {
    if (drive == null) return;
    final DriveBaseApi _api = DriveApiFactory.getInstance(drive.driveType.id);
    final List<DriveFile> _result = await (_api.listFolder(drive));
    ObservableList<DriveFile> _f = ObservableList<DriveFile>();
    _f.addAll(_result);
    files = _f;
    drive.files = files;
  }

  @observable
  UserDrive drive;

  @observable
  ObservableList<DriveFile> files = ObservableList<DriveFile>();
}
