import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';

class ChatRoomBody extends StatefulWidget {
  const ChatRoomBody({Key? key, required this.room}) : super(key: key);

  final types.Room room;

  @override
  State<ChatRoomBody> createState() => _ChatRoomBodyState();
}

class _ChatRoomBodyState extends State<ChatRoomBody> {
  final _user = FirebaseAuth.instance.currentUser;
  final db = FireStoreDB();

  @override
  void initState() {
    db.initialize();
    super.initState();
  }

  void _addMessage(types.Message message) {
    setState(() {
      db.sendMessage(message, widget.room.id);
    });
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: types.User(id: _user!.uid),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: types.User(id: _user!.uid),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    db.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    db.sendMessage(
      message,
      widget.room.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<types.Message>>(
      stream: db.messages(
        types.Room(
          id: widget.room.id,
          users: widget.room.users,
          type: widget.room.type,
        ),
        limit: 30,
      ),
      builder: (context, snapshot) {
        return Chat(
          showUserAvatars: true,
          showUserNames: true,
          theme: DefaultChatTheme(
            inputBackgroundColor: Colors.grey.shade100,
            userAvatarImageBackgroundColor: Colors.black12,
            inputBorderRadius: BorderRadius.circular(0),
            inputTextColor: Colors.black,
            attachmentButtonIcon: const Icon(Icons.attachment_rounded),
          ),
          messages: snapshot.data ?? [],
          onAttachmentPressed: _handleAtachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          user: types.User(id: _user!.uid),
        );
      },
    );
  }
}
