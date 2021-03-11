import 'package:boxes/components/file_type_icon.dart';
import 'package:boxes/models/enums/dirve_type_enum.dart';
import 'package:boxes/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FilePreviewItem extends StatelessWidget {
  final DriveFile file;
  final String token;
  const FilePreviewItem({Key key, this.file, this.token}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        return file.thumbnailLink != null
            ? (file.driveType == DriveTypeEnum.dropbox
                ? Image.memory(
                    file.dropboxThumbnail,
                    fit: BoxFit.fitWidth,
                    width: c.maxWidth,
                    //height: c.maxHeight,
                    alignment: Alignment.topCenter,
                    gaplessPlayback: true,
                  )
                : CachedNetworkImage(
                    imageUrl: file.thumbnailLink,
                    width: c.maxWidth,
                    //height: c.maxHeight,
                    httpHeaders: {
                      "Authorization": "Bearer $token",
                    },
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    cacheKey: file.fileId,
                  ))
            : Container(
                constraints: BoxConstraints(maxHeight: 160),
                child: Center(
                  child: FileTypeIcon(
                    type: file.fileExtension,
                  ),
                ),
              );
      },
    );
  }
}
