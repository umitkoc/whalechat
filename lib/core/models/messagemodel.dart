import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String value;
  final Timestamp date;
  final String userid;

  MessageModel({this.id, this.value, this.date, this.userid});

  factory MessageModel.createdocument(DocumentSnapshot snapshot) {
    return MessageModel(
        id: snapshot.id,
        date: snapshot.data()["date"],
        userid: snapshot.data()["userid"],
        value: snapshot.data()["value"]);
  }
}
