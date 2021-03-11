import 'package:boxes/models/models.dart';
import 'package:boxes/screens/home/components/drive_cell.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DrivesPanel extends StatelessWidget {
  final List<UserDrive> drives;
  final Function(UserDrive) onTap;
  const DrivesPanel({this.drives = const [], this.onTap});
  @override
  Widget build(BuildContext context) {
    return SliverStaggeredGrid.extentBuilder(
      maxCrossAxisExtent: 180,
      mainAxisSpacing: kDefaultPadding,
      crossAxisSpacing: kDefaultPadding,
      staggeredTileBuilder: (index) => StaggeredTile.extent(1, 160),
      itemBuilder: (_, index) {
        final _d = drives[index];
        return DriveCell(
          key: ValueKey(_d),
          drive: _d,
          onTap: onTap,
        );
      },
      itemCount: drives.length,
    );
  }
}
