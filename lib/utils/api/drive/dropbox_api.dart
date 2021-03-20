import 'dart:convert';

import 'package:boxes/models/drive_file.dart';
import 'package:boxes/models/drive_usage.dart';
import 'package:boxes/models/dropbox/drop_box_thumbnails.dart';
import 'package:boxes/models/dropbox/dropbox_files.dart';
import 'package:boxes/models/enums/dirve_type_enum.dart';
import 'package:boxes/models/file_upload.dart';
import 'package:boxes/models/models.dart';
import 'package:boxes/models/response_model.dart';
import 'package:boxes/services/settings_store.dart';
import 'package:boxes/utils/api/request.dart';
import 'package:boxes/utils/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future addDropbox(String uid, String driveName) async {
    String _url =
        'https://www.dropbox.com/oauth2/authorize?client_id=$_appKey&token_access_type=offline&&state=$uid-$driveName&redirect_uri=https%3A%2F%2Fhome.fluttermovie.top%3A5001%2Fuser%2Fdropbox&response_type=code';
    if (await canLaunch(_url)) {
      await launch(_url, forceWebView: true);
    }
  }

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
    if (dropbox == null) return null;
    _userDropbox = dropbox;
    final String _url = '/2/users/get_space_usage';
    final _headers = {'Authorization': 'Bearer ${dropbox.accessToken}'};
    final _result =
        await _http.request(_url, method: "POST", headers: _headers);
    DriveUsage _usage;
    if (_result.success) {
      var _data = _result.result;
      _usage = DriveUsage(
          used: _data['used'],
          allocated: _data['allocation']['allocated'],
          lastUpdateTime: DateTime.now());
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
  Future<DriveFilesResponse> listRootFolder(
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
    final DriveFilesResponse _response = DriveFilesResponse(files: []);
    if (_result.success) _convrtFiles(_result, dropbox, null, _response);
    return _response;
  }

  @override
  Future<DriveFilesResponse> openFolder(
      UserDrive dropbox, DriveFile folder) async {
    _userDropbox = dropbox;
    final String _url = '/2/files/list_folder';
    final _headers = {
      'Authorization': 'Bearer ${dropbox.accessToken}',
    };
    final _data = {
      "path": folder.fileId,
      //"limit": 20,
    };
    final _result = await _http.request<DropboxFiles>(_url,
        method: "POST", headers: _headers, data: _data);

    final DriveFilesResponse _response = DriveFilesResponse(files: []);
    if (_result.success) _convrtFiles(_result, dropbox, folder, _response);
    return _response;
  }

  ///Once a cursor has been retrieved from list_folder,
  ///use this to paginate through all files and retrieve updates to the folder,
  ///following the same rules as documented for list_folder.

  @override
  Future<DriveFilesResponse> loadMoreFiles(
      UserDrive dropbox, DriveFile folder) async {
    _userDropbox = dropbox;
    final String _url = '/2/files/list_folder/continue';
    final _headers = {
      'Authorization': 'Bearer ${dropbox.accessToken}',
      'Content-Type': 'application/json'
    };
    final _data = {'cursor': folder.nextPageToken};
    final _result = await _http.request<DropboxFiles>(_url,
        method: "POST", headers: _headers, data: _data);
    final DriveFilesResponse _response = DriveFilesResponse(files: []);

    if (_result.success) _convrtFiles(_result, dropbox, folder, _response);
    return _response;
  }

  void _convrtFiles(ResponseModel<DropboxFiles> _result, UserDrive dropbox,
      DriveFile folder, DriveFilesResponse _response) {
    final List<DriveFile> _files = [];
    final _d = _result.result.entries;
    final _array = _d
        .map((e) => DriveFile(
            fileId: e.id,
            name: e.name,
            filePath: e.pathLower,
            type: e.tag,
            modifiedDate: e.serverModified ?? DateTime(1970, 7, 1),
            size: e.size,
            isDownloadable: e.isDownloadable ?? false,
            fileExtension: e.tag != 'folder' ? _fileExtension(e.name) : '',
            driveType: DriveTypeEnum.dropbox,
            driveId: dropbox.id,
            parentId: folder?.fileId))
        .toList();
    _files.addAll(_array);
    _response.nextPageToken = _result.result.cursor;
    _response.hasMore = _result.result.hasMore;
    _response.files = _files;
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
  @override
  Future<ResponseModel<dynamic>> getTemporaryLink(
      UserDrive dropbox, String fileId) async {
    _userDropbox = dropbox;
    final String _url = '/2/files/get_temporary_link';
    final _headers = {
      'Authorization': 'Bearer ${dropbox.accessToken}',
    };
    final _data = {'path': fileId};
    return await _http.request(_url,
        method: "POST", headers: _headers, data: _data);
  }

  @override
  Future<ResponseModel<DropBoxThumbnails>> getThumbnails(UserDrive dropbox,
      {List<String> paths = const []}) async {
    _userDropbox = dropbox;
    final String _url =
        'https://content.dropboxapi.com/2/files/get_thumbnail_batch';
    final _headers = {
      'Authorization': 'Bearer ${dropbox.accessToken}',
    };
    List _entries = paths
        .map((e) =>
            {"path": e, "format": "jpeg", "size": "w256h256", "mode": "strict"})
        .toList();
    final _data = {"entries": _entries};
    return await _http.request<DropBoxThumbnails>(_url,
        method: "POST", headers: _headers, data: _data);
  }

  @override
  Future<Map<String, dynamic>> getFileMetadata(
      UserDrive dropbox, String fileId) async {
    _userDropbox = dropbox;
    final String _url = '/2/files/get_metadata';
    final _headers = {
      'Authorization': 'Bearer ${dropbox.accessToken}',
    };
    final _data = {
      "path": fileId,
      "include_media_info": true,
    };
    final _result = await _http.request<Metadata>(_url,
        method: "POST", headers: _headers, data: _data);
    Map<String, dynamic> _metadata;
    if (_result.success) {
      final _d = _result.result.mediaInfo.metadata;
      _metadata = {
        "width": _d.dimensions.width,
        "height": _d.dimensions.height,
        "durationMillis": _d.duration.toString()
      };
    }
    return _metadata;
  }

  ///Upload sessions allow you to upload a single file in one or more requests,
  ///for example where the size of the file is greater than 150 MB.
  ///This call starts a new upload session with the given data.
  ///You can then use upload_session/append:2 to add more data and upload_session/finish to save all the data to a file in Dropbox.
  ///A single request should not upload more than 150 MB.
  ///The maximum size of a file one can upload to an upload session is 350 GB.
  @override
  Future createUpload(UserDrive dropbox, FileUpload file) async {
    final String _url =
        'https://content.dropboxapi.com/2/files/upload_session/start';
    final _headers = {
      'Authorization': 'Bearer ${dropbox.accessToken}',
      "content-type": "application/octet-stream",
      "content-length": 0,
    };
    final _result = await _http.request(_url,
        method: "POST",
        headers: _headers,
        data: Stream<List<int>>.fromIterable([]));
    String _sessionId;
    if (_result.success) _sessionId = _result.result["session_id"];
    return _sessionId;
  }

  ///Append more data to an upload session.
  ///session_id String The upload session ID (returned by upload_session/start).
  ///[offset] UInt64 Offset in bytes at which data should be appended.
  ///We use this to make sure upload data isn't lost or duplicated in the event of a network error.
  @override
  Future appendUpload(UserDrive dropbox, FileUpload file) async {
    final String _url =
        'https://content.dropboxapi.com/2/files/upload_session/append_v2';
    final _data = file.uploadContent;
    final _headers = {
      'Authorization': 'Bearer ${dropbox.accessToken}',
      "content-type": "application/octet-stream",
      "content-length": _data.length,
      "Dropbox-API-Arg":
          "{\"cursor\": {\"session_id\": \"${file.sessionId}\",\"offset\": ${file.stepIndex}},\"close\": false}",
    };
    final _result = await _http.request(_url,
        method: "POST",
        headers: _headers,
        data: Stream.fromIterable(_data.map((e) => [e])));

    return _result.success;
  }

  @override
  Future<ResponseModel> finshUpload(UserDrive dropbox, FileUpload file) async {
    final String _url =
        'https://content.dropboxapi.com/2/files/upload_session/finish';

    final _data = file.uploadContent;
    final _headers = {
      'Authorization': 'Bearer ${dropbox.accessToken}',
      "content-type": "application/octet-stream",
      "content-length": _data.length,
      "Dropbox-API-Arg":
          "{\"cursor\": {\"session_id\": \"${file.sessionId}\",\"offset\": ${file.stepIndex}},\"commit\": {\"path\": \"/${file.name}\",\"mode\": \"add\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}}",
    };
    final _result = await _http.request(_url,
        method: "POST",
        headers: _headers,
        data: Stream.fromIterable(_data.map((e) => [e])));

    return _result;
  }

  _fileExtension(String path) {
    if (path == null) return '';
    List<String> _strArray = path.split('.');

    return _strArray.last;
  }
}
