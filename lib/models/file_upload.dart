import 'dart:typed_data';
import 'package:boxes/services/file_upload_store.dart';

import 'enums/upload_status.dart';

class FileUpload extends FileUploadStore {
  FileUpload(
      {String uploadId,
      int driveId,
      String sessionId,
      String name,
      String filePath,
      int stepIndex,
      int fileSize,
      DateTime uploadDate,
      UploadStatus status,
      ByteBuffer data,
      int uploadSize})
      : super(
          uploadId: uploadId,
          driveId: driveId,
          sessionId: sessionId,
          name: name,
          filePath: filePath,
          stepIndex: stepIndex,
          fileSize: fileSize,
          uploadDate: uploadDate,
          status: status,
          data: data,
          uploadSize: uploadSize,
        );

  factory FileUpload.fromJson(Map<String, dynamic> data) {
    return FileUpload(
      uploadId: data['uploadId'],
      driveId: data['driveId'],
      sessionId: data['sessionId'],
      name: data['name'],
      filePath: data['filePath'],
      stepIndex: data['stepIndex'],
      fileSize: data['fileSize'],
      uploadDate: DateTime.parse(data['uploadDate']),
      status: UploadStatus.values[data['status']],
    );
  }

  FileUpload copyWith({
    int driveId,
    String sessionId,
    String name,
    String filePath,
    int stepIndex,
    int fileSize,
    int uploadSize,
    DateTime uploadDate,
    UploadStatus status,
    ByteBuffer data,
  }) {
    return FileUpload(
      uploadId: uploadId ?? this.uploadId,
      driveId: driveId ?? this.driveId,
      sessionId: sessionId ?? this.sessionId,
      name: name ?? this.name,
      filePath: filePath ?? this.filePath,
      stepIndex: stepIndex ?? this.stepIndex,
      fileSize: fileSize ?? this.fileSize,
      uploadDate: uploadDate ?? this.uploadDate,
      status: status ?? this.status,
      data: data ?? this.data,
      uploadSize: uploadSize ?? this.uploadSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uploadId': uploadId,
      'driveId': driveId,
      'sessionId': sessionId,
      'name': name,
      'filePath': filePath,
      'stepIndex': stepIndex,
      'fileSize': fileSize,
      'uploadDate': uploadDate?.toIso8601String() ?? '1970-07-01',
      'status': status.index
    };
  }

  Uint8List get uploadContent {
    int _lenght = this.fileSize - this.stepIndex > uploadSize
        ? this.uploadSize
        : this.fileSize - this.stepIndex;
    return data.asUint8List(this.stepIndex, _lenght);
  }
}
