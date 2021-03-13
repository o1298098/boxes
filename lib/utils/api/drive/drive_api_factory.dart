import 'package:boxes/utils/api/drive/dropbox_api.dart';
import 'package:boxes/utils/api/drive/google_drive_api.dart';
import 'package:boxes/utils/api/drive/one_drive_api.dart';

import 'drive_base_api.dart';

class DriveApiFactory {
  static DriveBaseApi getInstance(int driveType) {
    switch (driveType) {
      case 1:
        return GoogleDriveApi.instance;
      case 2:
        return DropboxApi.instance;
      case 3:
        return OneDriveApi.instance;
      default:
        return GoogleDriveApi.instance;
    }
  }
}
