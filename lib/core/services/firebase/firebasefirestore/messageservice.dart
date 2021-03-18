import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessage(String userid, String seconduserid) {
    return _firebase
        .collection("message")
        .doc(userid)
        .collection(seconduserid)
        .orderBy("date")
        .snapshots();
  }

  Future<void> createMessage(
      String value, String userid, String seconduserid,String username)  async{
    await _firebase.collection("message").doc(userid).collection(seconduserid).add({
      "userid":userid,
      "value":value,
      "date":Timestamp.now(),
      "username":username
    });
  }
}
