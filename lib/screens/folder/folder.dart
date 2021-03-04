import 'package:boxes/models/models.dart';
import 'package:boxes/screens/folder/folder_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FolderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserDrive drive =
        ModalRoute.of(context).settings.arguments as UserDrive;
    final FolderStore _store = FolderStore(drive);
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Observer(
            builder: (_) => ListView.builder(
              itemBuilder: (_, index) {
                final _d = _store.files[index];
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [Text(_d.name)],
                  ),
                );
              },
              itemCount: _store.files.length,
            ),
          ),
        ),
      ),
    );
  }
}
