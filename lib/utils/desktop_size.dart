import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

class DesktopSize {
  void set() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      //setWindowTitle('App title');
      setWindowMinSize(const Size(1100, 500));
      setWindowMaxSize(Size.infinite);
    }
  }
}
