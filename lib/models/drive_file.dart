import 'dart:convert' show base64, json;
import 'package:boxes/services/drive_file_store.dart';
import 'package:boxes/utils/calculation.dart';

import 'enums/dirve_type_enum.dart';

class DriveFile extends DriveFileStore {
  DriveFile({
    int driveId,
    String fileId,
    String name,
    String mimeType,
    int size,
    Map<String, dynamic> mediaMetaData,
    String fileExtension,
    String type,
    bool isDownloadable,
    String downloadLink,
    String filePath,
    dynamic thumbnailLink,
    DateTime modifiedDate,
    String parentId,
    DriveTypeEnum driveType,
  }) : super(
          driveId: driveId,
          fileId: fileId,
          name: name,
          mimeType: mimeType,
          size: size,
          mediaMetaData: mediaMetaData,
          fileExtension: fileExtension,
          type: type,
          isDownloadable: isDownloadable,
          downloadLink: downloadLink,
          filePath: filePath,
          thumbnailLink: thumbnailLink,
          modifiedDate: modifiedDate,
          parentId: parentId,
          driveType: driveType,
        );
  get dropboxThumbnail =>
      this.thumbnailLink == null ? null : base64.decode(this.thumbnailLink);

  get isMedia => Calcuation.isMedia(this.fileExtension);

  get mediaDuration {
    final String _durationStr = this.mediaMetaData != null && this.isMedia
        ? this.mediaMetaData["durationMillis"]
        : null;
    final int _videoDuration =
        _durationStr == null ? 0 : int.tryParse(_durationStr);
    return _videoDuration;
  }

  get isEmptyData => this.modifiedDate == DateTime(1970, 07, 01);

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
