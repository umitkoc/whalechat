import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessage({String userId, String friendId}) =>
      _firebase
          .collection("user")
          .doc(userId)
          .collection("message")
          .doc(friendId)
          .collection("messages")
          .orderBy("date")
          .snapshots();

  Future<void> createMessage(
      {String value, String userId, String friendId, String username}) async {
    var date = Timestamp.now();
    await _firebase
        .collection("user")
        .doc(userId)
        .collection("message")
        .doc(friendId)
        .collection("messages")
        .add({
      "userid": userId,
      "value": value,
      "date": date,
      "username": username
    });
    await _firebase
        .collection("user")
        .doc(userId)
        .collection("message")
        .doc(friendId)
        .set({"value": value, "username": username});
    await _firebase
        .collection("user")
        .doc(friendId)
        .collection("message")
        .doc(userId)
        .collection("messages")
        .add({
      "userid": userId,
      "value": value,
      "date": date,
      "username": username
    });
    await _firebase
        .collection("user")
        .doc(friendId)
        .collection("message")
        .doc(userId)
        .set({"value": value, "username": username});
  }

  Stream<QuerySnapshot> getMessages({String id}) =>
      _firebase.collection("user").doc(id).collection("message").snapshots();
}
