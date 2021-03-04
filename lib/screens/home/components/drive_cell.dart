import 'package:boxes/models/models.dart';
import 'package:boxes/style/colors.dart';
import 'package:boxes/utils/api/drive/drive_api_factory.dart';
import 'package:boxes/utils/api/drive/drive_base_api.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class DriveCell extends StatefulWidget {
  const DriveCell({this.drive, this.onTap});
  final Function(UserDrive d) onTap;

  final UserDrive drive;

  @override
  _DriveCellState createState() => _DriveCellState();
}

class _DriveCellState extends State<DriveCell> {
  UserDrive _drive;
  DriveUsage _usage;
  @override
  void initState() {
    _drive = widget.drive;
    _usage = widget.drive.driveUsage;
    _getSpaceUsage();
    super.initState();
  }

  _getSpaceUsage() async {
    if (_usage != null) return;
    final DriveBaseApi _api = DriveApiFactory.getInstance(_drive.driveType.id);
    final DriveUsage _result = await (_api.getSpaceUsage(_drive));
    if (_result != null) {
      widget.drive.driveUsage = _result;
      setState(() {
        _usage = _result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(_drive),
      child: Container(
        width: 200,
        height: 200,
        padding: EdgeInsets.all(kDefaultPadding * .6),
        decoration: BoxDecoration(
          color: kBgLightColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 35,
              height: 35,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: kBgDarkColor.withAlpha(150),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                  'assets/images/${_drive.driveType.code}_logo.svg'),
            ),
            SizedBox(height: 10),
            Text(
              _drive.driveType.name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            Spacer(),
            _DataBar(
              used: ((_usage?.used ?? 0) / 1024 / 1024 / 1024).toDouble(),
              total: ((_usage?.allocated ?? 1) / 1024 / 1024 / 1024).toDouble(),
            )
          ],
        ),
      ),
    );
  }
}

class _DataBar extends StatelessWidget {
  final double used;
  final double total;
  const _DataBar({this.total = 15.0, this.used = 4.5});
  @override
  Widget build(BuildContext context) {
    final _fontSize = 8.0;
    final _barHeight = 4.0;
    final _radius = _barHeight / 2;
    final _p = used / total;
    return Column(
      children: [
        Row(
          children: [
            Text(
              '${used.toStringAsFixed(2)} GB',
              style: TextStyle(fontSize: _fontSize, color: Color(0xFF717171)),
            ),
            Spacer(),
            Text(
              '${total.toStringAsFixed(0)} GB',
              style: TextStyle(fontSize: _fontSize, color: Colors.white),
            )
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: _barHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kBgDarkColor,
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _p == 0 ? 0.001 : _p,
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(_radius),
              ),
            ),
          ),
        )
      ],
    );
  }
}
