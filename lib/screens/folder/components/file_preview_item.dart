import 'package:boxes/components/file_type_icon.dart';
import 'package:boxes/models/enums/dirve_type_enum.dart';
import 'package:boxes/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FilePreviewItem extends StatelessWidget {
  final DriveFile file;
  final String token;
  final bool fill;
  final double iconSize;
  const FilePreviewItem(
      {Key key, this.file, this.token, this.fill = true, this.iconSize = 65.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        return file.thumbnailLink != null
            ? (file.driveType == DriveTypeEnum.dropbox
                ? Image.memory(
                    file.dropboxThumbnail,
                    fit: BoxFit.cover,
                    width: c.maxWidth,
                    height: fill ? c.maxHeight : null,
                    alignment: Alignment.topCenter,
                    gaplessPlayback: true,
                  )
                : CachedNetworkImage(
                    imageUrl: file.thumbnailLink,
                    width: c.maxWidth,
                    height: fill ? c.maxHeight : null,
                    httpHeaders: {
                      "Authorization": "Bearer $token",
                    },
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    cacheKey: file.fileId,
                  ))
            : Container(
                constraints: BoxConstraints(maxHeight: 160),
                child: Center(
                  child: FileTypeIcon(
                    type: file.fileExtension,
                    size: iconSize,
                  ),
                ),
              );
      },
    );
  }
}
