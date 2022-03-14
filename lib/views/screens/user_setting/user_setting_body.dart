import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/services/firebase/auth_service.dart';
import 'package:flutter_chatapp/utils/utilities.dart';
import 'package:flutter_chatapp/views/screens/user_setting/user_setting_menu.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class UserSettingBody extends StatelessWidget {
  const UserSettingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _googleSignIn = AuthService();
    UserSettingBodyArguments args =
        ModalRoute.of(context)!.settings.arguments as UserSettingBodyArguments;

    return Padding(
      padding: kPadding,
      child: Column(
        children: [
          Column(
            children: [
              Hero(
                tag: 'user_setting_avatar',
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade400,
                  child: Text(
                    Utilities.getBackgroundWhenNotLoadImage(
                      args.user.firstName!,
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  foregroundImage: NetworkImage(args.user.imageUrl ?? ''),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                args.user.firstName!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          UserSettingMenu(
            text: "Sign out",
            onPressed: () => _googleSignIn.signOut(context: context),
          )
        ],
      ),
    );
  }
}

class UserSettingBodyArguments {
  final types.User user;

  UserSettingBodyArguments({required this.user});
}
