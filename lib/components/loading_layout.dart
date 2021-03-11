import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';

class LoadingLayout extends StatelessWidget {
  final String title;
  final bool show;
  const LoadingLayout({this.show, @required this.title});
  @override
  Widget build(BuildContext context) {
    return show
        ? Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0x20000000),
              child: Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xAA000000),
                    borderRadius: BorderRadius.circular(
                      kDefaultPadding,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(const Color(0xFFFFFFFF)),
                      ),
                      SizedBox(height: kDefaultPadding),
                      Text(
                        title,
                        style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : SizedBox();
  }
}
