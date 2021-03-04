import 'package:boxes/models/models.dart';
import 'package:boxes/screens/home/components/drive_cell.dart';
import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DrivesPanel extends StatelessWidget {
  final List<UserDrive> drives;
  const DrivesPanel({this.drives = const []});
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
          drive: _d,
          onTap: (d) async {
            await Navigator.of(context).pushNamed('/folder', arguments: d);
          },
        );
      },
      itemCount: drives.length,
    );
  }
}
