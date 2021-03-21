import 'dart:convert';
import 'package:boxes/models/enums/dirve_type_enum.dart';
import 'package:boxes/models/google/google_files.dart';
import 'package:boxes/models/models.dart';
import 'package:boxes/models/response_model.dart';
import 'package:boxes/services/settings_store.dart';
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
  Future addGoogleDrive(String uid, String driveName) async {
    String _url =
        'https://accounts.google.com/o/oauth2/v2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive%20email%20profile&access_type=offline&response_type=code&prompt=consent&state=$uid-$driveName&redirect_uri=https%3A%2F%2Fhome.fluttermovie.top%3A5001%2Fuser%2Fgoogle&client_id=$_clientId';
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
        final _dropboxIndex = store.appUser.userDrives
            .indexWhere((e) => e.id == _userGoogleDrive.id);
        if (_dropboxIndex == -1) return null;
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
          allocated: int.parse(_json['limit']),
          lastUpdateTime: DateTime.now());
    }
    return _usage;
  }

  ///[corpora]--Groupings of files to which the query applies. Supported groupings are: 'user' (files created by, opened by, or shared directly with the user), 'drive' (files in the specified shared drive as indicated by the 'driveId'), 'domain' (files shared to the user's domain), and 'allDrives' (A combination of 'user' and 'drive' for all drives where the user is a member). When able, use 'user' or 'drive', instead of 'allDrives', for efficiency.
  @override
  Future<DriveFilesResponse> listRootFolder(UserDrive googleDrive,
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
    var _data = {
      'fields': fields,
      'q': '"root" in parents and trashed = false',
      'orderBy': 'folder,modifiedTime desc',
    };
    var _result = await _http.request<GoogleFiles>(_url,
        headers: _headers, queryParameters: _data);
    final DriveFilesResponse _response = DriveFilesResponse(files: []);
    if (_result.success) _convertFiles(_result, googleDrive, null, _response);
    return _response;
  }

  @override
  Future<DriveFilesResponse> openFolder(UserDrive googleDrive, DriveFile folder,
      {String fields = '*',
      String driveId,
      String orderBy,
      String pageSize,
      String corpora}) async {
    _userGoogleDrive = googleDrive;
    String _url = '/files';
    final _headers = {
      'Authorization': 'Bearer ${googleDrive.accessToken}',
      'Content-Type': 'application/json'
    };
    var _data = {
      'fields': fields,
      'orderBy': 'folder,modifiedTime desc',
      'q': '"${folder.fileId}" in parents',
    };
    var _result = await _http.request<GoogleFiles>(_url,
        headers: _headers, queryParameters: _data);
    final DriveFilesResponse _response = DriveFilesResponse(files: []);
    if (_result.success) _convertFiles(_result, googleDrive, folder, _response);
    return _response;
  }

  @override
  Future<DriveFilesResponse> loadMoreFiles(
    UserDrive googleDrive,
    DriveFile folder, {
    String fields = '*',
  }) async {
    _userGoogleDrive = googleDrive;
    String _url = '/files';
    final _headers = {
      'Authorization': 'Bearer ${googleDrive.accessToken}',
      'Content-Type': 'application/json'
    };
    var _data = {
      'fields': fields,
      'orderBy': 'folder,modifiedTime desc',
      'pageToken': folder.nextPageToken,
    };
    if (folder != null)
      _data.addAll({'q': '"${folder.fileId ?? 'root'}" in parents'});
    var _result = await _http.request<GoogleFiles>(_url,
        headers: _headers, queryParameters: _data);
    final DriveFilesResponse _response = DriveFilesResponse(files: []);
    if (_result.success) _convertFiles(_result, googleDrive, folder, _response);
    return _response;
  }

  void _convertFiles(ResponseModel<GoogleFiles> _result, UserDrive googleDrive,
      DriveFile folder, DriveFilesResponse _response) {
    final List<DriveFile> _files = [];
    final _d = _result.result.files;
    final _array = _d
        .map((e) => DriveFile(
            fileId: e.id,
            name: e.name,
            type: e.mimeType == "application/vnd.google-apps.folder"
                ? 'folder'
                : 'file',
            modifiedDate: DateTime.parse(e.createdTime),
            size: e.size == null ? 0 : int.parse(e.size),
            isDownloadable: e.capabilities?.canDownload ?? false,
            downloadLink: e.webContentLink,
            fileExtension: e.fileExtension ?? '',
            mediaMetaData: e.imageMediaMetadata?.toJson() ??
                e.videoMediaMetadata?.toJson(),
            thumbnailLink: e.thumbnailLink,
            mimeType: e.mimeType,
            driveType: DriveTypeEnum.googleDrive,
            driveId: googleDrive.id,
            parentId: folder?.fileId))
        .toList();
    _files.addAll(_array);
    _response.nextPageToken = _result.result.nextPageToken;
    _response.hasMore = _result.result.nextPageToken != null;
    _response.files = _files;
  }

  Future createUpload(UserDrive googleDrive, FileUpload file) async {
    _userGoogleDrive = googleDrive;
    final String _url =
        'https://www.googleapis.com/upload/drive/v3/files?uploadType=resumable';

    final Map<String, dynamic> _data = {"name": file.name};
    if (file.folderId != null)
      _data.addAll({
        "parents": [file.folderId]
      });
    final _headers = {
      'Authorization': 'Bearer ${googleDrive.accessToken}',
      //'Content-Length': _data.length,
      //"Content-Range": "bytes 0-${_data.length - 1}/${file.fileSize - 1}"
    };
    final _result = await _http.request(_url,
        method: "POST", headers: _headers, data: _data);
    String _sessionId;
    if (_result.success)
      _sessionId = _result.headers['x-guploader-uploadid'][0];
    return _sessionId;
  }

  @override
  Future appendUpload(UserDrive googleDrive, FileUpload file) async {
    _userGoogleDrive = googleDrive;
    final String _url =
        'https://www.googleapis.com/upload/drive/v3/files?uploadType=resumable&upload_id=${file.sessionId}';
    final _data = file.uploadContent;
    final _headers = {
      'Authorization': 'Bearer ${googleDrive.accessToken}',
      'Content-Range':
          'bytes ${file.stepIndex}-${file.stepIndex + _data.length - 1}/${file.fileSize}',
      'content-length': _data.length
    };
    final _result = await _http.request(_url,
        method: "POST",
        headers: _headers,
        data: Stream.fromIterable(_data.map((e) => [e])));

    return _result.statusCode == 308;
  }

  @override
  Future<ResponseModel> finshUpload(
      UserDrive googleDrive, FileUpload file) async {
    _userGoogleDrive = googleDrive;
    final String _url =
        'https://www.googleapis.com/upload/drive/v3/files?uploadType=resumable&upload_id=${file.sessionId}';
    final _data = file.uploadContent;
    final _headers = {
      'Authorization': 'Bearer ${googleDrive.accessToken}',
      'Content-Range':
          'bytes ${file.stepIndex}-${file.stepIndex + _data.length - 1}/${file.fileSize}',
      'content-length': _data.length
    };
    final _result = await _http.request(_url,
        method: "POST",
        headers: _headers,
        data: Stream.fromIterable(_data.map((e) => [e])));

    return _result;
  }

  @override
  Future<DriveFile> createFolder(
      UserDrive googleDrive, FileUpload folder) async {
    _userGoogleDrive = googleDrive;
    DriveFile _folder;
    final _url = '/files';
    final _headers = {
      'Authorization': 'Bearer ${googleDrive.accessToken}',
    };
    final Map<String, dynamic> _data = {
      'name': folder.name,
      'mimeType': 'application/vnd.google-apps.folder'
    };
    if (folder.folderId != null)
      _data.addAll({
        "parents": [folder.folderId]
      });
    final _result = await _http.request(_url,
        method: "POST", headers: _headers, data: _data);
    if (_result.success) {
      final _e = _result.result;
      _folder = DriveFile(
        fileId: _e['id'],
        name: _e['name'],
        filePath: '',
        type: 'folder',
        modifiedDate: DateTime.now(),
        size: 0,
        isDownloadable: false,
        fileExtension: '',
        driveType: DriveTypeEnum.googleDrive,
        driveId: googleDrive.id,
        parentId: folder.folderId,
      );
    }
    return _folder;
  }

  @override
  Future<bool> deleteFile(UserDrive googleDrive, DriveFile file) async {
    _userGoogleDrive = googleDrive;
    final _url = '/files/${file.fileId}';
    final _headers = {
      'Authorization': 'Bearer ${googleDrive.accessToken}',
    };
    final _result =
        await _http.request(_url, method: "DELETE", headers: _headers);
    return _result.success;
  }
}
