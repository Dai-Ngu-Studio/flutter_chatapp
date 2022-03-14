import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/views/screens/chat_room/chat_room_screen.dart';
import 'package:flutter_chatapp/views/screens/view_member/view_member_body.dart';

class ViewMemberScreen extends StatefulWidget {
  const ViewMemberScreen({Key? key}) : super(key: key);

  static String routeName = '/view-member';

  @override
  State<ViewMemberScreen> createState() => _ViewMemberScreenState();
}

class _ViewMemberScreenState extends State<ViewMemberScreen> {
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
          centerTitle: true,
          title: const Text(
            'Members',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: db.getRoomByID(args.room.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return ViewMemberBody(room: args.room);
          },
        ));
  }
}
