import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/utils/utilities.dart';
import 'package:flutter_chatapp/views/screens/chat_room/components/group_avatar/members.dart';
import 'package:flutter_chatapp/views/screens/chat_room/components/group_avatar/users.dart';
import 'package:flutter_chatapp/views/screens/user_setting/user_setting_screen.dart';

class UserSettingButton extends StatelessWidget {
  const UserSettingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var firebaseUser = auth.FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(UserSettingScreen.routeName);
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(50),
        child: Members(
          avatarDiameter: 22,
          backgroundColor: Colors.grey.shade400,
          members: [
            User(
              firstName: Utilities.getBackgroundWhenNotLoadImage(
                firebaseUser!.displayName ?? '',
              ).substring(0, 1),
              lastName: Utilities.getBackgroundWhenNotLoadImage(
                firebaseUser.displayName ?? '',
              ).substring(1, 2),
              imageUrl: firebaseUser.photoURL ??
                  Utilities.getBackgroundWhenNotLoadImage(
                    firebaseUser.displayName!,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
