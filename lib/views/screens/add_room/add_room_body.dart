import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/utils/utilities.dart';
import 'package:flutter_chatapp/views/screens/add_member/add_member_screen.dart';
import 'package:flutter_chatapp/views/widgets/adaptive_button.dart';

class AddRoomBody extends StatefulWidget {
  const AddRoomBody({Key? key}) : super(key: key);

  @override
  State<AddRoomBody> createState() => _AddRoomBodyState();
}

class _AddRoomBodyState extends State<AddRoomBody> {
  final _roomNameController = TextEditingController();
  final _roomDescriptionController = TextEditingController();
  final db = FireStoreDB();

  List<types.User> listUser = [];

  @override
  void initState() {
    db.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _roomNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Room Name"),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _roomDescriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Room Description'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AdaptiveButton(
                text: "Add Members",
                enabled: true,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AddMemberScreen.routeName,
                    arguments: AddMemberScreenArguments(
                      onPressd: (user) {
                        setState(() => listUser.add(user));
                      },
                      users: listUser,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              SingleChildScrollView(
                child: SizedBox(
                  height: 200,
                  child: listUser.isNotEmpty
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey.shade400,
                                child: Text(
                                  Utilities.getBackgroundWhenNotLoadImage(
                                    listUser[index].firstName!,
                                  ),
                                ),
                                foregroundImage: NetworkImage(
                                  listUser[index].imageUrl!,
                                ),
                              ),
                              title: Text(listUser[index].firstName!),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() => listUser.removeAt(index));
                                },
                              ),
                            );
                          },
                          itemCount: listUser.length,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
          AdaptiveButton(
            text: "Create",
            enabled: true,
            onPressed: () {
              db.createGroupRoom(
                roomName: _roomNameController.text,
                roomDescription: _roomDescriptionController.text,
                users: listUser,
              );
            },
          )
        ],
      ),
    );
  }
}
