import 'package:boxes/components/custom_video_player.dart';
import 'package:boxes/screens/folder/folder_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:boxes/utils/calculation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'file_preview_item.dart';

class FilePreview extends StatelessWidget {
  final FolderStore store;

  const FilePreview({Key key, this.store}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kMenuBackgroundColor,
      width: 300,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Observer(
            builder: (_) => store.selectedFile != null
                ? SizedBox(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.fileAlt,
                                color: kIconColor,
                                size: 12,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'File Preview',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: kDefaultPadding * .8),
                          Divider(
                            color: kLineColor,
                            thickness: 1.5,
                          ),
                          SizedBox(height: kDefaultPadding * .8),
                          Container(
                            width: 260,
                            //constraints: BoxConstraints(maxHeight: 300),
                            child: FilePreviewItem(
                              file: store.selectedFile,
                              token: store.drive.accessToken,
                            ),
                          ),
                          SizedBox(height: kDefaultPadding * .8),
                          Divider(
                            color: kLineColor,
                            thickness: 1.5,
                          ),
                          SizedBox(height: kDefaultPadding * .5),
                          Text(
                            store.selectedFile?.name ?? '',
                            style: TextStyle(
                              color: const Color(0xFFFFFFFF),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '''${Calcuation.filesize(store.selectedFile.size)}    ${store.selectedFile.mediaDuration > 0 ? Calcuation.formatDuration(Duration(milliseconds: store.selectedFile.mediaDuration)) : ""}''',
                            style: TextStyle(
                              fontSize: 10,
                              color: kGrayColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: double.infinity,
                  ),
          ),
        ),
      ),
    );
  }
}
