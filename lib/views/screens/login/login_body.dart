import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/gen/assets.gen.dart';
import 'package:flutter_chatapp/services/firebase/auth_service.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/views/screens/home/home.dart';
import 'package:flutter_chatapp/views/widgets/adaptive_button.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final AuthService _googleSignIn = AuthService();
  bool _isLoading = false;
  String? fcmToken;
  late FireStoreDB db;

  initialize() {
    db = FireStoreDB();
    db.initialize();
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade200, const Color(0xFFFFFFFF)],
              stops: const [0, 100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          Hero(
                            tag: 'SplashScreen',
                            child: Assets.images.flutterChatappLogo.image(
                              width: MediaQuery.of(context).size.width * 0.25,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const FittedBox(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Welcome to ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'DN ChatApp',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const FittedBox(
                            child: Text(
                              "Powered by DaiNgu Team",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: AdaptiveButton(
                          text: "Login with Google",
                          enabled: !_isLoading,
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Assets.svgs.google.svg(height: 25),
                          ),
                          widthMobile: double.infinity,
                          height: 50,
                          borderRadius: 40,
                          backgroundColor: chatappColor,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          isLoading: _isLoading,
                          onPressed: () {
                            _login();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _login() {
    final _firebaseAuth = FirebaseAuth.instance;

    setState(() => _isLoading = true);

    _googleSignIn.googleLogin().whenComplete(() {
      if (_firebaseAuth.currentUser != null) {
        _firebaseAuth.currentUser!.getIdToken().then((idToken) {
          getFCMToken().then((fcmToken) {
            db.getUserByID(_firebaseAuth.currentUser!.uid).then((value) {
              final List<DocumentSnapshot> documents = value.docs;

              if (documents.isEmpty) {
                db.createUser(
                  types.User(
                    id: _firebaseAuth.currentUser!.uid,
                    firstName: _firebaseAuth.currentUser!.displayName,
                    imageUrl: _firebaseAuth.currentUser!.photoURL,
                  ),
                  email: _firebaseAuth.currentUser!.email!,
                  fcmToken: fcmToken!,
                );
              }
              Navigator.of(context).pushReplacementNamed(Home.routeName);
            });
          });
        }).catchError((error) {
          log(error.toString());
        });
      }
    }).catchError(
      (error) {
        final snackBar = SnackBar(
          content: Text(error.toString()),
          duration: const Duration(seconds: 5),
        );
        log(error.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          snackBar,
        );
      },
    ).then((_) => setState(() => _isLoading = false));
  }

  Future<String?> getFCMToken() async {
    await FirebaseMessaging.instance
        .getToken()
        .then((value) => setState(() => fcmToken = value!));
    print("LoginScreen Body :: FCM Token: $fcmToken");
    return fcmToken;
  }
}
