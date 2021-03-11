import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  FToast fToast;
  bool isInit = false;

  void init(BuildContext context) {
    fToast = FToast()..init(context);
    isInit = true;
  }

  showToast(String text) {
    if (!isInit) return print('Please init before use toast');
    fToast.showToast(
      toastDuration: Duration(seconds: 3),
      child: Container(
        padding: EdgeInsets.all(.5 * kDefaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: const Color(0x60000000),
        ),
        child: Text(
          text,
          style: TextStyle(color: const Color(0xFFFFFFFF)),
        ),
      ),
    );
  }
}
