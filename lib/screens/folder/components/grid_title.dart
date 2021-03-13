import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';

class GridTitle extends StatelessWidget {
  const GridTitle({
    Key key,
    @required this.title,
    this.show = true,
  }) : super(key: key);

  final String title;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: show
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
