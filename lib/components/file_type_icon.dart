import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';

class FileTypeIcon extends StatelessWidget {
  const FileTypeIcon({Key key, this.type}) : super(key: key);
  final String type;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kIconColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
          boxShadow: [
            BoxShadow(
              color: kBgDarkColor,
              offset: Offset.zero,
              blurRadius: 15,
            )
          ]),
      width: 65,
      height: 80,
      child: Center(
        child: Text(
          type ?? '',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: kBgDarkColor,
          ),
        ),
      ),
    );
  }
}
