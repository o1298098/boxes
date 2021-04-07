import 'package:boxes/models/models.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FolderPath extends StatelessWidget {
  const FolderPath({
    @required this.pathItem,
    @required this.onPathTap,
    this.onSwitchTap,
    this.isList = false,
  });
  final List<Item> pathItem;
  final Function(Item) onPathTap;
  final Function onSwitchTap;
  final bool isList;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          _PathButton(),
          _FolderPath(pathItem: pathItem, onTap: onPathTap),
          _LayoutSwitch(
            isList: isList,
            onTap: onSwitchTap,
          ),
        ],
      ),
    );
  }
}

class _LayoutSwitch extends StatelessWidget {
  const _LayoutSwitch({
    Key key,
    this.isList = false,
    this.onTap,
  }) : super(key: key);

  final bool isList;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: _theme.brightness == Brightness.dark
            ? _theme.cardColor
            : const Color(0xFFE7F0F7),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          _LayoutItem(
            onTap: onTap,
            selected: isList,
            icon: Icons.view_list_rounded,
          ),
          _LayoutItem(
            onTap: onTap,
            selected: !isList,
            icon: Icons.view_module_rounded,
          ),
        ],
      ),
    );
  }
}

class _LayoutItem extends StatelessWidget {
  const _LayoutItem({
    Key key,
    @required this.onTap,
    this.icon,
    this.selected = false,
  }) : super(key: key);

  final Function onTap;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: selected
            ? BoxDecoration(
                color: _theme.brightness == Brightness.dark
                    ? kLineColor
                    : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(6.0),
              )
            : null,
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        child: Icon(
          icon,
          color: selected
              ? _theme.colorScheme.onPrimary
              : _theme.colorScheme.primary,
          size: 14,
        ),
      ),
    );
  }
}

class _FolderPath extends StatelessWidget {
  const _FolderPath({
    Key key,
    @required this.pathItem,
    @required this.onTap,
  }) : super(key: key);

  final List<Item> pathItem;
  final Function(Item p1) onTap;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Expanded(
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: 8,
          ),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (_, index) {
            final _d = pathItem[index];
            final _selected = index == pathItem.length - 1;
            return InkWell(
              onTap: () => onTap(_d),
              child: Text(
                _d.name,
                style: TextStyle(
                  fontSize: 14,
                  color: _selected
                      ? _theme.textTheme.bodyText1.color
                      : _theme.colorScheme.secondary,
                ),
              ),
            );
          },
          separatorBuilder: (_, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              FontAwesomeIcons.chevronRight,
              color: _theme.colorScheme.secondary,
              size: 10,
            ),
          ),
          itemCount: pathItem.length,
        ),
      ),
    );
  }
}

class _PathButton extends StatelessWidget {
  const _PathButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _theme.cardColor,
        borderRadius: BorderRadius.circular(kDefaultPadding * .5),
      ),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.solidFolder,
            color: _theme.colorScheme.primary,
            size: 16,
          ),
          SizedBox(width: 10),
          Icon(
            FontAwesomeIcons.chevronDown,
            color: kGrayColor,
            size: 10,
          )
        ],
      ),
    );
  }
}
