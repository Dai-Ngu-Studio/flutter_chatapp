import 'package:flutter/material.dart';
import 'package:flutter_chatapp/views/screens/add_member/add_member_screen.dart';
import 'package:flutter_chatapp/views/screens/add_room/add_room_screen.dart';
import 'package:flutter_chatapp/views/screens/chat_room/chat_room_screen.dart';
import 'package:flutter_chatapp/views/screens/home/home.dart';
import 'package:flutter_chatapp/views/screens/login/login_screen.dart';
import 'package:flutter_chatapp/views/screens/room_setting/room_setting_screen.dart';
import 'package:flutter_chatapp/views/screens/splash/splash_screen.dart';
import 'package:flutter_chatapp/views/screens/user_setting/user_setting_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  Home.routeName: (context) => const Home(),
  UserSettingScreen.routeName: (context) => const UserSettingScreen(),
  AddRoomScreen.routeName: (context) => const AddRoomScreen(),
  AddMemberScreen.routeName: (context) => const AddMemberScreen(),
  ChatRoomScreen.routeName: (context) => const ChatRoomScreen(),
  RoomSettingScreen.routeName: (context) => const RoomSettingScreen(),
};
