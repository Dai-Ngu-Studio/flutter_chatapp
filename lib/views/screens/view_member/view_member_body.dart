import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ViewMemberBody extends StatefulWidget {
  const ViewMemberBody({Key? key, required this.room}) : super(key: key);

  final types.Room room;

  @override
  State<ViewMemberBody> createState() => _ViewMemberBodyState();
}

class _ViewMemberBodyState extends State<ViewMemberBody> {
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
        children: const [],
      ),
    );
  }
}
