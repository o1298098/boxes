import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFA0A8C0),
          image: DecorationImage(
            fit: BoxFit.cover,
            image:
                CachedNetworkImageProvider('https://source.unsplash.com/daily'),
          ),
        ),
        child: Container(
          color: const Color(0x30000000),
        ),
      ),
    );
  }
}
