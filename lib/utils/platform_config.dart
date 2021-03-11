import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

class PlatformConfig {
  void set() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      //setWindowTitle('App title');
      setWindowMinSize(const Size(1100, 500));
      setWindowMaxSize(Size.infinite);
    }
  }

  bool get isAndroid => Platform.isAndroid;

  bool get isIOS => Platform.isIOS;

  bool get isWindows => Platform.isWindows;

  bool get isLinux => Platform.isLinux;

  bool get isMacOS => Platform.isMacOS;
}
