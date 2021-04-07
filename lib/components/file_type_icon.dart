import 'package:flutter/material.dart';

class FileTypeIcon extends StatelessWidget {
  const FileTypeIcon({Key key, this.type, this.size = 65}) : super(key: key);
  final String type;
  final double size;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _height = size * 1.25;
    final _radius = size * 0.125;
    final _toprightRadius = size * 0.3;
    final _fontSize = size * 0.3;
    return Container(
      decoration: BoxDecoration(
          color: _isDark ? _theme.colorScheme.surface : _theme.cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_radius),
            topRight: Radius.circular(_toprightRadius),
            bottomLeft: Radius.circular(_radius),
            bottomRight: Radius.circular(_radius),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  _isDark ? _theme.backgroundColor : _theme.colorScheme.surface,
              offset: Offset.zero,
              blurRadius: 10,
            )
          ]),
      width: size,
      height: _height,
      child: Center(
        child: Text(
          type ?? '',
          style: TextStyle(
            fontSize: _fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
