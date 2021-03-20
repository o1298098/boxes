import 'dart:typed_data';

import 'package:boxes/models/enums/upload_status.dart';
import 'package:mobx/mobx.dart';

part 'file_upload_store.g.dart';

class FileUploadStore = _FileUploadStore with _$FileUploadStore;

abstract class _FileUploadStore with Store {
  final String uploadId;
  final int driveId;
  @observable
  String sessionId;
  final String name;
  final String filePath;

  @observable
  int stepIndex;
  final int fileSize;
  final DateTime uploadDate;

  @observable
  UploadStatus status;
  ByteBuffer data;
  int uploadSize;

  _FileUploadStore(
      {this.uploadId,
      this.driveId,
      this.sessionId,
      this.name,
      this.filePath,
      this.stepIndex,
      this.fileSize,
      this.uploadDate,
      this.status,
      this.data,
      this.uploadSize});
}
