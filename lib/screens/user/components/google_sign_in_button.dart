import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    Key key,
    this.onTap,
    @required this.text,
  }) : super(key: key);
  final Function onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: kGrayColor.withAlpha(100)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/google.png',
                width: 25,
                height: 25,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
