import 'dart:async';

import 'package:boxes/components/loading_layout.dart';
import 'package:boxes/models/models.dart';
import 'package:boxes/responsive.dart';
import 'package:boxes/screens/file_soucre/file_source_store.dart';
import 'package:boxes/screens/home/components/sliverappbar_delegate.dart';
import 'package:boxes/settings/settings_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:boxes/utils/api/base_api.dart';
import 'package:boxes/utils/api/drive/dropbox_api.dart';
import 'package:boxes/utils/api/drive/google_drive_api.dart';
import 'package:boxes/utils/api/graphql/graphql_client.dart';
import 'package:boxes/utils/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Detail extends StatefulWidget {
  final FileSourceStore store;
  final SettingsStore settingsStore;

  const Detail({Key key, this.store, this.settingsStore}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  String _serviceType = 'Dropbox';
  bool _showAccountInput = false;
  bool _isLoading = false;
  TextEditingController _nameTextEditingController;
  TextEditingController _hostTextEditingController;
  TextEditingController _accountTextEditingController;
  TextEditingController _passwordTextEditingController;
  Toast _toast;
  StreamSubscription<QueryResult> _stream;
  @override
  void initState() {
    _nameTextEditingController = TextEditingController(text: _serviceType);
    _hostTextEditingController = TextEditingController();
    _accountTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
    _toast = Toast()..init(context);
    _driveSubscription();
    super.initState();
  }

  @override
  dispose() {
    _nameTextEditingController.dispose();
    _hostTextEditingController.dispose();
    _accountTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _stream?.cancel();
    super.dispose();
  }

  _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future _onAdd() async {
    _setLoading(true);
    switch (_serviceType) {
      case 'Dropbox':
        await _addDropbox();
        break;
      case 'Google Drive':
        await _addGoogleDrive();
        break;
      case 'One Drive':
        await _addOneDrive();
        break;
      case 'FTP':
        await _addFtp();
        break;
    }
  }

  void _driveSubscription() {
    if (widget.settingsStore.appUser == null) return;
    _stream = BaseGraphQLClient.instance
        .driveAddedSubscription(widget.settingsStore.appUser.uid)
        .listen((d) {
      final _d = d.data["driveAdded"];
      if (_d != null) {
        UserDrive _drive = UserDrive.fromJson(_d);
        final _drives = widget.settingsStore.appUser.userDrives;
        final _checkDrive =
            _drives.firstWhere((e) => e.id == _drive.id, orElse: () => null);
        if (_checkDrive != null) {
          _drives.remove(_checkDrive);
        }
        _drives.insert(0, _drive);
        final _user = widget.settingsStore.appUser.copyWith();
        widget.settingsStore.setAppUser(value: _user);

        _setLoading(false);
      }
    });
  }

  Future _addDropbox() async {
    if (widget.settingsStore.appUser == null) return;
    await DropboxApi.instance.addDropbox(widget.settingsStore.appUser.uid,
        Uri.encodeComponent(_nameTextEditingController.text));
  }

  Future _addGoogleDrive() async {
    if (widget.settingsStore.appUser == null) return;
    await GoogleDriveApi.instance.addGoogleDrive(
        widget.settingsStore.appUser.uid, Uri.encodeComponent(_serviceType));
  }

  Future _addOneDrive() async {}

  Future _addFtp() async {}

  Future _saveDrive() async {
    final _drive = widget.store.selectDrive;
    final _name = _nameTextEditingController.text;
    if (_drive == null) return;
    _setLoading(true);
    final _newDrive = _drive.copyWith(name: _name);
    final _result = await BaseApi.instance.updateUserDrive(_newDrive);
    if (_result.success) {
      final _drives = widget.settingsStore.appUser.userDrives;
      final _checkDrive =
          _drives.firstWhere((e) => e.id == _drive.id, orElse: () => null);
      if (_checkDrive != null) {
        _drives.remove(_checkDrive);
      }
      _drives.insert(0, _newDrive);
      final _user = widget.settingsStore.appUser.copyWith();
      widget.settingsStore.setAppUser(value: _user);
      widget.store.setDrive(null);
    } else
      _toast.showToast(_result.message);
    _setLoading(false);
  }

  Future _deleteDrive() async {
    final _drive = widget.store.selectDrive;
    if (_drive == null) return;
    _setLoading(true);
    await BaseApi.instance.deleteUserDrive(_drive.id);
    final _user = widget.settingsStore.appUser.copyWith();
    _user.userDrives.remove(_drive);
    widget.settingsStore.setAppUser(value: _user);
    widget.store.setDrive(null);
    _setLoading(false);
  }

  _onServieTypeSelected(Item item) {
    if (item.name == _serviceType) return;
    setState(() {
      _serviceType = item.name;
      _showAccountInput = item.value;
    });
    _nameTextEditingController.text = _serviceType;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Stack(
        children: [
          widget.store.selected
              ? Container(
                  height: double.infinity,
                  color: Color(0xFFE0E0E0),
                  child: Column(
                    children: [
                      _CustomAppBar(),
                      SizedBox(height: 40),
                      _BaseInfo(
                        isEdit: widget.store.isEdit,
                        serviceType: widget.store.isEdit
                            ? widget.store.selectDrive.driveType.name
                            : _serviceType,
                        showAccontInput: _showAccountInput,
                        onServiceSelected: _onServieTypeSelected,
                        nameTextEditingController: _nameTextEditingController
                          ..text = widget.store.isEdit
                              ? widget.store.selectDrive.name
                              : _serviceType,
                        hostTextEditingController: _hostTextEditingController,
                        accountTextEditingController:
                            _accountTextEditingController,
                        passwordTextEditingController:
                            _passwordTextEditingController,
                      ),
                      SizedBox(height: kDefaultPadding),
                      _OperationGroup(
                        isEdit: widget.store.selectDrive != null,
                        addTap: () async => await _onAdd(),
                        saveTap: () async => await _saveDrive(),
                        deleteTap: () async => await _deleteDrive(),
                      ),
                    ],
                  ),
                )
              : Container(color: Color(0xFFE0E0E0)),
          LoadingLayout(
            title: 'Loading',
            show: _isLoading,
          )
        ],
      ),
    );
  }
}

