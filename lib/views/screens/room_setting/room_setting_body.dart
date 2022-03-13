import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/views/screens/home/home.dart';
import 'package:flutter_chatapp/views/screens/room_setting/room_setting_menu.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class RoomSettingBody extends StatefulWidget {
  const RoomSettingBody({Key? key, required this.room}) : super(key: key);

  final types.Room room;

  @override
  State<RoomSettingBody> createState() => _RoomSettingBodyState();
}

class _RoomSettingBodyState extends State<RoomSettingBody> {
  final db = FireStoreDB();
  final _user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    db.initialize();
    return Padding(
      padding: kPadding,
      child: Column(
        children: [
          RoomSettingMenu(
            text: "Leave room",
            onPressed: () {
              db.leaveRoom(
                  user: types.User(id: _user!.uid), roomId: widget.room.id);
              Navigator.of(context).pushNamedAndRemoveUntil(
                Home.routeName,
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}
