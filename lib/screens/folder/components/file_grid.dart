import 'package:boxes/screens/folder/folder_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shimmer/shimmer.dart';

import 'file_item.dart';

class FileGrid extends StatelessWidget {
  const FileGrid({
    Key key,
    @required this.store,
  }) : super(key: key);

  final FolderStore store;

  @override
  Widget build(BuildContext context) {
    return store.loading
        ? _FileGridShimmer()
        : SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisExtent: 280,
              maxCrossAxisExtent: 260,
              mainAxisSpacing: kDefaultPadding,
              crossAxisSpacing: kDefaultPadding,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                final _d = store.files[index];
                return Observer(
                  builder: (_) => FileItem(
                    key: ValueKey(_d.fileId),
                    file: _d,
                    token: store.drive.accessToken,
                    onTap: store.fileTap,
                  ),
                );
              },
              childCount: store.files?.length ?? 0,
            ),
          );
  }
}

class _FileGridShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisExtent: 280,
        maxCrossAxisExtent: 260,
        mainAxisSpacing: kDefaultPadding,
        crossAxisSpacing: kDefaultPadding,
      ),
      delegate: SliverChildBuilderDelegate(
        (_, __) => Container(
          padding: EdgeInsets.all(kDefaultPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kBgLightColor,
          ),
          child: Shimmer.fromColors(
            baseColor: kBgDarkColor,
            highlightColor: kBgLightColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxHeight: 140),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kBgLightColor,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 14,
                  color: kBgDarkColor,
                ),
                Spacer(),
                Container(
                  width: 60,
                  height: 10,
                  color: kBgDarkColor,
                ),
                SizedBox(height: 8.0),
                Container(
                  width: 40,
                  height: 10,
                  color: kBgDarkColor,
                ),
              ],
            ),
          ),
        ),
        childCount: 6,
      ),
    );
  }
}
