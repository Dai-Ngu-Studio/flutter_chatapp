import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chatapp/gen/assets.gen.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/services/firebase/storage_service.dart';
import 'package:flutter_chatapp/utils/utilities.dart';
import 'package:flutter_chatapp/views/screens/add_member/add_member_screen.dart';
import 'package:flutter_chatapp/views/widgets/adaptive_button.dart';
import 'package:image_picker/image_picker.dart';

class AddRoomBody extends StatefulWidget {
  const AddRoomBody({Key? key}) : super(key: key);

  @override
  State<AddRoomBody> createState() => _AddRoomBodyState();
}

class _AddRoomBodyState extends State<AddRoomBody> {
  final _roomNameController = TextEditingController();
  final _roomDescriptionController = TextEditingController();
  final db = FireStoreDB();
  final _storage = StorageService();

  bool _isLoading = false;
  bool _validate = false;

  List<types.User> listUser = [];
  File? _image;
  String? _fileName;

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Material(
                    child: InkWell(
                      onTap: _handleImageSelection,
                      child: _image == null
                          ? CircleAvatar(
                              radius: 50,
                              child:
                                  Assets.images.placeholderGroupImage.image(),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              child: const Icon(
                                Icons.group,
                                color: Colors.white,
                                size: 30,
                              ),
                              foregroundImage: FileImage(_image!),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                        isUpdate: false,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.32,
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

                      if (_image != null && _fileName != null) {
                        await _storage
                            .uploadFile(fileName: _fileName!, file: _image!)
                            .then((uri) {
                          db.createGroupRoom(
                            roomName: _roomNameController.text,
                            roomDescription: _roomDescriptionController.text,
                            users: listUser,
                            imageUrl: uri,
                          );
                        });
                      } else {
                        await db.createGroupRoom(
                          roomName: _roomNameController.text,
                          roomDescription: _roomDescriptionController.text,
                          users: listUser,
                        );
                      }

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

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      setState(() {
        _image = File(result.path);
        _fileName = result.name;
      });
    }
  }
}