class _OperationGroup extends StatelessWidget {
  final Function addTap;
  final Function deleteTap;
  final Function saveTap;
  final bool isEdit;

  const _OperationGroup({
    Key key,
    this.addTap,
    this.deleteTap,
    this.isEdit = false,
    this.saveTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border(
            top: BorderSide(
              color: kLineColor.withAlpha(20),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: kLineColor.withAlpha(20),
              width: 1.0,
            ),
          )),
      padding: EdgeInsets.only(left: .5 * kDefaultPadding),
      child: Column(
        children: [
          _ButtonCell(
            title: 'Add',
            textColor: kPrimaryColor,
            onTap: addTap,
            display: !isEdit,
          ),
          Divider(height: 1.0),
          _ButtonCell(
            title: 'Save',
            textColor: kPrimaryColor,
            display: isEdit,
            onTap: saveTap,
          ),
          Divider(height: 1.0),
          _ButtonCell(
            title: 'Remove',
            textColor: Color(0xFFFF0000),
            onTap: deleteTap,
            display: isEdit,
          ),
        ],
      ),
    );
  }
}

class _BaseInfo extends StatelessWidget {
  const _BaseInfo({
    Key key,
    this.showAccontInput = false,
    this.serviceType,
    this.nameTextEditingController,
    this.hostTextEditingController,
    this.accountTextEditingController,
    this.passwordTextEditingController,
    this.onServiceSelected,
    this.isEdit = false,
  }) : super(key: key);
  final bool showAccontInput;
  final String serviceType;
  final TextEditingController nameTextEditingController;
  final TextEditingController hostTextEditingController;
  final TextEditingController accountTextEditingController;
  final TextEditingController passwordTextEditingController;
  final Function(Item) onServiceSelected;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border(
            top: BorderSide(
              color: kLineColor.withAlpha(20),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: kLineColor.withAlpha(20),
              width: 1.0,
            ),
          )),
      padding: EdgeInsets.only(left: .5 * kDefaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _InputCell(
            title: 'Name',
            hintText: 'Name',
            controller: nameTextEditingController,
          ),
          Divider(height: 1),
          _OptionCell(
            title: 'Service type',
            hintText: serviceType,
            enable: !isEdit,
            onTap: () async {
              await Navigator.of(context, rootNavigator: false).push(
                PageRouteBuilder(
                  opaque: false,
                  barrierColor: Colors.transparent,
                  pageBuilder: (_, animation, __) {
                    return LayoutBuilder(
                      builder: (_, c) {
                        double _width = Responsive.isMobile(context)
                            ? c.maxWidth
                            : c.maxWidth - 300;
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1.0, 0),
                            end: Offset((c.maxWidth - _width) / c.maxWidth, 0),
                          ).animate(
                            (CurvedAnimation(
                                parent: animation, curve: Curves.ease)),
                          ),
                          child: _DriveTypeList(onTap: onServiceSelected),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
          _InputCell(
            title: 'Host',
            hintText: 'yourhost.com',
            display: showAccontInput,
            controller: hostTextEditingController,
          ),
          _InputCell(
            title: 'Account',
            hintText: 'account',
            display: showAccontInput,
            controller: accountTextEditingController,
          ),
          _InputCell(
            title: 'Password',
            hintText: 'password',
            display: showAccontInput,
            controller: passwordTextEditingController,
          ),
        ],
      ),
    );
  }
}

class _InputCell extends StatelessWidget {
  const _InputCell({
    Key key,
    @required this.title,
    this.controller,
    this.focusNode,
    this.cursorColor,
    this.hintText,
    this.display = true,
  }) : super(key: key);

  final String title;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color cursorColor;
  final bool display;

  @override
  Widget build(BuildContext context) {
    return display
        ? Container(
            padding: EdgeInsets.symmetric(vertical: .5 * kDefaultPadding),
            child: Row(
              children: [
                SizedBox(width: 120, child: Text(title)),
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    enableSuggestions: false,
                    scrollPadding: EdgeInsets.zero,
                    cursorColor: cursorColor,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                )
              ],
            ),
          )
        : SizedBox();
  }
}

