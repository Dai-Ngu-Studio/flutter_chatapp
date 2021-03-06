import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/views/screens/chat_room/chat_room_screen.dart';
import 'package:flutter_chatapp/views/screens/home/components/room_box.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  FireStoreDB db = FireStoreDB();

  @override
  void initState() {
    db.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                chatappColor.shade50.withOpacity(0.6),
                chatappColor.shade50,
                chatappColor.shade100
              ],
              stops: const [0, 0.4, 0.9, 1],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 56),
          child: StreamBuilder<QuerySnapshot>(
            stream: db.room(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    bottom: 200,
                  ),
                  child: const Text('No rooms'),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    final room = snapshot.data!.docs[index];

                    List<types.User> users = [];

                    for (var i = 0; i < room['users'].length; i++) {
                      db.getUserByID(room['users'][i]).then((value) {
                        final List<DocumentSnapshot> documents = value.docs;

                        users.add(
                          types.User(
                            id: documents[0]['uid'],
                            firstName: documents[0]['displayName'],
                            imageUrl: documents[0]['imageUrl'],
                          ),
                        );
                      });
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ChatRoomScreen.routeName,
                          arguments: ChatRoomScreenArguments(
                            types.Room(
                              id: room.id,
                              users: room['users'],
                              name: room['name'],
                              imageUrl: room['imageUrl'],
                              type: types.RoomType.group,
                            ),
                          ),
                        );
                      },
                      child: RoomBox(
                        room: types.Room(
                          id: room.id,
                          users: users,
                          name: room['name'],
                          imageUrl: room['imageUrl'],
                          type: types.RoomType.group,
                        ),
                        lastMessageSender: room['lastSenderName'] ?? '',
                        lastMessage: room['lastMessage'] ?? '',
                        lastMessageTime: room['lastMessageTime'],
                      ),
                    );
                  },
                );
              }
            },
          ),
        )
      ],
    );
  }
}
