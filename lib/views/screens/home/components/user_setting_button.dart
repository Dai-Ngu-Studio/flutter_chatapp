import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/utils/utilities.dart';
import 'package:flutter_chatapp/views/screens/chat_room/components/group_avatar/members.dart';
import 'package:flutter_chatapp/views/screens/chat_room/components/group_avatar/users.dart';
import 'package:flutter_chatapp/views/screens/user_setting/user_setting_screen.dart';

class UserSettingButton extends StatefulWidget {
  const UserSettingButton({Key? key}) : super(key: key);

  @override
  State<UserSettingButton> createState() => _UserSettingButtonState();
}

class _UserSettingButtonState extends State<UserSettingButton> {
  final db = FireStoreDB();

  @override
  void initState() {
    db.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(UserSettingScreen.routeName);
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(50),
        child: StreamBuilder(
          stream: db
              .getUserByID(auth.FirebaseAuth.instance.currentUser!.uid)
              .asStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.grey.shade400,
                child: Text(
                  Utilities.getBackgroundWhenNotLoadImage(
                    snapshot.data?.docs[0]['displayName'].toString() ?? '',
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                foregroundImage: NetworkImage(
                  snapshot.data?.docs[0]['imageUrl'],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
