import 'package:boxes/responsive.dart';
import 'package:boxes/screens/file_soucre/file_source_store.dart';
import 'package:boxes/services/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/detail.dart';
import 'components/menu.dart';

class FileSourceScreen extends StatefulWidget {
  @override
  _FileSourceScreenState createState() => _FileSourceScreenState();
}

class _FileSourceScreenState extends State<FileSourceScreen> {
  final FileSourceStore _store = FileSourceStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Consumer<SettingsStore>(
          builder: (_, settingsStore, __) => Row(
            children: Responsive.isMobile(context)
                ? [
                    Expanded(
                      child: Menu(),
                    ),
                  ]
                : [
                    SizedBox(
                      width: 300,
                      child: Menu(
                        store: settingsStore,
                        onAddService: _store.addService,
                        onDriveTap: _store.setDrive,
                      ),
                    ),
                    Expanded(
                      child:
                          Detail(store: _store, settingsStore: settingsStore),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
