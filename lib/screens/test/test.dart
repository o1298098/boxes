import 'package:boxes/models/enums/upload_status.dart';
import 'package:boxes/models/file_upload.dart';
import 'package:boxes/services/upload_service.dart';
import 'package:boxes/style/colors.dart';
import 'package:boxes/utils/calculation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBgDarkColor,
      child: SafeArea(
          child: Consumer<UploadService>(
        builder: (_, service, __) => SizedBox(
          child: Observer(
            builder: (context) => ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              itemBuilder: (_, index) {
                return _UploadItem(
                  d: service.queue[index],
                  onStop: (d) => service.stop(d.uploadId),
                  onStart: (d) => service.start(d.uploadId),
                  onDelete: (d) => service.delete(d.uploadId),
                );
              },
              separatorBuilder: (_, index) => SizedBox(),
              itemCount: service.queue.length,
            ),
          ),
        ),
      )),
    );
  }
}

class _UploadItem extends StatelessWidget {
  const _UploadItem({
    Key key,
    @required FileUpload d,
    this.onStop,
    this.onStart,
    this.onDelete,
  })  : _d = d,
        super(key: key);

  final FileUpload _d;
  final Function(FileUpload file) onStop;
  final Function(FileUpload file) onStart;
  final Function(FileUpload file) onDelete;

  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(color: const Color(0xFFFFFFFF));
    return Observer(
      builder: (context) => Container(
        width: 1100,
        child: Row(
          children: [
            Text(_d.name, style: _style),
            Spacer(),
            Text(Calcuation.filesize(_d.fileSize), style: _style),
            SizedBox(width: 20),
            Text(
              '${((_d.stepIndex / _d.fileSize) * 100).toStringAsFixed(0)} %',
              style: _style,
            ),
            IconButton(
              icon: Icon(
                _d.status == UploadStatus.uploading
                    ? Icons.stop_circle_outlined
                    : Icons.play_circle_outline_rounded,
                color: Color(0xFFFFFFFF),
              ),
              onPressed: () => onStop(_d),
            ),
            IconButton(
              icon: Icon(
                Icons.thumb_up,
                color: Color(0xFFFFFFFF),
              ),
              onPressed: () => onStart(_d),
            ),
            SizedBox(width: 20),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Color(0xFFFF0000),
              ),
              onPressed: () => onDelete(_d),
            )
          ],
        ),
      ),
    );
  }
}
