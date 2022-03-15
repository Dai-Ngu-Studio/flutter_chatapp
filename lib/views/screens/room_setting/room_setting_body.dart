import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/utils/utilities.dart';
import 'package:flutter_chatapp/views/screens/add_member/add_member_screen.dart';
import 'package:flutter_chatapp/views/screens/edit_room/edit_room_screen.dart';
import 'package:flutter_chatapp/views/screens/home/home.dart';
import 'package:flutter_chatapp/views/screens/room_setting/room_setting_menu.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chatapp/views/screens/view_member/view_member_screen.dart';

class RoomSettingBody extends StatefulWidget {
  const RoomSettingBody({
    Key? key,
    required this.room,
  }) : super(key: key);

  final DocumentSnapshot<Object?> room;

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
          Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade400,
                child: Text(
                  Utilities.getBackgroundWhenNotLoadImage(
                      widget.room.get("name")),
                  style: const TextStyle(color: Colors.white, fontSize: 40),
                ),
                foregroundImage:
                    NetworkImage(widget.room.get("imageUrl") ?? ''),
              ),
              const SizedBox(height: 10),
              Text(
                widget.room.get("name"),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          RoomSettingMenu(
            text: "View members",
            onPressed: () {
              Navigator.of(context).pushNamed(
                ViewMemberScreen.routeName,
                arguments: ViewMemberScreenArguments(
                  widget.room,
                ),
              );
            },
          ),
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
            text: "Edit Room",
            onPressed: () async {
              Navigator.of(context).pushNamed(
                EditRoomScreen.routeName,
                arguments: EditRoomScreenArguments(
                  widget.room,
                ),
              );
            },
          ),
          RoomSettingMenu(
            text: "Leave room",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Leave room"),
                    content: const Text(
                      "Are you sure you want to leave this room?",
                    ),
                    actions: [
                      ElevatedButton(
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                        ),
                      ),
                      ElevatedButton(
                        child: const Text("Leave"),
                        onPressed: () async {
                          await db.leaveRoom(
                            user: types.User(id: _user!.uid),
                            roomId: widget.room.id,
                          );
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Home.routeName,
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
