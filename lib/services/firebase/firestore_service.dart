import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chatapp/utils/utilities.dart';
import 'package:http/http.dart' as http;

class FireStoreDB {
  late FirebaseFirestore firestore;
  initialize() => firestore = FirebaseFirestore.instance;

  Future<void> createUser(
    types.User user, {
    required String email,
    required String fcmToken,
  }) async {
    await firestore.collection("users").doc(user.id).set({
      'createdAt': FieldValue.serverTimestamp(),
      'displayName': user.firstName,
      'email': email,
      'fcmToken': [fcmToken],
      'imageUrl': user.imageUrl,
      'uid': user.id,
      'keywords': Utilities.generateKeywords(user.firstName!),
    });
  }

  Future<QuerySnapshot> getUserByID(String id) async {
    return firestore.collection("users").where("uid", isEqualTo: id).get();
  }

  Stream<QuerySnapshot> getUserByName({
    String? searchKeyword,
    required int limit,
  }) {
    if (searchKeyword?.isNotEmpty == true) {
      return firestore
          .collection("users")
          .where("keywords", arrayContains: searchKeyword)
          .limit(limit)
          .snapshots();
    } else {
      return firestore.collection("users").limit(limit).snapshots();
    }
  }

  Future<void> createGroupRoom({
    String? imageUrl,
    required String roomName,
    required String roomDescription,
    required List<types.User> users,
  }) async {
    await firestore.collection("rooms").add({
      'createdAt': FieldValue.serverTimestamp(),
      'imageUrl': imageUrl,
      'name': roomName,
      'description': roomDescription,
      'updatedAt': FieldValue.serverTimestamp(),
      'users': [
        ...users.map((u) => u.id).toList(),
        FirebaseAuth.instance.currentUser!.uid
      ],
      'lastMessage': null,
      'lastSenderName': null,
      'lastMessageTime': null,
    });
  }

  Stream<QuerySnapshot> room() {
    final fu = FirebaseAuth.instance.currentUser;

    if (fu == null) return const Stream.empty();

    return firestore
        .collection("rooms")
        .where("users", arrayContains: fu.uid)
        .orderBy("lastMessageTime", descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> getRoomByID(String id) {
    return firestore.collection("rooms").doc(id).snapshots();
  }

  Stream<List<types.Message>> messages(
    types.Room room, {
    int? limit,
  }) {
    var query = firestore
        .collection('rooms/${room.id}/messages')
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map(
      (snapshot) {
        return snapshot.docs.fold<List<types.Message>>(
          [],
          (previousValue, doc) {
            final data = doc.data();
            final author = room.users.firstWhere(
              (u) => u.id == data['author']['id'],
              orElse: () => types.User(
                id: data['id'] as String,
                firstName: data['firstName'],
                imageUrl: data['imageUrl'],
              ),
            );

            data['author'] = author.toJson();
            data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
            data['id'] = doc.id;
            data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

            return [...previousValue, types.Message.fromJson(data)];
          },
        );
      },
    );
  }

  void sendMessage(dynamic partialMessage, String roomId) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) return;

    types.Message? message;

    if (partialMessage is types.PartialCustom) {
      message = types.CustomMessage.fromPartial(
        author: types.User(
          id: firebaseUser.uid,
          firstName: firebaseUser.displayName,
          imageUrl: firebaseUser.photoURL,
        ),
        id: '',
        partialCustom: partialMessage,
      );
    } else if (partialMessage is types.PartialFile) {
      message = types.FileMessage.fromPartial(
        author: types.User(
          id: firebaseUser.uid,
          firstName: firebaseUser.displayName,
          imageUrl: firebaseUser.photoURL,
        ),
        id: '',
        partialFile: partialMessage,
      );
    } else if (partialMessage is types.PartialImage) {
      message = types.ImageMessage.fromPartial(
        author: types.User(
          id: firebaseUser.uid,
          firstName: firebaseUser.displayName,
          imageUrl: firebaseUser.photoURL,
        ),
        id: '',
        partialImage: partialMessage,
      );
    } else if (partialMessage is types.PartialText) {
      message = types.TextMessage.fromPartial(
        author: types.User(
          id: firebaseUser.uid,
          firstName: firebaseUser.displayName,
          imageUrl: firebaseUser.photoURL,
        ),
        id: '',
        partialText: partialMessage,
      );
    }

    if (message != null) {
      final messageMap = message.toJson();
      messageMap['createdAt'] = FieldValue.serverTimestamp();
      await firestore.collection('rooms/$roomId/messages').add(messageMap);

      Map<String, dynamic> lastMessageMap = {
        'lastMessage': messageMap['text'],
        'lastSenderName': messageMap['author']['firstName'],
        'lastMessageTime': messageMap['createdAt']
      };

      await firestore.collection('rooms').doc(roomId).update(lastMessageMap);

      firestore
          .collection('rooms')
          .doc(roomId)
          .get()
          .then((doc) => doc['name'])
          .then((name) {
        pushNotification(
          roomID: roomId,
          message: messageMap['text'],
          roomName: name,
        );
      });
    }
  }

  pushNotification({
    required String roomID,
    required String roomName,
    required String message,
  }) {
    firestore.collection('rooms').doc(roomID).get().then((room) {
      room['users'].forEach((userID) {
        if (userID != FirebaseAuth.instance.currentUser!.uid) {
          firestore.collection('users').doc(userID).get().then((user) {
            user['fcmToken']?.forEach((token) {
              sendPushNotification(
                token: token,
                roomName: roomName,
                message: message,
              );
            });
          });
        }
      });
    });
  }

  sendPushNotification({
    required String token,
    required String roomName,
    required String message,
  }) async {
    final url = Uri.parse(
      'https://daingu-chatapp-firebase-admin.herokuapp.com/message/send',
    );

    Map<String, String> header = {"content-type": "application/json"};

    String json = jsonEncode({
      'token': token,
      'type': {
        "notification": {
          "title": "New Message from $roomName",
          "body": message,
        },
        "data": {"route": "/home"}
      }
    });

    await http.post(url, headers: header, body: json);
  }

  void updateMessage(types.Message message, String roomId) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) return;

    if (message.author.id != firebaseUser.uid) return;

    final messageMap = message.toJson();
    messageMap.removeWhere(
      (key, value) => key == 'author' || key == 'createdAt' || key == 'id',
    );
    messageMap['authorId'] = message.author.id;
    messageMap['updatedAt'] = FieldValue.serverTimestamp();

    await firestore
        .collection('rooms/$roomId/messages')
        .doc(message.id)
        .update(messageMap);
  }

  Future<void> leaveRoom(
      {required types.User user, required String roomId}) async {
    await firestore.collection('rooms').doc(roomId).update(
      {
        "users": FieldValue.arrayRemove([user.id])
      },
    );
  }

  Future<void> addMembersToRoom(
      {required String roomId, List<types.User>? users}) async {
    await firestore.collection("rooms").doc(roomId).update(
      {
        "users": FieldValue.arrayUnion([...?users?.map((u) => u.id).toList()]),
      },
    );
  }

  Future<bool> isExistInRoom({
    required String roomId,
    required String? userId,
  }) async {
    if (userId != null) {
      var snapshot = await firestore.collection("rooms").doc(roomId).get();
      for (var u in snapshot.get("users")) {
        if (u == userId) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> updateGroupRoom({
    required String roomId,
    required String roomName,
    required String roomDescription,
    String? imageUrl,
  }) async {
    await firestore.collection("rooms").doc(roomId).update(
      {
        "name": roomName,
        "description": roomDescription,
        "imageUrl": imageUrl,
      },
    );
  }
}
