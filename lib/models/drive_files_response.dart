import 'package:boxes/models/drive_file.dart';

class DriveFilesResponse {
  DriveFilesResponse({this.nextPageToken, this.files, this.hasMore});
  String nextPageToken;
  List<DriveFile> files;
  bool hasMore;
}
