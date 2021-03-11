import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RightPanel extends StatelessWidget {
  const RightPanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFA0A8C0),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              'https://source.unsplash.com/daily',
            ),
          ),
        ),
        child: Container(
          color: const Color(0x30000000),
        ),
      ),
    );
  }
}
