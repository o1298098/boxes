import 'package:boxes/settings/settings_store.dart';
import 'package:boxes/utils/api/base_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount _currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SettingsStore _settingsStore;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      //'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  @override
  void initState() {
    super.initState();
    _settingsStore = Provider.of<SettingsStore>(context, listen: false);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      _googleSignIn.signInSilently();
    });
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      if (user != null) {
        var appUser = await BaseApi.instance.updateUser(user.uid, user.email,
            user.photoURL, user.displayName, user.phoneNumber);
        if (appUser.success)
          await _settingsStore.setAppUser(value: appUser.result);
      } else {}
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Observer(
              builder: (_) =>
                  Text('${_settingsStore.appUser.toString() ?? 'none'}'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async => await _handleSignIn(),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
