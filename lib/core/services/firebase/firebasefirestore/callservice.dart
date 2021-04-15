import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class CallService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> startCall(
      {String userId, String friendId, String avatar, String username}) async {
    var rng = new Random();
    _firestore.collection("call").doc(friendId).set({
      "id": userId,
      "avatar": avatar,
      "username": username,
      "state": false,
      "channeldId": rng.nextInt(999999999).toString()
    });
  }

  Future<void> endCall({String userId}) async {
    await _firestore.collection("call").doc(userId).delete();
  }

  Stream<DocumentSnapshot> getCall({String userId}) {
    return _firestore.collection("call").doc(userId).snapshots();
  }

  Future<void> answerCall({String userId}) async {
    return _firestore.collection("call").doc(userId).update({"state": true});
  }
}
