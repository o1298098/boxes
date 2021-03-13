import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String streamLink;
  final ImageProvider background;
  final String playerType;
  final bool streamInBrowser;
  final bool useVideoSourceApi;
  final bool needAd;
  final bool loading;
  final bool autoPlay;
  final int linkId;
  final bool showControls;
  final Function onPlay;
  final Function onFinsh;
  const CustomVideoPlayer({
    Key key,
    this.streamLink,
    this.playerType,
    this.background,
    this.linkId,
    this.loading = false,
    this.useVideoSourceApi = true,
    this.streamInBrowser = false,
    this.needAd = false,
    this.autoPlay = false,
    this.onPlay,
    this.onFinsh,
    this.showControls = true,
  })  : assert(streamLink != null),
        super(key: key);
  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer>
    with AutomaticKeepAliveClientMixin {
  bool _play = false;
  bool _needAd = false;
  bool _loading = false;
  bool _haveOpenAds = false;
  String _playerType;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    _needAd = widget.needAd;
    _loading = widget.loading;
    _playerType = widget.playerType;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomVideoPlayer oldWidget) {
    if (oldWidget.streamLink != widget.streamLink ||
        oldWidget.playerType != widget.playerType ||
        oldWidget.linkId != widget.linkId ||
        oldWidget.background != widget.background) {
      setState(() {
        _play = false;
      });
    }
    if (_needAd != widget.needAd && !_haveOpenAds) _setNeedAd(widget.needAd);
    if (_loading != widget.loading) _setLoading(widget.loading);
    if (_playerType != widget.playerType) _setPlayerType(widget.playerType);
    super.didUpdateWidget(oldWidget);
  }

  _playTapped(BuildContext context) async {
    if (widget.loading) return;

    await _startPlayer();
  }

  _startPlayer() async {
    setState(() {
      _play = true;
    });
    if (widget.onPlay != null) widget.onPlay();
  }

  _setLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }

  _setPlayerType(String type) {
    setState(() {
      _playerType = type;
    });
  }

  _setNeedAd(bool needAd) {
    _needAd = needAd;
  }

  _onFinsh() {
    setState(() {
      _play = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _play
        ? AppVideoPlayer(
            onFinsh: _onFinsh,
            showControls: widget.showControls,
            controller: VideoPlayerController.network(widget.streamLink))
        : GestureDetector(
            onTap: () => _playTapped(context),
            child: _Background(
              image: widget.background,
              loading: _loading,
            ),
          );
  }
}

class AppVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final Function onFinsh;
  final bool showControls;
  const AppVideoPlayer(
      {this.controller, this.onFinsh, this.showControls = true});
  @override
  _AppVideoPlayerState createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  ChewieController _chewieController;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    widget.controller.initialize().then((value) {
      _chewieController = ChewieController(
        videoPlayerController: widget.controller,
        showControls: widget.showControls,
        customControls: CupertinoControls(
          backgroundColor: Colors.black,
          iconColor: Colors.white,
        ),
        allowedScreenSleep: false,
        autoPlay: true,
        aspectRatio: widget.controller.value.aspectRatio,
      );
      widget.controller.addListener(_onFinsh);
      setState(() {});
    });
  }

  _onFinsh() {
    if (widget.controller.value.position == widget.controller.value.duration) {
      widget?.onFinsh();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onFinsh);
    widget.controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _chewieController == null
          ? Center(
              child: Container(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    const Color(0xFFFFFFFF),
                  ),
                ),
              ),
            )
          : Chewie(controller: _chewieController),
    );
  }
}

class _Background extends StatelessWidget {
  final ImageProvider image;
  final bool loading;
  const _Background({@required this.image, this.loading});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: const Color(0xFFAABBEE),
        image: image != null
            ? DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                image: image,
              )
            : null,
      ),
      child: loading
          ? Center(
              child: Container(
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(const Color(0xFFFFFFFF)),
                ),
              ),
            )
          : PlayArrow(),
    );
  }
}

class PlayArrow extends StatelessWidget {
  final Function onTap;
  const PlayArrow({this.onTap});
  @override
  Widget build(BuildContext context) {
    final _brightness = MediaQuery.of(context).platformBrightness;
    return Center(
        child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: _brightness == Brightness.light
                ? const Color(0x40FFFFFF)
                : const Color(0x40000000),
            width: 60,
            height: 60,
            child: Icon(
              Icons.play_arrow,
              size: 25,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    ));
  }
}
