import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF366CF6);
const kSecondaryColor = Color(0xFFF5F6FC);
const kBgLightColor = Color(0xFF26262E);
const kBgDarkColor = Color(0xFF1D1B22);
const kBadgeColor = Color(0xFFEE376E);
const kGrayColor = Color(0xFF737377);
const kTextColor = Color(0xFF4D5875);
const kMenuBackgroundColor = Color(0xFF26262E);
const kSelectIconColor = Color(0xFFE0E0E0);
const kIconColor = Color(0xFF86868A);
const kLineColor = Color(0xFF34343B);
const kDefaultPadding = 20.0;

class AppStyle {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    backgroundColor: const Color(0xFFF5F9FD),
    cardColor: const Color(0xFFFFFFFF),
    colorScheme: ThemeData.light().colorScheme.copyWith(
          //IconColor
          primary: const Color(0xFFBAC8D4),
          //selectIconColor
          onPrimary: const Color(0xFF1A96EF),
          //grayColor
          secondary: kGrayColor,
          //lineColor
          surface: const Color(0xFFD2DDE6),
        ),
  );
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    backgroundColor: Color(0xFF1D1B22),
    cardColor: Color(0xFF26262E),
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          //IconColor
          primary: kIconColor,
          //selectIconColor
          onPrimary: kSelectIconColor,
          //grayColor
          secondary: kGrayColor,
          //lineColor
          surface: kLineColor,
        ),
  );
}
