import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String link;

  const CustomVideoPlayer({Key key, this.link}) : super(key: key);
  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController _controller;
  bool isLoading = true;
  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.link);
    _controller.initialize().whenComplete(() {
      setState(() {
        isLoading = false;
      });
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
    return LayoutBuilder(
      builder: (context, c) {
        return Container(
            width: c.maxWidth,
            height: c.maxHeight,
            color: Colors.black,
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  )
                : VideoPlayer(_controller));
      },
    );
  }
}
