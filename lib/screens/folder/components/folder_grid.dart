import 'package:boxes/screens/folder/folder_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'folder_item.dart';

class FolderGrid extends StatelessWidget {
  const FolderGrid({
    Key key,
    @required this.store,
  }) : super(key: key);

  final FolderStore store;

  @override
  Widget build(BuildContext context) {
    return store.loading
        ? _FolderGridShimmer()
        : SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisExtent: 120,
              maxCrossAxisExtent: 260,
              mainAxisSpacing: kDefaultPadding,
              crossAxisSpacing: kDefaultPadding,
            ),
            delegate: SliverChildBuilderDelegate((_, index) {
              final _d = store.folders[index];
              return FolderItem(
                file: _d,
                count: store.fileCount(_d.fileId),
                token: store.drive.accessToken,
                onTap: (d) async => await store.loadFolder(d),
              );
            }, childCount: store.folders?.length ?? 0),
          );
  }
}

class _FolderGridShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisExtent: 120,
        maxCrossAxisExtent: 260,
        mainAxisSpacing: kDefaultPadding,
        crossAxisSpacing: kDefaultPadding,
      ),
      delegate: SliverChildBuilderDelegate(
          (_, index) => Container(
                padding: EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kBgLightColor,
                ),
                child: Shimmer.fromColors(
                  baseColor: kBgDarkColor,
                  highlightColor: kBgLightColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        FontAwesomeIcons.solidFolder,
                        color: kBgDarkColor,
                      ),
                      Spacer(),
                      Container(
                        color: kBgDarkColor,
                        width: 100,
                        height: 12,
                      ),
                      SizedBox(height: 6),
                      Container(
                        color: kBgDarkColor,
                        width: 40,
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
          childCount: 6),
    );
  }
}
