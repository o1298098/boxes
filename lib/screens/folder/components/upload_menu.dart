import 'package:boxes/components/file_type_icon.dart';
import 'package:boxes/models/enums/upload_status.dart';
import 'package:boxes/models/file_upload.dart';
import 'package:boxes/responsive.dart';
import 'package:boxes/services/upload_service.dart';
import 'package:boxes/style/colors.dart';
import 'package:boxes/utils/calculation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class UploadMenu extends StatelessWidget {
  final Function closeMenu;
  final Function onUpload;
  final bool showPreview;

  const UploadMenu(
      {Key key, this.closeMenu, this.showPreview = false, this.onUpload})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _top = _mediaQuery.padding.top + 65;
    final _right = showPreview ? 300.0 : 0.0;
    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: GestureDetector(
          onTap: closeMenu,
          child: Container(
            color: Colors.transparent,
          ),
        )),
        _Menu(
          top: _top,
          right: _right,
          onUpload: onUpload,
        ),
      ],
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu({
    Key key,
    @required double top,
    @required double right,
    @required this.onUpload,
  })  : _top = top,
        _right = right,
        super(key: key);

  final double _top;
  final double _right;
  final Function onUpload;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _margin =
        Responsive.isDesktop(context) ? kDefaultPadding * 2.5 : kDefaultPadding;
    final _mediaQuery = MediaQuery.of(context);
    final _maxWidth = _mediaQuery.size.width > 400.0 + _margin * 2
        ? 400.0
        : _mediaQuery.size.width - 2 * _margin;
    return Positioned(
      top: _top,
      right: _right,
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: _margin),
          padding: EdgeInsets.all(kDefaultPadding),
          constraints: BoxConstraints(maxWidth: _maxWidth, maxHeight: 400),
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: BorderRadius.circular(kDefaultPadding * .5),
            boxShadow: [
              BoxShadow(
                  color: _theme.backgroundColor,
                  offset: Offset(-10, 10),
                  blurRadius: 25.0)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: kDefaultPadding),
              _UploadPanel(onTap: onUpload),
              SizedBox(height: kDefaultPadding * 1.2),
              Consumer<UploadService>(
                builder: (context, uploadService, _) => _UploadList(
                  queue: uploadService.queue,
                  onCancel: (d) => uploadService.delete(d.uploadId),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadList extends StatelessWidget {
  const _UploadList({
    Key key,
    this.queue,
    this.onCancel,
  }) : super(key: key);
  final ObservableList<FileUpload> queue;
  final Function(FileUpload) onCancel;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Expanded(
      child: Observer(
        builder: (_) => ListView.separated(
          itemBuilder: (_, index) {
            final _d = queue[index];
            return _UploadItem(
              d: _d,
              onCancel: onCancel,
            );
          },
          separatorBuilder: (_, index) => Divider(
            color: _theme.colorScheme.surface,
            height: kDefaultPadding * 1.2,
          ),
          itemCount: queue.length,
        ),
      ),
    );
  }
}

class _UploadItem extends StatelessWidget {
  const _UploadItem({
    Key key,
    @required FileUpload d,
    this.onCancel,
  })  : _d = d,
        super(key: key);

  final FileUpload _d;
  final Function(FileUpload) onCancel;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        child: Row(
          children: [
            FileTypeIcon(
              size: 12,
              type: _d.name.split('.').last,
            ),
            SizedBox(width: .5 * kDefaultPadding),
            SizedBox(
              width: 140,
              child: Text(
                _d.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: kGrayColor,
                ),
              ),
            ),
            SizedBox(width: kDefaultPadding),
            _ProgressBar(
              step: _d.stepIndex,
              total: _d.fileSize,
            ),
            SizedBox(width: kDefaultPadding * .5),
            _d.status == UploadStatus.finish
                ? Icon(
                    Icons.done_rounded,
                    size: 12,
                    color: kGrayColor,
                  )
                : InkWell(
                    onTap: () => onCancel(_d),
                    child: Icon(
                      Icons.close,
                      size: 12,
                      color: kGrayColor,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class _UploadPanel extends StatelessWidget {
  const _UploadPanel({
    Key key,
    this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          border: Border.all(color: _theme.colorScheme.surface),
          borderRadius: BorderRadius.circular(.5 * kDefaultPadding),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.cloud_upload,
              size: 16,
              color: _theme.primaryColor,
            ),
            SizedBox(width: kDefaultPadding * .5),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 12),
                children: [
                  TextSpan(
                      text: 'Drag and drop',
                      style: TextStyle(color: _theme.primaryColor)),
                  TextSpan(
                      text: ' or browse files',
                      style: TextStyle(
                        color: _theme.textTheme.bodyText1.color,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int step;
  final int total;
  const _ProgressBar({this.total = 1, this.step = 0});
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _fontSize = 8.0;
    final _barHeight = 4.0;
    final _radius = _barHeight / 2;
    final _p = (step / total).toDouble();
    return Expanded(
      child: Column(
        children: [
          Container(
            height: _barHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _theme.backgroundColor,
              borderRadius: BorderRadius.circular(_radius),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _p == 0 ? 0.001 : _p,
              child: Container(
                decoration: BoxDecoration(
                  color: _theme.primaryColor,
                  borderRadius: BorderRadius.circular(_radius),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${Calcuation.filesize(total)}',
                style: TextStyle(fontSize: _fontSize, color: kGrayColor),
              ),
              Spacer(),
              Text(
                '${(_p * 100).toStringAsFixed(0)} %',
                style: TextStyle(fontSize: _fontSize, color: kGrayColor),
              )
            ],
          ),
        ],
      ),
    );
  }
}
