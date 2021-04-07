import 'package:boxes/style/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {Key key,
      this.leading,
      this.style,
      this.title,
      this.centerTitle = false,
      this.needBackButton = false,
      this.backButtonTap,
      this.actions = const []})
      : super(key: key);
  final String title;
  final TextStyle style;
  final Widget leading;
  final List<Widget> actions;
  final bool centerTitle;
  final bool needBackButton;
  final Function backButtonTap;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Column(
      children: [
        AppBar(
          primary: false,
          backgroundColor: _theme.backgroundColor,
          elevation: 0.0,
          actions: actions,
          centerTitle: centerTitle,
          titleSpacing: leading == null ? 0.0 : null,
          title: Text(
            title,
            style:
                TextStyle(fontSize: 16, color: _theme.textTheme.bodyText1.color)
                    .merge(style),
          ),
          leading: needBackButton ? _BackButton(onTap: backButtonTap) : leading,
        ),
        Container(
          height: 1,
          color: _theme.colorScheme.surface,
        )
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({this.onTap});
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 12.0, right: 24.0, bottom: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(.5 * kDefaultPadding),
          border: Border.all(color: _theme.colorScheme.surface),
        ),
        child: Icon(
          CupertinoIcons.left_chevron,
          color: _theme.colorScheme.onPrimary,
          size: 12,
        ),
      ),
    );
  }
}
