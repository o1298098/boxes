import 'package:boxes/settings/settings_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountSrceen extends StatelessWidget {
  final SettingsStore settings;

  const AccountSrceen({Key key, this.settings}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text('Sign Out'),
          onPressed: () async {
            FirebaseAuth.instance.signOut();
            settings?.setAppUser(value: null);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
