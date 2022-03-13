import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/views/screens/chat_room/chat_room_screen.dart';
import 'package:intl/intl.dart';

class RoomBox extends StatelessWidget {
  const RoomBox({
    Key? key,
    required this.roomID,
    required this.roomName,
    this.roomImage,
    required this.lastMessageSender,
    required this.lastMessage,
    required this.lastMessageTime,
  }) : super(key: key);

  final String roomID;
  final String roomName;
  final String? roomImage;
  final String? lastMessageSender;
  final String? lastMessage;
  final String? lastMessageTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Stack(
        children: [
          Container(
            height: 80,
            padding: kPadding,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.shade400,
                  child: Text(
                    getBackgroundWhenNotLoadImage("Dai Ngu"),
                    style: const TextStyle(color: Colors.white),
                  ),
                  foregroundImage: NetworkImage(
                    roomImage!,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      roomName,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    lastMessageSender!.isNotEmpty
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              children: [
                                WidgetSpan(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.55,
                                    ),
                                    child: Text(
                                      '$lastMessageSender: $lastMessage',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: lastMessageTime!.isNotEmpty
                                      ? ' • ${DateFormat('MMM yy').format(DateTime.fromMillisecondsSinceEpoch(int.parse(lastMessageTime!)))}'
                                      : '',
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.grey.withOpacity(0.15),
                  highlightColor: Colors.grey.withOpacity(0.1),
                  onTap: () {
                    Navigator.of(context).pushNamed(ChatRoomScreen.routeName);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getBackgroundWhenNotLoadImage(String roomName) {
    List<String> listRoomNameSplit = roomName.split(" ");

    String firstChar = listRoomNameSplit.first.substring(0, 1);
    String lastChar = listRoomNameSplit.last.substring(0, 1);

    return listRoomNameSplit.length == 1
        ? listRoomNameSplit.first.substring(0, 2).toUpperCase()
        : firstChar + lastChar;
  }
}
