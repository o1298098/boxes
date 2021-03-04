import 'dart:convert';

import 'package:boxes/models/google/google_files.dart';
import 'package:boxes/models/models.dart';
import 'package:boxes/models/response_model.dart';
import 'package:boxes/settings/settings_store.dart';
import 'package:boxes/utils/api/request.dart';
import 'package:boxes/utils/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drive_base_api.dart';

class GoogleDriveApi extends DriveBaseApi {
  GoogleDriveApi._() {
    _http.onRefreshToken = () => _shouldRefreshToken();
  }
  static final GoogleDriveApi _instance = GoogleDriveApi._();
  static GoogleDriveApi get instance => _instance;
  final String _clientId = AppConfig.instance.googleApisClientId;
  final String _clientSecret = AppConfig.instance.googleApisClientSecret;
  final Request _http = Request('https://www.googleapis.com/drive/v3');

  UserDrive _userGoogleDrive;
  SettingsStore store;
  Future addGoogleDrive(String uid) async {
    String _url =
        'https://accounts.google.com/o/oauth2/v2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive%20email%20profile&access_type=offline&response_type=code&prompt=consent&state=$uid&redirect_uri=https%3A%2F%2Fhome.fluttermovie.top%3A5001%2Fuser%2Fgoogle&client_id=$_clientId';
    if (await canLaunch(_url)) {
      await launch(_url, forceWebView: true);
    }
  }

  @override
  Future<ResponseModel<dynamic>> tokenRefresh(String refreshToken) async {
    final String _url = 'https://oauth2.googleapis.com/token';
    final _data = {
      'client_id': _clientId,
      'client_secret': _clientSecret,
      'refresh_token': refreshToken,
      'grant_type': 'refresh_token',
    };
    final _headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    return await _http.tokenRequest(_url,
        method: "POST", queryParameters: _data, headers: _headers);
  }

  Future<String> _shouldRefreshToken() async {
    final _result = await tokenRefresh(_userGoogleDrive.refreshToken);
    String _newToken;
    Map<String, dynamic> _data;
    if (_result.success) {
      if (_result.result is String)
        _data = json.decode(_result.result);
      else
        _data = _result.result;
      _newToken = _data['access_token'];
      if (_newToken != null) {
        final _dropboxIndex =
            store.appUser.userDrives.indexOf(_userGoogleDrive);
        final _user = store.appUser.copyWith();
        _user.userDrives[_dropboxIndex].accessToken = _newToken;
        store.setAppUser(value: _user);
      }
    }
    return _newToken;
  }

  @override
  Future<DriveUsage> getSpaceUsage(UserDrive googleDrive) async {
    _userGoogleDrive = googleDrive;
    String _url = '/about';
    final _headers = {
      'Authorization': 'Bearer ${googleDrive.accessToken}',
      'Content-Type': 'application/json'
    };
    var _data = {'fields': 'storageQuota'};
    var _result =
        await _http.request(_url, headers: _headers, queryParameters: _data);
    DriveUsage _usage;
    if (_result.success) {
      final _json = _result.result['storageQuota'];
      _usage = DriveUsage(
          used: int.parse(_json['usage']),
          allocated: int.parse(_json['limit']));
    }
    return _usage;
  }

  ///[corpora]--Groupings of files to which the query applies. Supported groupings are: 'user' (files created by, opened by, or shared directly with the user), 'drive' (files in the specified shared drive as indicated by the 'driveId'), 'domain' (files shared to the user's domain), and 'allDrives' (A combination of 'user' and 'drive' for all drives where the user is a member). When able, use 'user' or 'drive', instead of 'allDrives', for efficiency.
  @override
  Future<List<DriveFile>> listFolder(UserDrive googleDrive,
      {String fields = '*',
      String driveId,
      String orderBy,
      String pageSize,
      String corpora}) async {
    String _url = '/files';
    final _headers = {
      'Authorization': 'Bearer ${googleDrive.accessToken}',
      'Content-Type': 'application/json'
    };
    var _data = {'fields': fields};
    var _result = await _http.request<GoogleFiles>(_url,
        headers: _headers, queryParameters: _data);
    final List<DriveFile> _files = [];
    if (_result.success) {
      final _d = _result.result.files;
      final _array = _d
          .map((e) => DriveFile(
              fileId: e.id,
              name: e.name,
              type: e.mimeType == "application/vnd.google-apps.folder"
                  ? 'folder'
                  : 'file',
              modifiedDate: DateTime.parse(e.modifiedTime),
              size: e.size == null ? 0 : int.parse(e.size),
              isDownloadable: true,
              fileExtension: e.fileExtension ?? '',
              mediaMetaData: e.imageMediaMetadata?.toJson(),
              mimeType: e.mimeType))
          .toList();
      _files.addAll(_array);
    }
    return _files;
  }
}
