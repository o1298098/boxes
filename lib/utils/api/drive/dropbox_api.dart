import 'dart:convert';

import 'package:boxes/models/drive_file.dart';
import 'package:boxes/models/drive_usage.dart';
import 'package:boxes/models/dropbox/dropbox_files.dart';
import 'package:boxes/models/models.dart';
import 'package:boxes/models/response_model.dart';
import 'package:boxes/settings/settings_store.dart';
import 'package:boxes/utils/api/request.dart';
import 'package:boxes/utils/app_config.dart';

import 'drive_base_api.dart';

class DropboxApi extends DriveBaseApi {
  DropboxApi._() {
    _http.onRefreshToken = () => _shouldRefreshToken();
  }

  static final DropboxApi _instance = DropboxApi._();
  static DropboxApi get instance => _instance;

  final String _appKey = AppConfig.instance.dropboxAppKey;
  final String _appSecret = AppConfig.instance.dropboxAppSecret;

  final Request _http = Request(AppConfig.instance.dropboxApiHost);
  UserDrive _userDropbox;
  SettingsStore store;

  ///This endpoint only applies to apps using the authorization code flow. An app calls this endpoint to acquire a bearer token once the user has authorized the app.
  ///
  ///Calls to /oauth2/token need to be authenticated using the apps's key and secret.
  ///These can either be passed as application/x-www-form-urlencoded POST parameters (see parameters below) or via HTTP basic authentication.
  ///If basic authentication is used, the app key should be provided as the username, and the app secret should be provided as the password.
  ///
  ///[code] --authorization code

