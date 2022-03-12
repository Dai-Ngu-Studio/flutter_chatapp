import 'package:flutter/material.dart';
import 'package:flutter_chatapp/views/screens/room_setting/room_setting_body.dart';

class RoomSettingScreen extends StatelessWidget {
  const RoomSettingScreen({Key? key}) : super(key: key);

  static String routeName = '/room-setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: const RoomSettingBody(),
    );
  }
}