class _OptionCell extends StatelessWidget {
  const _OptionCell({
    Key key,
    @required this.title,
    this.hintText,
    this.onTap,
    this.enable = true,
  }) : super(key: key);

  final String title;
  final String hintText;
  final Function onTap;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enable ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: .5 * kDefaultPadding),
        child: Row(
          children: [
            SizedBox(width: 120, child: Text(title)),
            Expanded(child: Text(hintText)),
            Icon(Icons.chevron_right_rounded, size: 16.0),
            SizedBox(width: kDefaultPadding)
          ],
        ),
      ),
    );
  }
}

class _ButtonCell extends StatelessWidget {
  const _ButtonCell({
    Key key,
    @required this.title,
    this.onTap,
    this.textColor,
    this.display = true,
  }) : super(key: key);

  final String title;
  final Color textColor;
  final Function onTap;
  final bool display;

  @override
  Widget build(BuildContext context) {
    return display
        ? InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: .5 * kDefaultPadding),
              child: Text(
                title,
                style: TextStyle(color: textColor, fontSize: 14),
              ),
            ),
          )
        : SizedBox();
  }
}

class _DriveTypeList extends StatelessWidget {
  final Function(Item) onTap;

  const _DriveTypeList({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _listData = [
      {'id': 1, 'name': 'Google Drive', 'needAccount': false},
      {'id': 2, 'name': 'Dropbox', 'needAccount': false},
      {'id': 3, 'name': 'One Drive', 'needAccount': false},
      {'id': 4, 'name': 'FTP', 'needAccount': true},
      {'id': 5, 'name': 'SFTP', 'needAccount': true},
      {'id': 6, 'name': 'SMB', 'needAccount': true},
      {'id': 7, 'name': 'NFS', 'needAccount': true},
    ];
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              minHeight: 60,
              maxHeight: 60,
              child: _CustomAppBar(
                showCloseButton: true,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 2 * kDefaultPadding)),
          SliverList(
              delegate: SliverChildBuilderDelegate((_, index) {
            final _d = _listData[index];
            return InkWell(
              onTap: () {
                onTap(Item(
                  name: _d['name'],
                  value: _d['needAccount'],
                ));
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: .5 * kDefaultPadding,
                  top: .5 * kDefaultPadding,
                ),
                color: Color(0xFFFFFFFF),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_d['name']),
                    SizedBox(height: .5 * kDefaultPadding),
                    Divider(height: 1),
                  ],
                ),
              ),
            );
          }, childCount: _listData.length)),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({
    Key key,
    this.showCloseButton = false,
    this.title,
  }) : super(key: key);

  final bool showCloseButton;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: EdgeInsets.all(kDefaultPadding),
      color: Colors.white,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              title ?? '',
              style: TextStyle(fontSize: 14),
            ),
          ),
          showCloseButton
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close,
                        size: 14,
                      )),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
