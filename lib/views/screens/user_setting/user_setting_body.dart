import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/services/firebase/auth_service.dart';
import 'package:flutter_chatapp/views/screens/user_setting/user_setting_menu.dart';

class UserSettingBody extends StatelessWidget {
  const UserSettingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _googleSignIn = AuthService();

    return Padding(
      padding: kPadding,
      child: Column(
        children: [
          UserSettingMenu(
            text: "Sign out",
            onPressed: () => _googleSignIn.signOut(context: context),
          )
        ],
      ),
    );
  }
}