  @override
  Future<ResponseModel<dynamic>> getToken(String code) async {
    final String _url = '/oauth2/token';
    final _data = {
      'code': code,
      'grant_type': 'authorization_code',
    };
    final _authorization = base64.encode(utf8.encode("$_appKey:$_appSecret"));
    final _headers = {
      'Authorization': 'Basic $_authorization',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    return await _http.request(_url,
        method: "POST", queryParameters: _data, headers: _headers);
  }

  ///When input grant_type=refresh_token:
  ///Use the refresh token to get a new access token. This request won't return a new refresh token since refresh tokens don't expire automatically and can be reused repeatedly.
  ///access_token String The access token to be used to call the Dropbox API.
  ///expires_in String The length of time that the access token will be valid for.
  ///token_type String Will always be bearer.
  ///Example:
  ///```json
  ///{
  ///"access_token": "sl.abcd1234efg",
  ///"expires_in": "13220",
  ///"token_type": "bearer"
  ///}
  ///```
  @override
  Future<ResponseModel<dynamic>> tokenRefresh(String refreshToken) async {
    final String _url = '/oauth2/token';
    final _data = {
      'refresh_token': refreshToken,
      'grant_type': 'refresh_token',
    };
    final _authorization = base64.encode(utf8.encode("$_appKey:$_appSecret"));
    final _headers = {
      'Authorization': 'Basic $_authorization',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    return await _http.tokenRequest(_url,
        method: "POST", queryParameters: _data, headers: _headers);
  }

  Future<String> _shouldRefreshToken() async {
    final _result = await tokenRefresh(_userDropbox.refreshToken);
    String _newToken;
    Map<String, dynamic> _data;
    if (_result.success) {
      if (_result.result is String)
        _data = json.decode(_result.result);
      else
        _data = _result.result;
      _newToken = _data['access_token'];
      if (_newToken != null) {
        final _dropboxIndex = store.appUser.userDrives.indexOf(_userDropbox);
        final _user = store.appUser.copyWith();
        _user.userDrives[_dropboxIndex].accessToken = _newToken;
        store.setAppUser(value: _user);
      }
    }
    return _newToken;
  }

  @override
  Future<DriveUsage> getSpaceUsage(UserDrive dropbox) async {
    _userDropbox = dropbox;
    final String _url = '/2/users/get_space_usage';
    final _headers = {'Authorization': 'Bearer ${dropbox.accessToken}'};
    final _result =
        await _http.request(_url, method: "POST", headers: _headers);
    DriveUsage _usage;
    if (_result.success) {
      var _data = _result.result;
      _usage = DriveUsage(
          used: _data['used'], allocated: _data['allocation']['allocated']);
    }
    return _usage;
  }

  ///Starts returning the contents of a folder. If the result's ListFolderResult.has_more field is true, call list_folder/continue with the returned ListFolderResult.cursor to retrieve more entries.
  ///If you're using ListFolderArg.recursive set to true to keep a local cache of the contents of a Dropbox account, iterate through each entry in order and process them as follows to keep your local state in sync:
  ///For each FileMetadata, store the new entry at the given path in your local state. If the required parent folders don't exist yet, create them. If there's already something else at the given path, replace it and remove all its children.
  ///For each FolderMetadata, store the new entry at the given path in your local state. If the required parent folders don't exist yet, create them. If there's already something else at the given path, replace it but leave the children as they are. Check the new entry's FolderSharingInfo.read_only and set all its children's read-only statuses to match.
  ///For each DeletedMetadata, if your local state has something at the given path, remove it and all its children. If there's nothing at the given path, ignore this entry.
  ///Note: auth.RateLimitError may be returned if multiple list_folder or list_folder/continue calls with same parameters are made simultaneously by same API app for same user. If your app implements retry logic, please hold off the retry until the previous request finishes.
  @override
  Future<List<DriveFile>> listFolder(
    UserDrive dropbox, {
    String path = '',
    bool recursive = false,
    bool includeMediaInfo = false,
    bool includeDeleted = false,
    bool includeHasExplicitSharedMembers = false,
    bool includeMountedFolders = false,
    int limit,
  }) async {
    _userDropbox = dropbox;
    final String _url = '/2/files/list_folder';
    final _headers = {
      'Authorization': 'Bearer ${dropbox.accessToken}',
      'Content-Type': 'application/json'
    };
    final _data = {
      "path": "",
      "include_media_info": includeMediaInfo,
      "recursive": recursive,
      "include_deleted": includeDeleted,
      "include_has_explicit_shared_members": includeHasExplicitSharedMembers,
      "include_mounted_folders": includeMountedFolders
    };
    if (limit != null) _data.addAll({"limit": limit});
    final _result = await _http.request<DropboxFiles>(_url,
        method: "POST", headers: _headers, data: _data);
    final List<DriveFile> _files = [];
    if (_result.success) {
      final _d = _result.result.entries;
      final _array = _d
          .map((e) => DriveFile(
                fileId: e.id,
                name: e.name,
                filePath: e.pathLower,
                type: e.tag,
                modifiedDate: e.serverModified,
                size: e.size,
                isDownloadable: e.isDownloadable,
                fileExtension: e.tag != 'folder' ? _fileExtension(e.name) : '',
              ))
          .toList();
      _files.addAll(_array);
    }
    return _files;
  }

  ///Once a cursor has been retrieved from list_folder,
  ///use this to paginate through all files and retrieve updates to the folder,
  ///following the same rules as documented for list_folder.
  Future<ResponseModel<dynamic>> listFolderContinue(
      UserDrive dropbox, String cursor) async {
    _userDropbox = dropbox;
    final String _url = '/2/files/list_folder/continue';
    final _headers = {
      'Authorization': 'Bearer ${dropbox.accessToken}',
      'Content-Type': 'application/json'
    };
    final _data = {'cursor': cursor};
    return await _http.request(_url,
        method: "POST", headers: _headers, data: _data);
  }

  ///A way to quickly get a cursor for the folder's state. Unlike list_folder,
  ///list_folder/get_latest_cursor doesn't return any entries.
  ///This endpoint is for app which only needs to know about new files and modifications and
  ///doesn't need to know about files that already exist in Dropbox.

  Future<ResponseModel<dynamic>> listFolderLatestCursor(
    UserDrive dropbox, {
    String path = '',
    bool recursive = false,
    bool includeMediaInfo = false,
    bool includeDeleted = false,
    bool includeHasExplicitSharedMembers = false,
    bool includeMountedFolders = false,
    int limit,
  }) async {
    _userDropbox = dropbox;
    final String _url = '/2/files/list_folder/get_latest_cursor';
    final _headers = {
      'Authorization': 'Bearer ${dropbox.accessToken}',
      'Content-Type': 'application/json'
    };
    final _data = {
      "path": "",
      "include_media_info": includeMediaInfo,
      "recursive": recursive,
      "include_deleted": includeDeleted,
      "include_has_explicit_shared_members": includeHasExplicitSharedMembers,
      "include_mounted_folders": includeMountedFolders
    };
    if (limit != null) _data.addAll({"limit": limit});
    return await _http.request(_url,
        method: "POST", headers: _headers, data: _data);
  }

  ///Get a temporary link to stream content of a file.
  ///This link will expire in four hours and afterwards you will get 410 Gone.
  ///This URL should not be used to display content directly in the browser.
  ///The Content-Type of the link is determined automatically by the file's mime type.

  Future<ResponseModel<dynamic>> getTemporaryLink(
      UserDrive dropbox, String path) async {
    _userDropbox = dropbox;
    final String _url = '/2/files/get_temporary_link';
    final _headers = {
      'Authorization': 'Bearer ${dropbox.accessToken}',
      'Content-Type': 'application/json'
    };
    final _data = {'path': path};
    return await _http.request(_url,
        method: "POST", headers: _headers, data: _data);
  }

  _fileExtension(String path) {
    if (path == null) return '';
    List<String> _strArray = path.split('.');

    return _strArray.last;
  }
}
