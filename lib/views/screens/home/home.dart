import 'package:flutter/material.dart';
import 'package:flutter_chatapp/views/screens/add_room/add_room_screen.dart';
import 'package:flutter_chatapp/views/screens/home/components/user_setting_button.dart';
import 'package:flutter_chatapp/views/screens/home/home_body.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: const UserSettingButton(),
        centerTitle: true,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded, size: 22),
            splashRadius: 16,
            onPressed: () {
              Navigator.of(context).pushNamed(AddRoomScreen.routeName);
            },
          ),
        ],
      ),
      body: const HomeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddRoomScreen.routeName);
        },
        child: const Icon(Icons.add_comment_rounded),
      ),
    );
  }
}
