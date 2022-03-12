import 'package:flutter/material.dart';
import 'package:flutter_chatapp/gen/assets.gen.dart';
import 'package:flutter_chatapp/views/screens/splash/init_widget.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _splashScreen();
  }

  _splashScreen() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    Navigator.pushReplacement(
      context,
      PageTransition(
        child: const InitializerWidget(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          Center(
            child: Hero(
              tag: 'SplashScreen',
              child: Assets.images.flutterChatappLogo.image(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: 90,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
