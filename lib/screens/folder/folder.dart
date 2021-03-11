import 'package:boxes/components/custom_app_bar.dart';
import 'package:boxes/models/models.dart';
import 'package:boxes/screens/folder/components/file_item.dart';
import 'package:boxes/screens/folder/components/file_preview.dart';
import 'package:boxes/screens/folder/components/folder_item.dart';
import 'package:boxes/screens/folder/components/folder_path.dart';
import 'package:boxes/screens/folder/folder_store.dart';
import 'package:boxes/screens/home/components/sliverappbar_delegate.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({this.drive, this.onPop});
  final UserDrive drive;
  final Function onPop;
  @override
  _FolderScreenState createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  ScrollController _controller;
  FolderStore _store;
  @override
  void initState() {
    _store = FolderStore(widget.drive);
    _controller = ScrollController()
      ..addListener(() {
        bool _isBottom =
            _controller.position.pixels == _controller.position.maxScrollExtent;
        if (_isBottom) _store.loadMoreFiles();
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBgDarkColor,
      child: Row(
        children: [
          Expanded(
            child: _Folder(
              controller: _controller,
              drive: widget.drive,
              onPop: widget.onPop,
              store: _store,
            ),
          ),
          FilePreview(store: _store),
        ],
      ),
    );
  }
}

class _Folder extends StatelessWidget {
  final ScrollController controller;
  final UserDrive drive;
  final Function onPop;
  final FolderStore store;

  const _Folder({Key key, this.controller, this.drive, this.onPop, this.store})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.5 * kDefaultPadding),
        child: Observer(
          builder: (_) => CustomScrollView(
            controller: controller,
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                  maxHeight: 60,
                  minHeight: 60,
                  child: CustomAppBar(
                    title: drive.driveType.name,
                    needBackButton: true,
                    backButtonTap: onPop,
                    actions: [
                      Icon(
                        CupertinoIcons.add_circled,
                        color: kIconColor,
                        size: 18,
                      ),
                      SizedBox(width: kDefaultPadding),
                      Icon(
                        CupertinoIcons.search,
                        color: kIconColor,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 1.5 * kDefaultPadding,
                ),
              ),
              SliverToBoxAdapter(
                child: FolderPath(
                  pathItem: store.path,
                  onTap: (d) => store.pathChanged(d),
                ),
              ),
              SliverToBoxAdapter(
                child: (store.folders?.length ?? 0) > 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding),
                        child: const Text(
                          'Folders',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
              store.loading
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 120.0),
                        child: Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Color(0xFFFFFFFF)),
                            ),
                          ),
                        ),
                      ),
                    )
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
                          token: drive.accessToken,
                          onTap: (d) async => await store.loadFolder(d),
                        );
                      }, childCount: store.folders?.length ?? 0),
                    ),
              SliverToBoxAdapter(
                child: (store.files?.length ?? 0) > 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding),
                        child: const Text(
                          'Files',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: 280,
                  maxCrossAxisExtent: 260,
                  mainAxisSpacing: kDefaultPadding,
                  crossAxisSpacing: kDefaultPadding,
                ),
                delegate: SliverChildBuilderDelegate((_, index) {
                  final _d = store.files[index];
                  return FileItem(
                    key: ValueKey(_d.fileId),
                    file: _d,
                    token: drive.accessToken,
                    onTap: store.fileTap,
                  );
                }, childCount: store.files?.length ?? 0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
