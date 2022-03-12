import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreDB {
  late FirebaseFirestore firestore;
  initialize() => firestore = FirebaseFirestore.instance;
}
