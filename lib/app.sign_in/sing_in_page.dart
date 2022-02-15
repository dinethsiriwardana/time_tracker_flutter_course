// ignore_for_file: unused_import

// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app.sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app.sign_in/sign_in_manager.dart';
import 'package:time_tracker_flutter_course/app.sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app.sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({required this.manager, required this.isLoading});
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'Error Aborted by User') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: "Sign in Failed",
      exception: exception,
    );
  }

  Future<void> _signiAnonymously(BuildContext context) async {
    try {
      // final auth = Provider.of<AuthBase>(context, listen: false);
      await manager.signInAnonymously();
    } on Exception catch (e) {
      // ignore: avoid_print
      // print(e.toString());
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // final auth = Provider.of<AuthBase>(context, listen: false);

      await manager.signInWithGoogle();
    } on Exception catch (e) {
      // ignore: avoid_print
      // print(e.toString());
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithfacebook(BuildContext context) async {
    try {
      // final auth = Provider.of<AuthBase>(context, listen: false);

      await manager.signinwithfacebook();
    } on Exception catch (e) {
      // ignore: avoid_print
      // print(e.toString());
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final isLoading = Provider.of<ValueNotifier<bool>>(context);
    // final bloc = Provider.of<SignInBloc>(context, listen: false);
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Time Tracker'),
      //   elevation: 2.0,
      // ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[300],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan.shade300,
            Colors.cyan,
            Colors.cyan.shade100,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "Sign in",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48.0),
            SocialSignInButton(
              assetName: 'images/google-logo.png',
              text: 'Sign in with Google',
              textColor: Colors.black,
              color: Colors.white,
              borderRadius: 6.0,
              onPressed: () => _signInWithGoogle(context),
            ),
            const SizedBox(height: 15.0),
            SocialSignInButton(
              assetName: 'images/facebook-logo.png',
              text: 'Sign in with facebook',
              textColor: Colors.white,
              color: Color(0xff334D92),
              borderRadius: 6.0,
              onPressed: () => _signInWithfacebook(context),
            ),
            const SizedBox(height: 15.0),
            SignInButton(
              text: 'Sign in with email',
              textColor: Colors.white,
              color: Colors.teal.shade700,
              borderRadius: 6.0,
              onPressed: () => _signInWithEmail(context),
            ),
            SizedBox(height: 8.0),
            const Text(
              "or",
              style: TextStyle(fontSize: 14.0, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15.0),
            SignInButton(
              text: 'Go anonymous',
              textColor: Colors.black,
              color: Colors.lime.shade500,
              borderRadius: 6.0,
              onPressed: () => _signiAnonymously(context),
            ),
          ],
        ),
      ),
    );
  }
}
