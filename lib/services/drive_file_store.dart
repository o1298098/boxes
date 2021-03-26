import 'package:boxes/models/enums/dirve_type_enum.dart';
import 'package:mobx/mobx.dart';

part 'drive_file_store.g.dart';

class DriveFileStore = _DriveFileStore with _$DriveFileStore;

abstract class _DriveFileStore with Store {
  _DriveFileStore({
    this.fileId,
    this.name,
    this.fileExtension,
    this.filePath,
    this.isDownloadable = false,
    this.mediaMetaData,
    this.mimeType,
    this.size,
    this.type,
    this.modifiedDate,
    this.thumbnailLink,
    this.downloadLink,
    this.driveType,
    this.driveId,
    this.parentId,
  });
  final int driveId;
  final String fileId;
  final String name;
  final String mimeType;
  final int size;
  @observable
  Map<String, dynamic> mediaMetaData;
  final String fileExtension;
  final String type;
  final bool isDownloadable;
  @observable
  String downloadLink;
  final String filePath;
  @observable
  dynamic thumbnailLink;
  final DateTime modifiedDate;
  final String parentId;
  final DriveTypeEnum driveType;
  String nextPageToken;
  bool hasMoreFiles = true;
  bool firstLoading = true;
}
