import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String value;
  final Timestamp date;
  final String userid;
  final String username;

  MessageModel({this.id, this.username, this.value, this.date, this.userid});

  factory MessageModel.createdocument(DocumentSnapshot snapshot) =>
      MessageModel(
          id: snapshot.id,
          date: snapshot.data()["date"],
          userid: snapshot.data()["userid"],
          value: snapshot.data()["value"],
          username: snapshot.data()["username"]);
}
