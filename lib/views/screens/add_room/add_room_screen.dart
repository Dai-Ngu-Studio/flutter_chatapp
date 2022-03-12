import 'package:flutter/material.dart';
import 'package:flutter_chatapp/views/screens/add_room/add_room_body.dart';

class AddRoomScreen extends StatelessWidget {
  const AddRoomScreen({Key? key}) : super(key: key);

  static String routeName = '/add-room';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
        title: const Text(
          'Add Room',
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
      body: const AddRoomBody(),
    );
  }
}
