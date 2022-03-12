import 'package:flutter/material.dart';
import 'package:flutter_chatapp/views/screens/chat_room/chat_room_screen.dart';
import 'package:flutter_chatapp/views/screens/home/home.dart';
import 'package:flutter_chatapp/views/screens/login/login_screen.dart';
import 'package:flutter_chatapp/views/screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  Home.routeName: (context) => const Home(),
  ChatRoomScreen.routeName: (context) => const ChatRoomScreen(),
};
