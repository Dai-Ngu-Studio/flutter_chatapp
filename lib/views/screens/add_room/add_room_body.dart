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

  bool _isLoading = false;
  bool _validate = false;

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
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                  child: TextField(
                    controller: _roomNameController,
                    maxLength: 30,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: const Text("Room Name"),
                      errorText: !_validate
                          ? "Room name is required and from 2-30 characters"
                          : null,
                    ),
                    onChanged: (value) {
                      if (_roomNameController.text.length < 2 ||
                          _roomNameController.text.length > 30) {
                        setState(() {
                          _validate = false;
                        });
                      } else {
                        setState(() {
                          _validate = true;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 70,
                  child: TextField(
                    controller: _roomDescriptionController,
                    maxLength: 100,
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
                        onPressed: (user) {
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
                    height: MediaQuery.of(context).size.height * 0.48,
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
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  foregroundImage: NetworkImage(
                                    listUser[index].imageUrl!,
                                  ),
                                ),
                                title: Text(listUser[index].firstName!),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close),
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
          ),
          AdaptiveButton(
            text: "Create Room",
            enabled: _validate && listUser.isNotEmpty,
            isLoading: _isLoading,
            onPressed: _validate && listUser.isNotEmpty
                ? () async {
                    if (_validate) {
                      setState(() => _isLoading = true);

                      await db.createGroupRoom(
                        roomName: _roomNameController.text,
                        roomDescription: _roomDescriptionController.text,
                        users: listUser,
                      );

                      setState(() => _isLoading = false);
                      Navigator.of(context).pop();
                    }
                  }
                : null,
          )
        ],
      ),
    );
  }
}
