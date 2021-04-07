import 'package:boxes/components/custom_video_player.dart';
import 'package:boxes/screens/folder/folder_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:boxes/utils/calculation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

import 'file_preview_item.dart';

class FilePreview extends StatelessWidget {
  final FolderStore store;
  final Function onClose;

  const FilePreview({Key key, this.store, this.onClose}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      color: _theme.cardColor,
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
                                color: _theme.colorScheme.primary,
                                size: 12,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'File Preview',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: onClose,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: _theme.colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: _theme.colorScheme.surface,
                            thickness: 1.5,
                          ),
                          SizedBox(height: kDefaultPadding * .8),
                          Container(
                            width: 260,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                FilePreviewItem(
                                  file: store.selectedFile,
                                  token: store.drive.accessToken,
                                  fill: false,
                                ),
                                _VideoPlayer(store: store)
                              ],
                            ),
                          ),
                          SizedBox(height: kDefaultPadding * .8),
                          Divider(
                            color: _theme.colorScheme.surface,
                            thickness: 1.5,
                          ),
                          SizedBox(height: kDefaultPadding * .5),
                          Text(
                            store.selectedFile?.name ?? '',
                            style: TextStyle(
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

class _VideoPlayer extends StatelessWidget {
  final FolderStore store;

  const _VideoPlayer({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _onTap() async {
      await Navigator.of(context, rootNavigator: false).push(
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.transparent,
          pageBuilder: (_, animation, __) {
            return LayoutBuilder(
              builder: (_, c) {
                return Scaffold(
                  appBar: AppBar(),
                  body: AppVideoPlayer(
                    controller: VideoPlayerController.network(
                      store.selectedFile.downloadLink,
                      httpHeaders: {
                        "Authorization": "Bearer ${store.drive.accessToken}}",
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }

    return store.selectedFile.downloadLink != null && store.selectedFile.isMedia
        ? PlayArrow(
            onTap: () async => _onTap(),
          )
        : SizedBox();
  }
}
