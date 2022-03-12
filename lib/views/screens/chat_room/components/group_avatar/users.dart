import 'package:flutter_chatapp/views/screens/chat_room/components/group_avatar/members.dart';

class User with MemberMixin {
  final String? imageUrl;
  final String firstName;
  final String lastName;

  User({
    this.imageUrl,
    required this.firstName,
    required this.lastName,
  });

  @override
  String avatarUrl() {
    return imageUrl!;
  }

  @override
  bool hasAvatar() {
    return imageUrl != null;
  }

  @override
  String initials() {
    return firstName.substring(0, 1) + "" + lastName.substring(0, 1);
  }
}
