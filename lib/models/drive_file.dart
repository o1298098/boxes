class DriveFile {
  DriveFile({
    this.fileId,
    this.name,
    this.fileExtension,
    this.filePath,
    this.isDownloadable,
    this.mediaMetaData,
    this.mimeType,
    this.size,
    this.type,
    this.modifiedDate,
    this.children,
  });
  final String fileId;
  final String name;
  final String mimeType;
  final int size;
  final Map<String, dynamic> mediaMetaData;
  final String fileExtension;
  final String type;
  final bool isDownloadable;
  final String filePath;
  final DateTime modifiedDate;
  List<DriveFile> children;
}
