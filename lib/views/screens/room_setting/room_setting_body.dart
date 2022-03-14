import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/views/screens/add_member/add_member_screen.dart';
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

  List<types.User> listUser = [];

  @override
  void initState() {
    db.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPadding,
      child: Column(
        children: [
          RoomSettingMenu(
            text: "Add members",
            onPressed: () async {
              Navigator.of(context)
                  .pushNamed(
                AddMemberScreen.routeName,
                arguments: AddMemberScreenArguments(
                  onPressed: (user) {
                    setState(() => listUser.add(user));
                  },
                  users: listUser,
                  isUpdate: true,
                  roomId: widget.room.id,
                ),
              )
                  .then(
                (value) async {
                  if (listUser.isNotEmpty) {
                    await db.addMembersToRoom(
                      roomId: widget.room.id,
                      users: listUser,
                    );
                  }
                },
              );
            },
          ),
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
          ),
        ],
      ),
    );
  }
}
