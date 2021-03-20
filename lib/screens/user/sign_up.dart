import 'package:boxes/components/loading_layout.dart';
import 'package:boxes/screens/user/components/github_sign_in_button.dart';
import 'package:boxes/screens/user/components/google_sign_in_button.dart';
import 'package:boxes/screens/user/components/or_widget.dart';
import 'package:boxes/services/settings_store.dart';
import 'package:boxes/style/colors.dart';
import 'package:boxes/utils/api/base_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'components/input_field.dart';
import 'components/left_panel.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SettingsStore _settingsStore;
  FToast fToast;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/drive',
    ],
  );
  TextEditingController _nameTextController;
  TextEditingController _emailTextController;
  TextEditingController _passwordTextController;
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _nameFocusNode;
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    _settingsStore = Provider.of<SettingsStore>(context, listen: false);
    _nameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _nameFocusNode = FocusNode();
    super.initState();
  }

  @override
  dispose() {
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _nameFocusNode.dispose();
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

  _handleSignIn() {
    Navigator.of(context).pop();
  }

  Future<void> _handleSubmit() async {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    _nameFocusNode.unfocus();
    if (_nameTextController.text == '' ||
        _emailTextController.text == '' ||
        _passwordTextController.text == '') {
      _showToast('Please enter all information');
    } else {
      try {
        _setLoading(true);
        final user = (await _auth.createUserWithEmailAndPassword(
                email: _emailTextController.text,
                password: _passwordTextController.text))
            .user;
        if (user != null) {
          assert(_nameTextController.text != '');
          user.sendEmailVerification();
          await user.updateProfile(displayName: _nameTextController.text);
          var appUser = await BaseApi.instance.updateUser(user.uid, user.email,
              user.photoURL, _nameTextController.text, user.phoneNumber);
          if (appUser.success) {
            await _settingsStore.setAppUser(value: appUser.result);
            Navigator.of(context).pop(true);
          } else
            _showToast('Something wrong, please try later');
          _setLoading(false);
        }
        _setLoading(false);
      } on Exception catch (e) {
        _showToast(e.toString());
        _setLoading(false);
      }
    }
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
                        const LeftPanel(),
                        Expanded(
                          child: Center(
                            child: _RightPanel(
                              onGoogleSignIn: _handleGoogleSignIn,
                              onSignIn: _handleSignIn,
                              onSubmit: _handleSubmit,
                              nameTextController: _nameTextController,
                              emailTextController: _emailTextController,
                              passwordTextController: _passwordTextController,
                              emailFocusNode: _emailFocusNode,
                              passwordFocusNode: _passwordFocusNode,
                              nameFocusNode: _nameFocusNode,
                            ),
                          ),
                        ),
                      ]
                    : [
                        Expanded(
                          child: Center(
                            child: _RightPanel(
                              onGoogleSignIn: _handleGoogleSignIn,
                              onSignIn: _handleSignIn,
                              onSubmit: _handleSubmit,
                              nameTextController: _nameTextController,
                              emailTextController: _emailTextController,
                              passwordTextController: _passwordTextController,
                              emailFocusNode: _emailFocusNode,
                              passwordFocusNode: _passwordFocusNode,
                              nameFocusNode: _nameFocusNode,
                            ),
                          ),
                        ),
                        SizedBox(height: double.infinity)
                      ],
              ),
            );
          }),
          SafeArea(
            child: InkWell(
              onTap: () => Navigator.of(context).pop(true),
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Icon(
                  Icons.close,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
          LoadingLayout(
            title: 'Loading',
            show: _isLoading,
          )
        ],
      ),
    );
  }
}

class _RightPanel extends StatelessWidget {
  const _RightPanel({
    Key key,
    this.onSignIn,
    this.onGithubSignIn,
    this.onGoogleSignIn,
    this.onSubmit,
    this.nameTextController,
    this.emailTextController,
    this.passwordTextController,
    this.nameFocusNode,
    this.passwordFocusNode,
    this.emailFocusNode,
  }) : super(key: key);

  final Function onSignIn;
  final Function onGoogleSignIn;
  final Function onGithubSignIn;
  final Function onSubmit;
  final TextEditingController nameTextController;
  final TextEditingController emailTextController;
  final TextEditingController passwordTextController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode nameFocusNode;

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
                'Sign up',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.2 * kDefaultPadding),
              _SignIn(onSignIn: onSignIn),
              SizedBox(height: 1.2 * kDefaultPadding),
              GoogleSignInButton(
                onTap: onGoogleSignIn,
                text: 'Sign up with Google',
              ),
              SizedBox(height: .5 * kDefaultPadding),
              GithubSignInButton(
                onTap: onGithubSignIn,
                text: 'Sign up with Github',
              ),
              SizedBox(height: kDefaultPadding),
              OrWidget(),
              SizedBox(height: kDefaultPadding),
              _InputForm(
                nameTextController: nameTextController,
                nameFocusNode: nameFocusNode,
                emailFocusNode: emailFocusNode,
                emailTextController: emailTextController,
                passwordFocusNode: passwordFocusNode,
                passwordTextController: passwordTextController,
                onSubmit: onSubmit,
              ),
              SizedBox(height: .5 * kDefaultPadding),
              SizedBox(height: 3 * kDefaultPadding),
              _SignUpButton(onSubmit: onSubmit)
            ],
          ),
        ),
      ),
    );
  }
}

class _InputForm extends StatelessWidget {
  const _InputForm({
    Key key,
    @required this.nameTextController,
    @required this.nameFocusNode,
    @required this.emailFocusNode,
    @required this.emailTextController,
    @required this.passwordFocusNode,
    @required this.passwordTextController,
    @required this.onSubmit,
  }) : super(key: key);

  final TextEditingController nameTextController;
  final FocusNode nameFocusNode;
  final FocusNode emailFocusNode;
  final TextEditingController emailTextController;
  final FocusNode passwordFocusNode;
  final TextEditingController passwordTextController;
  final Function onSubmit;

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
        child: Column(children: [
          InputField(
            controller: nameTextController,
            focusNode: nameFocusNode,
            inputType: TextInputType.name,
            hintText: 'Name',
            autofillHints: [AutofillHints.nickname],
            onSubmit: (s) => emailFocusNode.requestFocus(),
          ),
          SizedBox(height: kDefaultPadding),
          InputField(
            controller: emailTextController,
            focusNode: emailFocusNode,
            inputType: TextInputType.emailAddress,
            hintText: 'Email',
            autofillHints: [AutofillHints.email, AutofillHints.newUsername],
            onSubmit: (s) => passwordFocusNode.requestFocus(),
          ),
          SizedBox(height: kDefaultPadding),
          InputField(
            controller: passwordTextController,
            focusNode: passwordFocusNode,
            inputType: TextInputType.visiblePassword,
            hintText: 'Password',
            autofillHints: [AutofillHints.newPassword],
            obscureText: true,
            onSubmit: (s) => onSubmit(),
          ),
        ]),
      ),
    );
  }
}

class _SignIn extends StatelessWidget {
  const _SignIn({
    Key key,
    @required this.onSignIn,
  }) : super(key: key);

  final Function onSignIn;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 16),
        children: [
          TextSpan(text: 'Already has a account?  '),
          TextSpan(
            text: 'Sign in',
            style: TextStyle(
              color: kBadgeColor,
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()..onTap = onSignIn,
          ),
        ],
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({
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
            'Create Account',
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
