import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/views/screens/login/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final firebaseAuth = FirebaseAuth.instance;
      User? user;

      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;

      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      log("AuthService :: google access token: ${googleAuth.accessToken}");
      log("AuthService :: google id token: ${googleAuth.idToken}");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        await firebaseAuth.signInWithCredential(credential);

        final currentUser = firebaseAuth.currentUser;

        currentUser?.getIdToken().then((value) {
          log("AuthService :: firebase idToken: $value");
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          throw Exception('This email already has an account');
        } else if (e.code == 'invalid-credential') {
          throw Exception('Invalid Credential');
        } else if (e.code == 'user-disabled') {
          throw Exception('User Disabled');
        }
      } catch (e) {
        throw Exception('Error occurred using Google Sign-In. Try again.');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }
}
