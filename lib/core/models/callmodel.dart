import 'package:cloud_firestore/cloud_firestore.dart';

class CallModel {
  final String id;
  final String avatar;
  final String username;
  final String channelId;

  CallModel({this.id, this.avatar, this.username, this.channelId});

  factory CallModel.createfirebase(DocumentSnapshot snapshot) => CallModel(
      avatar: snapshot.data()["avatar"],
      channelId: snapshot.data()["channelId"],
      id: snapshot.data()["id"],
      username: snapshot.data()["username"]);
}
