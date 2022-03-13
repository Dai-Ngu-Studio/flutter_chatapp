import 'package:cloud_firestore/cloud_firestore.dart';
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
      'members': users?.map((u) => u.id).toList(),
    });
  }
}
