import 'package:boxes/components/loading_layout.dart';
import 'package:boxes/screens/user/components/github_sign_in_button.dart';
import 'package:boxes/screens/user/components/google_sign_in_button.dart';
import 'package:boxes/screens/user/components/input_field.dart';
import 'package:boxes/screens/user/sign_up.dart';
import 'package:boxes/settings/settings_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:boxes/utils/api/base_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'components/or_widget.dart';
import 'components/right_panel.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  SettingsStore _settingsStore;
  FToast fToast;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/drive',
    ],
  );
  TextEditingController _emailTextController;
  TextEditingController _passwordTextController;
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    _settingsStore = Provider.of<SettingsStore>(context, listen: false);
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _emailFocusNode?.dispose();
    _passwordFocusNode?.dispose();
    super.dispose();
  }

  _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _showToast(String text) {
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

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return _showToast('google sign in canel');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      _setLoading(true);
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
        if (appUser.success) {
          await _settingsStore.setAppUser(value: appUser.result);
          Navigator.of(context).pop(true);
        } else
          _showToast('Something wrong, please try later');
        _setLoading(false);
      } else {}
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleGithubSignIn() async {}

  Future<void> _handleSignUp() async {
    final _result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, __) {
          return SignUpScreen();
        },
      ),
    );
    if (_result ?? false) Navigator.of(context).pop();
  }

  Future<void> _handleForgotPassword() async {}

  Future<void> _handleSubmit() async {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    _setLoading(true);
    if (_emailTextController.text != '' && _passwordTextController.text != '') {
      try {
        final _email = _emailTextController.text.trim();
        final _reuslt = await _auth.signInWithEmailAndPassword(
            email: _email, password: _passwordTextController.text);
        if (_reuslt.user != null) {
          final _user = _reuslt.user;
          var appUser = await BaseApi.instance.updateUser(
            _user.uid,
            _user.email,
            _user.photoURL,
            _user.displayName,
            _user.phoneNumber,
          );
          if (appUser.success) {
            await _settingsStore.setAppUser(value: appUser.result);
            Navigator.of(context).pop();
          } else
            _showToast('Something wrong, please try later');
          _setLoading(false);
        }
      } on Exception catch (_) {
        _showToast(_.toString());
      }
    } else {
      _showToast('Please check your email and password and try again');
    }
    _setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          LayoutBuilder(builder: (_, c) {
            return Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: c.maxWidth > 900
                    ? [
                        _LeftPanel(
                          onSubmit: _handleSubmit,
                          onGoogleSignIn: _handleGoogleSignIn,
                          onGithubSignIn: _handleGithubSignIn,
                          onForgotPassword: _handleForgotPassword,
                          onSignUp: _handleSignUp,
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController,
                          emailFocusNode: _emailFocusNode,
                          passwordFocusNode: _passwordFocusNode,
                        ),
                        const RightPanel()
                      ]
                    : [
                        Expanded(
                          child: Center(
                            child: _LeftPanel(
                              onSubmit: _handleSubmit,
                              onGoogleSignIn: _handleGoogleSignIn,
                              onGithubSignIn: _handleGithubSignIn,
                              onForgotPassword: _handleForgotPassword,
                              onSignUp: _handleSignUp,
                              emailTextController: _emailTextController,
                              passwordTextController: _passwordTextController,
                              emailFocusNode: _emailFocusNode,
                              passwordFocusNode: _passwordFocusNode,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: double.infinity,
                        )
                      ],
              ),
            );
          }),
          SafeArea(
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Icon(Icons.close),
              ),
            ),
          ),
          LoadingLayout(
            title: 'Loading',
            show: _isLoading,
          ),
        ],
      ),
    );
  }
}

class _LeftPanel extends StatelessWidget {
  const _LeftPanel({
    Key key,
    this.onSignUp,
    this.onGithubSignIn,
    this.onGoogleSignIn,
    this.onSubmit,
    this.onForgotPassword,
    this.emailTextController,
    this.passwordTextController,
    this.emailFocusNode,
    this.passwordFocusNode,
  }) : super(key: key);

  final Function onSignUp;
  final Function onGoogleSignIn;
  final Function onGithubSignIn;
  final Function onSubmit;
  final Function onForgotPassword;
  final TextEditingController emailTextController;
  final TextEditingController passwordTextController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(1.5 * kDefaultPadding),
        constraints: BoxConstraints(maxWidth: 400),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.2 * kDefaultPadding),
              _SignUp(onSignUp: onSignUp),
              SizedBox(height: 1.2 * kDefaultPadding),
              GoogleSignInButton(
                onTap: onGoogleSignIn,
                text: 'Sign in with Google',
              ),
              SizedBox(height: .5 * kDefaultPadding),
              GithubSignInButton(
                onTap: onGithubSignIn,
                text: 'Sign in with Github',
              ),
              SizedBox(height: kDefaultPadding),
              OrWidget(),
              SizedBox(height: kDefaultPadding),
              InputField(
                controller: emailTextController,
                focusNode: emailFocusNode,
                inputType: TextInputType.emailAddress,
                hintText: 'Email',
                onSubmit: (s) => passwordFocusNode.requestFocus(),
              ),
              SizedBox(height: kDefaultPadding),
              InputField(
                controller: passwordTextController,
                focusNode: passwordFocusNode,
                inputType: TextInputType.visiblePassword,
                hintText: 'Password',
                obscureText: true,
                onSubmit: (s) => onSubmit(),
              ),
              SizedBox(height: .5 * kDefaultPadding),
              _ForgotPassword(onForgotPassword: onForgotPassword),
              SizedBox(height: 3 * kDefaultPadding),
              _SignInButton(onSubmit: onSubmit),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignUp extends StatelessWidget {
  const _SignUp({
    Key key,
    @required this.onSignUp,
  }) : super(key: key);

  final Function onSignUp;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 16),
        children: [
          TextSpan(text: 'Or  '),
          TextSpan(
            text: 'Sign up',
            style: TextStyle(
              color: kBadgeColor,
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()..onTap = onSignUp,
          ),
        ],
      ),
    );
  }
}

class _ForgotPassword extends StatelessWidget {
  const _ForgotPassword({
    Key key,
    @required this.onForgotPassword,
  }) : super(key: key);

  final Function onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onForgotPassword,
      child: Align(
        alignment: Alignment.centerRight,
        child: Text('Forgot password?'),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({
    Key key,
    @required this.onSubmit,
  }) : super(key: key);

  final Function onSubmit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSubmit,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(.6 * kDefaultPadding),
        decoration: BoxDecoration(
          color: kBadgeColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            'Sign In',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}
