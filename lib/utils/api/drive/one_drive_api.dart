import 'drive_base_api.dart';

class OneDriveApi extends DriveBaseApi {
  OneDriveApi._();
  static final OneDriveApi _instance = OneDriveApi._();
  static OneDriveApi get instance => _instance;
  @override
  Future getToken(String code) async {}
}
