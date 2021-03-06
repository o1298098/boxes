import 'package:boxes/models/models.dart';
import 'package:boxes/screens/folder/folder_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:shimmer/shimmer.dart';

import 'file_preview_item.dart';

class FileList extends StatelessWidget {
  final FolderStore store;
  final UserDrive drive;
  final ObservableList<DriveFile> list;

  const FileList({Key key, this.store, this.drive, @required this.list})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => store.loading
          ? _FileListShimmer()
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  final _d = list[index];
                  final _isFolder = _d.type == 'folder';
                  return _FileListItem(
                    file: _d,
                    store: store,
                    isFolder: _isFolder,
                    token: drive.accessToken,
                    onTap: (file) async => _isFolder
                        ? await store.loadFolder(file)
                        : await store.fileTap(file),
                  );
                },
                childCount: list.length,
              ),
            ),
    );
  }
}

class _FileListItem extends StatelessWidget {
  final bool isFolder;
  final Function(DriveFile) onTap;
  final DriveFile file;
  final FolderStore store;
  final String token;

  const _FileListItem(
      {Key key, this.isFolder, this.onTap, this.file, this.store, this.token})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return InkWell(
      onTap: () async => await onTap(file),
      child: Observer(
        builder: (_) => Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          padding: const EdgeInsets.all(kDefaultPadding * .8),
          decoration: BoxDecoration(
            color: store.selectedFile == file
                ? _theme.colorScheme.surface
                : _theme.cardColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              isFolder
                  ? Icon(
                      FontAwesomeIcons.solidFolder,
                      color: _theme.colorScheme.primary,
                    )
                  : SizedBox(
                      width: 30,
                      height: 30,
                      child: FilePreviewItem(
                        file: file,
                        iconSize: 20,
                        token: token,
                      )),
              SizedBox(width: kDefaultPadding * .8),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Text(
                    file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: _theme.colorScheme.primary, fontSize: 12),
                  ),
                ),
              ),
              Text(
                isFolder
                    ? '${store.fileCount(file.fileId)} files'
                    : DateFormat.yMMMd().format(file.modifiedDate).toString(),
                style:
                    TextStyle(color: _theme.colorScheme.primary, fontSize: 12),
              ),
              SizedBox(width: kDefaultPadding),
              Icon(
                FontAwesomeIcons.star,
                color: _theme.colorScheme.primary,
                size: 14,
              ),
              SizedBox(width: kDefaultPadding * .5),
              Icon(
                Icons.more_vert_rounded,
                color: _theme.colorScheme.primary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FileListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (_, index) => _ShimmerItem(),
      childCount: 6,
    ));
  }
}

class _ShimmerItem extends StatelessWidget {
  const _ShimmerItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(kDefaultPadding * .8),
      decoration: BoxDecoration(
        color: _theme.cardColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Shimmer.fromColors(
        baseColor: _theme.backgroundColor,
        highlightColor: _theme.cardColor,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: _theme.backgroundColor,
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: 30,
              height: 30,
            ),
            SizedBox(width: kDefaultPadding * .8),
            Container(
              color: _theme.backgroundColor,
              width: 300,
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
