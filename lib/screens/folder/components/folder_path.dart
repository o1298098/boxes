import 'package:boxes/models/models.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FolderPath extends StatelessWidget {
  const FolderPath({
    @required this.pathItem,
    @required this.onTap,
  });
  final List<Item> pathItem;
  final Function(Item) onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          PathButton(),
          SizedBox(
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
                      color: _selected ? Color(0xFFFFFFFF) : kGrayColor,
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: const Icon(
                  FontAwesomeIcons.chevronRight,
                  color: kGrayColor,
                  size: 10,
                ),
              ),
              itemCount: pathItem.length,
            ),
          ),
        ],
      ),
    );
  }
}

class PathButton extends StatelessWidget {
  const PathButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kBgLightColor,
        borderRadius: BorderRadius.circular(kDefaultPadding * .5),
      ),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.solidFolder,
            color: kGrayColor,
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
