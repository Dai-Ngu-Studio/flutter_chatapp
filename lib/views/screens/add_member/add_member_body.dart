import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/constants.dart';
import 'package:flutter_chatapp/services/firebase/firestore_service.dart';
import 'package:flutter_chatapp/utils/debouncer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chatapp/utils/utilities.dart';

class AddMemberBody extends StatefulWidget {
  const AddMemberBody({Key? key, required this.onPressed, required this.users})
      : super(key: key);

  final Function onPressed;
  final List<types.User> users;

  @override
  State<AddMemberBody> createState() => _AddMemberBodyState();
}

class _AddMemberBodyState extends State<AddMemberBody> {
  final int _limit = 20;
  String _textSearch = "";
  bool isLoading = false;

  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();
  TextEditingController searchBarTec = TextEditingController();
  FireStoreDB db = FireStoreDB();

  @override
  void initState() {
    db.initialize();
    super.initState();
  }

  @override
  void dispose() {
    btnClearController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          buildSearchBar(),
          StreamBuilder<QuerySnapshot>(
            stream: db.getUserByName(limit: _limit, searchKeyword: _textSearch),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if ((snapshot.data?.docs.length ?? 0) > 0) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height -
                          kToolbarHeight -
                          105.2,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return buildItem(context, snapshot.data?.docs[index]);
                        },
                        itemCount: snapshot.data?.docs.length,
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text("No users found"));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.search, color: Colors.black, size: 20),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchBarTec,
              onChanged: (value) {
                searchDebouncer.run(() {
                  if (value.isNotEmpty) {
                    btnClearController.add(true);
                    setState(() {
                      _textSearch = value;
                    });
                  } else {
                    btnClearController.add(false);
                    setState(() {
                      _textSearch = "";
                    });
                  }
                });
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Search By Name',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          StreamBuilder<bool>(
              stream: btnClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchBarTec.clear();
                          btnClearController.add(false);
                          setState(() => _textSearch = "");
                        },
                        child: const Icon(
                          Icons.clear_rounded,
                          color: Colors.black,
                          size: 20,
                        ),
                      )
                    : const SizedBox.shrink();
              }),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade200,
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? document) {
    return document?['uid'].toString() != FirebaseAuth.instance.currentUser!.uid
        ? ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.shade400,
              child: Text(
                Utilities.getBackgroundWhenNotLoadImage(
                    document?['displayName']),
                style: const TextStyle(color: Colors.white),
              ),
              foregroundImage: NetworkImage(document?['imageUrl']),
            ),
            title:
                Text(document?['displayName'], overflow: TextOverflow.ellipsis),
            subtitle: Text(document?['email'], overflow: TextOverflow.ellipsis),
            onTap: () {
              if (widget.users
                  .every((element) => element.id != document?['uid'])) {
                widget.onPressed(types.User(
                  id: document?['uid'],
                  firstName: document?['displayName'],
                  imageUrl: document?['imageUrl'],
                ));
                Navigator.pop(context);
              } else {
                const snackBar = SnackBar(
                  content: Text("This member has added to group"),
                  duration: Duration(seconds: 5),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          )
        : const SizedBox.shrink();
  }
}
