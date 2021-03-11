import 'package:boxes/models/user_drive.dart';
import 'package:mobx/mobx.dart';

part 'file_source_store.g.dart';

class FileSourceStore = _FileSourceStore with _$FileSourceStore;

abstract class _FileSourceStore with Store {
  _FileSourceStore();

  @observable
  UserDrive selectDrive;

  @observable
  bool selected = false;

  @observable
  bool get isEdit => selectDrive != null;

  @action
  setDrive(UserDrive drive) {
    selected = drive != null;
    selectDrive = drive;
  }

  @action
  addService() {
    selected = true;
    selectDrive = null;
  }
}
