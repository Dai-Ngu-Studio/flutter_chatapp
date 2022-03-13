import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chatapp/utils/utilities.dart';

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
      'fcmToken': fcmToken,
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
    List<types.User>? users,
  }) async {
    await firestore.collection("rooms").add({
      'createdAt': FieldValue.serverTimestamp(),
      'imageUrl': imageUrl,
      'name': roomName,
      'description': roomDescription,
      'updatedAt': FieldValue.serverTimestamp(),
      'users': [
        ...?users?.map((u) => u.id).toList(),
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

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
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
    }
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
}
