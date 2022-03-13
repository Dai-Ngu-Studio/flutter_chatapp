import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/views/screens/user_setting/user_setting_body.dart';

class UserSettingScreen extends StatelessWidget {
  const UserSettingScreen({Key? key}) : super(key: key);

  static String routeName = '/user-setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
        title: const Text(
          'User Settings',
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
      backgroundColor: kSecondaryColor,
      body: const UserSettingBody(),
    );
  }
}
