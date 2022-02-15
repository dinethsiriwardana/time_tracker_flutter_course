import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInManager {
  SignInManager({required this.auth, required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User?> signIn(Future<User?> Function() signinMethod) async {
    try {
      isLoading.value = true;
      return await signinMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User?> signInAnonymously() async => signIn(auth.signInAnonymously);

  Future<User?> signInWithGoogle() async => signIn(auth.signInWithGoogle);

  Future<User?> signinwithfacebook() async => signIn(auth.signinwithfacebook);
}
