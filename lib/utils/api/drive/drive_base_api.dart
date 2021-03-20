import 'package:boxes/models/file_upload.dart';
import 'package:boxes/models/models.dart';

abstract class DriveBaseApi {
  Future getToken(String code) async {}

  Future tokenRefresh(String refreshToken) async {}

  Future getSpaceUsage(UserDrive drive) async {}

  Future listRootFolder(UserDrive drive) async {}

  Future openFolder(UserDrive drive, DriveFile folder) async {}

  Future loadMoreFiles(UserDrive drive, DriveFile folder) async {}

  Future getThumbnails(UserDrive drive,
      {List<String> paths = const []}) async {}

  Future getFileMetadata(UserDrive drive, String fileId) async {}

  Future getTemporaryLink(UserDrive drive, String fileId) async {}

  Future createUpload(UserDrive drive, FileUpload file) async {}

  Future appendUpload(UserDrive drive, FileUpload file) async {}
  Future finshUpload(UserDrive drive, FileUpload file) async {}
}
