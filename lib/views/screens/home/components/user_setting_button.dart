import 'package:flutter/material.dart';
import 'package:flutter_chatapp/views/screens/chat_room/components/group_avatar/members.dart';
import 'package:flutter_chatapp/views/screens/chat_room/components/group_avatar/users.dart';
import 'package:flutter_chatapp/views/screens/user_setting/user_setting_screen.dart';

class UserSettingButton extends StatelessWidget {
  const UserSettingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              firstName: "Nguyễn",
              lastName: "Dũng",
              imageUrl:
                  "https://scontent.fsgn2-3.fna.fbcdn.net/v/t1.6435-9/133357830_1237341779995351_21528659595782306_n.jpg?_nc_cat=108&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=5jXsS5eIDlYAX-x2Rk3&_nc_ht=scontent.fsgn2-3.fna&oh=00_AT_QVe9ewOR3kKBTnI7_Uddq84J1Qe_leIcBSx6mfWb56g&oe=6250503E",
            ),
          ],
        ),
      ),
    );
  }
}
