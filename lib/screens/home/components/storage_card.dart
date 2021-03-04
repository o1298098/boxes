import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class StorageCard extends StatelessWidget {
  const StorageCard({this.icon, this.title, this.used = 0.0, this.total = 0.0});
  final String icon;
  final String title;
  final double used;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      padding: EdgeInsets.all(kDefaultPadding * .6),
      decoration: BoxDecoration(
        color: kBgLightColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 35,
            height: 35,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: kBgDarkColor.withAlpha(150),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              icon,
              key: ValueKey('svg${DateTime.now().millisecondsSinceEpoch}'),
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          Spacer(),
          _DataBar(
            used: used,
            total: total,
          )
        ],
      ),
    );
  }
}

class _DataBar extends StatelessWidget {
  final double used;
  final double total;
  const _DataBar({this.total = 15.0, this.used = 4.5});
  @override
  Widget build(BuildContext context) {
    final _fontSize = 8.0;
    final _barHeight = 4.0;
    final _radius = _barHeight / 2;
    return Column(
      children: [
        Row(
          children: [
            Text(
              '${used.toStringAsFixed(2)} GB',
              style: TextStyle(fontSize: _fontSize, color: Color(0xFF717171)),
            ),
            Spacer(),
            Text(
              '${total.toStringAsFixed(0)} GB',
              style: TextStyle(fontSize: _fontSize, color: Colors.white),
            )
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: _barHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kBgDarkColor,
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: used / total,
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(_radius),
              ),
            ),
          ),
        )
      ],
    );
  }
}
