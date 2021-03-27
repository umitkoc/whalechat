import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessage({String userId, String friendId}) {
    return _firebase
        .collection("user")
        .doc(userId)
        .collection("users")
        .doc(friendId)
        .collection("message")
        .orderBy("date")
        .snapshots();
  }

  Future<void> createMessage(
      {String value, String userId, String friendId, String username}) async {
    var date = Timestamp.now();
    await _firebase
        .collection("user")
        .doc(userId)
        .collection("users")
        .doc(friendId)
        .collection("message")
        .add({
      "userid": userId,
      "value": value,
      "date": date,
      "username": username
    });
    await _firebase
        .collection("user")
        .doc(friendId)
        .collection("users")
        .doc(userId)
        .collection("message")
        .add({
      "userid": userId,
      "value": value,
      "date": date,
      "username": username
    });
  }
}
