import 'package:flutter/material.dart';
import 'package:flutter_chatapp/views/screens/chat_room/chat_room_body.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  static String routeName = '/chat-room';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: ChatRoomBody(),
    );
  }
}
