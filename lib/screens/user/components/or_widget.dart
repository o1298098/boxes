import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';

class OrWidget extends StatelessWidget {
  const OrWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: kGrayColor,
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(
              horizontal: .5 * kDefaultPadding,
            ),
            child: Text(
              'Or',
              style: TextStyle(fontSize: 16),
            )),
        Expanded(
          child: Container(
            height: 1,
            color: kGrayColor,
          ),
        )
      ],
    );
  }
}
