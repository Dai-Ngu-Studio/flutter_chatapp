import 'package:flutter/material.dart';
import 'package:flutter_chatapp/views/screens/chat_room/chat_room_body.dart';
import 'package:flutter_chatapp/views/screens/room_setting/room_setting_screen.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  static String routeName = '/chat-room';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text(
          'DaiNgu',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          splashRadius: 18,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, size: 20),
            splashRadius: 18,
            onPressed: () {
              Navigator.of(context).pushNamed(RoomSettingScreen.routeName);
            },
          ),
        ],
      ),
      body: const ChatRoomBody(),
    );
  }
}

class ChatRoomScreenArguments {
  final String roomID;

  ChatRoomScreenArguments(this.roomID);
}
