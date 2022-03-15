import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/gen/assets.gen.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/services/firebase/storage_service.dart';
import 'package:flutter_chatapp/views/widgets/adaptive_button.dart';
import 'package:image_picker/image_picker.dart';

class EditRoomBody extends StatefulWidget {
  const EditRoomBody({
    Key? key,
    required this.room,
  }) : super(key: key);

  final DocumentSnapshot<Object?> room;

  @override
  State<EditRoomBody> createState() => _EditRoomBodyState();
}

class _EditRoomBodyState extends State<EditRoomBody> {
  final _roomNameController = TextEditingController();
  final _roomDescriptionController = TextEditingController();
  final db = FireStoreDB();
  final _storage = StorageService();

  bool _isLoading = false;
  bool _validate = true;

  File? _image;
  String? _fileName;

  @override
  void initState() {
    db.initialize();
    _roomNameController.text = widget.room.get("name");
    _roomDescriptionController.text = widget.room.get("description") ?? '';
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
                              child: (widget.room.get("imageUrl") == null)
                                  ? Assets.images.placeholderGroupImage.image()
                                  : Image.network(widget.room.get("imageUrl")!),
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
              ],
            ),
          ),
          AdaptiveButton(
            text: "Save",
            enabled: _validate,
            isLoading: _isLoading,
            onPressed: _validate
                ? () async {
                    if (_validate) {
                      setState(() => _isLoading = true);

                      if (_image != null && _fileName != null) {
                        await _storage
                            .uploadFile(fileName: _fileName!, file: _image!)
                            .then((uri) {
                          db.updateGroupRoom(
                            roomId: widget.room.id,
                            roomName: _roomNameController.text,
                            roomDescription: _roomDescriptionController.text,
                            imageUrl: uri,
                          );
                        });
                      } else {
                        await db.updateGroupRoom(
                          roomId: widget.room.id,
                          roomName: _roomNameController.text,
                          roomDescription: _roomDescriptionController.text,
                          imageUrl: widget.room.get("imageUrl"),
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
