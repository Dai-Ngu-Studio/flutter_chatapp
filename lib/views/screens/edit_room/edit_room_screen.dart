import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/views/screens/edit_room/edit_room_body.dart';

class EditRoomScreen extends StatefulWidget {
  const EditRoomScreen({Key? key}) : super(key: key);

  static String routeName = '/edit-room';

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  final db = FireStoreDB();

  @override
  void initState() {
    db.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EditRoomScreenArguments args =
        ModalRoute.of(context)!.settings.arguments as EditRoomScreenArguments;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          centerTitle: true,
          title: const Text(
            'Edit Room',
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
            return EditRoomBody(
              room: snapshot.data!,
            );
          },
        ));
  }
}

class EditRoomScreenArguments {
  final DocumentSnapshot<Object?> room;

  EditRoomScreenArguments(this.room);
}
