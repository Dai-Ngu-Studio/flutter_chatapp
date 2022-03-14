import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/utils/utilities.dart';
import 'package:flutter_chatapp/views/screens/user_setting/user_setting_body.dart';
import 'package:flutter_chatapp/views/screens/user_setting/user_setting_screen.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

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
    return StreamBuilder(
      stream: db
          .getUserByID(auth.FirebaseAuth.instance.currentUser!.uid)
          .asStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                UserSettingScreen.routeName,
                arguments: UserSettingBodyArguments(
                  user: types.User(
                    id: snapshot.data?.docs[0]['uid'],
                    firstName: snapshot.data?.docs[0]['displayName'],
                    imageUrl: snapshot.data?.docs[0]['imageUrl'],
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Hero(
                tag: 'user_setting_avatar',
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
              ),
            ),
          ),
        );
      },
    );
  }
}
