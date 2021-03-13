import 'package:boxes/models/drive_file.dart';
import 'package:boxes/style/colors.dart';
import 'package:boxes/utils/calculation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'file_preview_item.dart';

class FileItem extends StatefulWidget {
  final DriveFile file;
  final String token;
  final Function(DriveFile) onTap;
  const FileItem({Key key, this.file, this.token, this.onTap})
      : super(key: key);

  @override
  _FileItemState createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  DriveFile _file;

  @override
  void initState() {
    _file = widget.file;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FileItem oldWidget) {
    if (widget.file.fileId != _file.fileId)
      setState(() {
        _file = widget.file;
      });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final double _radius = 10.0;
    return GestureDetector(
      onTap: () => widget.onTap(_file),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: Container(
          color: kBgLightColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopPanel(file: _file, token: widget.token),
              Container(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                height: 60,
                child: Center(
                  child: Text(
                    widget.file.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                height: 2,
                color: Color(0xFF323239),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Filesize:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            Calcuation.filesize(_file.size ?? 0),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFC0C0C0),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TopPanel extends StatelessWidget {
  const _TopPanel({
    Key key,
    @required DriveFile file,
    @required this.token,
  })  : _file = file,
        super(key: key);

  final DriveFile _file;
  final String token;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 280, maxHeight: 150),
      child: Stack(
        children: [
          FilePreviewItem(
            file: _file,
            token: token,
          ),
          Container(
            height: double.infinity,
            padding: EdgeInsets.all(kDefaultPadding * .8),
            color: _file.thumbnailLink != null
                ? Color(0xFF000000).withOpacity(.2)
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  FontAwesomeIcons.star,
                  color: Color(0xFFFFFFFF),
                  size: 14,
                ),
                Icon(
                  Icons.more_vert_rounded,
                  color: Color(0xFFFFFFFF),
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
