import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/views/screens/room_setting/room_setting_body.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class RoomSettingScreen extends StatefulWidget {
  const RoomSettingScreen({Key? key}) : super(key: key);

  static String routeName = '/room-setting';

  @override
  State<RoomSettingScreen> createState() => _RoomSettingScreenState();
}

class _RoomSettingScreenState extends State<RoomSettingScreen> {
  final db = FireStoreDB();

  @override
  void initState() {
    db.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RoomSettingScreenArguments args = ModalRoute.of(context)!.settings.arguments
        as RoomSettingScreenArguments;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
        title: const Text(
          'Room Settings',
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
          return RoomSettingBody(room: snapshot.data!);
        },
      ),
    );
  }
}

class RoomSettingScreenArguments {
  final types.Room room;

  RoomSettingScreenArguments({required this.room});
}
