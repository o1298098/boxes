import 'package:boxes/models/enums/dirve_type_enum.dart';
import 'package:boxes/models/models.dart';
import 'package:boxes/models/response_model.dart';
import 'package:boxes/utils/api/request.dart';
import 'package:boxes/utils/app_config.dart';

class BaseApi {
  BaseApi._();
  static final BaseApi _instance = BaseApi._();
  static BaseApi get instance => _instance;

  final Request _http = Request(AppConfig.instance.baseApiHost);
  Future<ResponseModel<User>> updateUser(String uid, String email,
      String photoUrl, String userName, String phone) async {
    final String _url = '/User';
    final _data = {
      "phone": phone ?? '',
      "email": email ?? '',
      "photoUrl": photoUrl ?? '',
      "name": userName ?? '',
      "uid": uid,
      "createTime": DateTime.now().toIso8601String()
    };
    return await _http.request<User>(_url, method: "POST", data: _data);
  }

  Future<ResponseModel<UserDrive>> updateUserDropbox(
      String uid, UserDrive dropbox) async {
    final String _url = '/User/dropbox';
    final _data = {
      "uid": uid,
      "driveId": dropbox.driveId,
      "accessToken": dropbox.accessToken,
      "scope": dropbox.scope,
      "refreshToken": dropbox.refreshToken,
      "expiresIn": dropbox.expiresIn,
      "updateTime": DateTime.now().toIso8601String(),
      "driveType": DriveType.dropbox.index + 1,
      "tokenTpe": dropbox.tokenType
    };
    return _http.request<UserDrive>(_url, method: "POST", data: _data);
  }

  Future<ResponseModel<UserDrive>> userDropboxRefreshToken(
      String uid, UserDrive dropbox) async {
    final String _url = '/User/dropbox/refreshtoken';
    final _data = {
      "uid": uid,
      "driveId": dropbox.driveId,
      "accessToken": dropbox.accessToken,
      "scope": dropbox.scope,
      "refreshToken": dropbox.refreshToken,
      "expiresIn": dropbox.expiresIn,
      "updateTime": DateTime.now().toIso8601String(),
      "driveType": DriveType.dropbox.index + 1
    };
    return await _http.request<UserDrive>(_url, method: "POST", data: _data);
  }
}
