import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/views/screens/chat_room/chat_room_body.dart';
import 'package:flutter_chatapp/views/screens/room_setting/room_setting_screen.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  static String routeName = '/chat-room';

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final db = FireStoreDB();

  @override
  void initState() {
    db.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ChatRoomScreenArguments args =
        ModalRoute.of(context)!.settings.arguments as ChatRoomScreenArguments;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: StreamBuilder<DocumentSnapshot>(
          stream: db.getRoomByID(args.room.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return Text(snapshot.data!['name']);
          },
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
              Navigator.of(context).pushNamed(
                RoomSettingScreen.routeName,
                arguments: args,
              );
            },
          ),
        ],
      ),
      body: ChatRoomBody(room: args.room),
    );
  }
}

class ChatRoomScreenArguments {
  final types.Room room;

  ChatRoomScreenArguments(this.room);
}
