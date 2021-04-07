import 'package:boxes/components/custom_app_bar.dart';
import 'package:boxes/components/overlay_entry_manage.dart';
import 'package:boxes/models/models.dart';
import 'package:boxes/responsive.dart';
import 'package:boxes/screens/folder/components/create_folder_dialog.dart';
import 'package:boxes/screens/folder/components/file_preview.dart';
import 'package:boxes/screens/folder/components/folder_path.dart';
import 'package:boxes/screens/folder/components/upload_menu.dart';
import 'package:boxes/screens/folder/folder_store.dart';
import 'package:boxes/components/sliverappbar_delegate.dart';
import 'package:boxes/services/upload_service.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

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

  final GlobalKey<OverlayEntryManageState> _overlayStateKey =
      GlobalKey<OverlayEntryManageState>();

  @override
  void initState() {
    _previewController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _store = FolderStore(widget.drive,
        uploadService: Provider.of<UploadService>(context, listen: false))
      ..previewShow = _showPreview;
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

  void _closeMenu(OverlayEntry overlayEntry) {
    overlayEntry?.remove();
    _overlayStateKey.currentState.setOverlayEntry(null);
    overlayEntry = null;
  }

  void _showUploadMenu() {
    OverlayEntry menuOverlayEntry;
    menuOverlayEntry = OverlayEntry(
        builder: (context) => UploadMenu(
              showPreview: _previewController.value == 1,
              closeMenu: () => _closeMenu(menuOverlayEntry),
              onUpload: () => _store.onUploadFile(),
            ));
    _overlayStateKey.currentState.setOverlayEntry(menuOverlayEntry);
    Overlay.of(context).insert(menuOverlayEntry);
  }

  void _createFolder() {
    showDialog(
      context: context,
      builder: (_) => CreateFolderDialog(store: _store),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      color: _theme.backgroundColor,
      child: Stack(children: [
        Row(
          children: [
            Expanded(
              child: OverlayEntryManage(
                key: _overlayStateKey,
                child: _Folder(
                  controller: _controller,
                  drive: widget.drive,
                  onPop: widget.onPop,
                  store: _store,
                  onAdd: _showUploadMenu,
                  createFolder: _createFolder,
                ),
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
  final Function onAdd;
  final Function createFolder;

  const _Folder({
    Key key,
    this.controller,
    this.drive,
    this.onPop,
    this.store,
    this.onAdd,
    this.createFolder,
  }) : super(key: key);

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
        FileGrid(store: store),
        SliverToBoxAdapter(child: SizedBox(height: kDefaultPadding)),
      ];
    }

    final double _padding =
        Responsive.isDesktop(context) ? kDefaultPadding * 2.5 : kDefaultPadding;

    return SafeArea(
      left: false,
      right: false,
      child: Scrollbar(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _padding),
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
                        _ActionButton(
                          icon: CupertinoIcons.folder_badge_plus,
                          onTap: createFolder,
                        ),
                        _ActionButton(
                          icon: CupertinoIcons.cloud_upload,
                          onTap: onAdd,
                        ),
                        _ActionButton(
                          icon: CupertinoIcons.search,
                          onTap: () {},
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
                      FileList(
                        store: store,
                        drive: store.drive,
                        list: store.foldersAndFiles,
                      )
                    ]
                  : _buildGrid()),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    Key key,
    @required this.onTap,
    this.icon,
  }) : super(key: key);

  final Function onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      width: 50.0,
      padding: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: _theme.colorScheme.primary,
          size: 18,
        ),
      ),
    );
  }
}
