import 'package:boxes/models/models.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FolderItem extends StatelessWidget {
  final DriveFile file;
  final int count;
  final Function(DriveFile) onTap;
  final String token;
  const FolderItem(
      {@required this.file, this.token, @required this.onTap, this.count});
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onTap(file),
      child: Container(
        padding: EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _theme.cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              FontAwesomeIcons.solidFolder,
              color: _theme.colorScheme.primary,
            ),
            Spacer(),
            Text(
              file.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '${count ?? '-'} files',
              style: TextStyle(
                fontSize: 10,
                color: kGrayColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
