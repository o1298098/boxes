import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GithubSignInButton extends StatelessWidget {
  const GithubSignInButton({
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
          borderRadius: BorderRadius.circular(8.0),
          color: const Color(0xFF000000),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Icon(
                FontAwesomeIcons.github,
                color: const Color(0xFFFFFFFF),
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFFFFFFFF),
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
