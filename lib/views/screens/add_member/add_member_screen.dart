import 'package:flutter/material.dart';
import 'package:flutter_chatapp/views/screens/add_member/add_member_body.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AddMemberScreen extends StatelessWidget {
  const AddMemberScreen({Key? key}) : super(key: key);

  static String routeName = '/add-member';

  @override
  Widget build(BuildContext context) {
    AddMemberScreenArguments args =
        ModalRoute.of(context)!.settings.arguments as AddMemberScreenArguments;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
        title: const Text(
          'Add Member',
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
      body: AddMemberBody(onPressed: args.onPressd, users: args.users),
    );
  }
}

class AddMemberScreenArguments {
  final Function onPressd;
  final List<types.User> users;

  const AddMemberScreenArguments({required this.onPressd, required this.users});
}
