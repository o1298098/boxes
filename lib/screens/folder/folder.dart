import 'package:boxes/components/custom_app_bar.dart';
import 'package:boxes/models/models.dart';
import 'package:boxes/screens/folder/components/file_preview.dart';
import 'package:boxes/screens/folder/components/folder_path.dart';
import 'package:boxes/screens/folder/folder_store.dart';
import 'package:boxes/screens/home/components/sliverappbar_delegate.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'components/file_grid.dart';
import 'components/file_list.dart';
import 'components/folder_grid.dart';
import 'components/grid_title.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({this.drive, this.onPop});
  final UserDrive drive;
  final Function onPop;
  @override
  _FolderScreenState createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _controller;
  FolderStore _store;
  AnimationController _previewController;
  @override
  void initState() {
    _previewController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _store = FolderStore(widget.drive)..previewShow = _showPreview;
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
    _previewController.dispose();
    super.dispose();
  }

  _showPreview() {
    _previewController.forward();
  }

  _closePreview() {
    _previewController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBgDarkColor,
      child: Stack(children: [
        Row(
          children: [
            Expanded(
              child: _Folder(
                controller: _controller,
                drive: widget.drive,
                onPop: widget.onPop,
                store: _store,
              ),
            ),
            AnimatedBuilder(
              animation: CurvedAnimation(
                  parent: _previewController,
                  curve: Curves.ease,
                  reverseCurve: Curves.ease),
              builder: (_, __) => SizedBox(
                width: 300 * _previewController.value,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: Tween(begin: Offset(1, 0), end: Offset.zero).animate(
              CurvedAnimation(
                  parent: _previewController,
                  curve: Curves.ease,
                  reverseCurve: Curves.ease),
            ),
            child: FilePreview(
              store: _store,
              onClose: _closePreview,
            ),
          ),
        ),
      ]),
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
    List<Widget> _buildGrid() {
      return [
        GridTitle(
          title: 'Folders',
          show: (store.folders?.length ?? 0) > 0 || store.loading,
        ),
        FolderGrid(store: store),
        GridTitle(
          title: 'Files',
          show: (store.files?.length ?? 0) > 0 || store.loading,
        ),
        FileGrid(
          store: store,
        )
      ];
    }

    return SafeArea(
      child: Scrollbar(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 2.5 * kDefaultPadding),
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
                    child: SizedBox(height: 1.5 * kDefaultPadding)),
                SliverToBoxAdapter(
                  child: FolderPath(
                    isList: store.displayAsList,
                    onPathTap: store.pathChanged,
                    pathItem: store.path,
                    onSwitchTap: store.layoutChange,
                  ),
                ),
              ]..addAll(store.displayAsList
                  ? [
                      SliverToBoxAdapter(
                          child: SizedBox(height: kDefaultPadding)),
                      FileList(store: store, drive: store.drive)
                    ]
                  : _buildGrid()),
            ),
          ),
        ),
      ),
    );
  }
}
