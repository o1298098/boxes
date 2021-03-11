import 'dart:convert' show base64, json;
import 'package:boxes/utils/calculation.dart';
import 'package:mobx/mobx.dart';

import 'enums/dirve_type_enum.dart';

class DriveFile {
  DriveFile(
      {this.fileId,
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
      this.parentId});
  final int driveId;
  final String fileId;
  final String name;
  final String mimeType;
  final int size;
  Map<String, dynamic> mediaMetaData;
  final String fileExtension;
  final String type;
  final bool isDownloadable;
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

  get dropboxThumbnail =>
      this.thumbnailLink == null ? null : base64.decode(this.thumbnailLink);

  get isVideo => Calcuation.isVideo(this.fileExtension);

  get mediaDuration {
    final String _durationStr = this.mediaMetaData != null && this.isVideo
        ? this.mediaMetaData["durationMillis"]
        : null;
    final int _videoDuration =
        _durationStr == null ? 0 : int.tryParse(_durationStr);
    return _videoDuration;
  }

  Map<String, dynamic> toJson() {
    return {
      'driveId': driveId,
      'fileId': fileId,
      'mimeType': mimeType,
      'name': name,
      'size': size,
      'mediaMetaData': json.encode(mediaMetaData),
      'fileExtension': fileExtension,
      'type': type,
      'isDownloadable': isDownloadable ? 1 : 0,
      'downloadLink': downloadLink,
      'filePath': filePath,
      'thumbnailLink': thumbnailLink,
      'modifiedDate': modifiedDate?.toIso8601String() ?? '1970-07-01',
      'parentId': parentId,
      'driveType': driveType.index
    };
  }

  factory DriveFile.fromJson(Map<String, dynamic> data) {
    return DriveFile(
      driveId: data['driveId'],
      fileId: data['fileId'],
      mimeType: data['mimeType'],
      size: data['size'],
      name: data['name'],
      mediaMetaData: data['mediaMetaData'] == null
          ? null
          : json.decode(data['mediaMetaData']),
      fileExtension: data['fileExtension'],
      type: data['type'],
      isDownloadable: data['isDownloadable'] == 1,
      downloadLink: data['downloadLink'],
      filePath: data['filePath'],
      thumbnailLink: data['thumbnailLink'],
      modifiedDate: DateTime.parse(data['modifiedDate']),
      parentId: data['parentId'],
      driveType: DriveTypeEnum.values[data['driveType']],
    );
  }
}
