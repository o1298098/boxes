class Calcuation {
  static String filesize(int size) {
    if (size < 1024)
      return '$size bytes';
    else if (size >= 1024 && size < 1048576)
      return '${(size / 1024).toStringAsFixed(1)} KB';
    else if (size >= 1048576 && size < 1073741824)
      return '${(size / 1048576).toStringAsFixed(1)} MB';
    else if (size >= 1073741824)
      return '${(size / 1073741824).toStringAsFixed(1)} GB';
    return '$size';
  }

  static final _mediaType = ['mp4', 'mkv', 'mov', 'webm', 'mp3', 'flac'];

  static bool isMedia(String fileExtension) {
    return _mediaType.contains(fileExtension);
  }

  static String formatDuration(Duration d) {
    return d.toString().split('.').first.padLeft(8, "0");
  }
}
