import 'package:boxes/models/models.dart';

abstract class DriveBaseApi {
  Future getToken(String code) async {}

  Future tokenRefresh(String refreshToken) async {}

  Future getSpaceUsage(UserDrive drive) async {}

  Future listFolder(UserDrive dropbox) async {}
}
