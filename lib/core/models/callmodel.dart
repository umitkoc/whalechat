import 'package:cloud_firestore/cloud_firestore.dart';

class CallModel {
  final String id;
  final String avatar;
  final String userId;

  CallModel({this.id, this.avatar, this.userId});

  factory CallModel.createdocument(DocumentSnapshot snapshot) {
    return CallModel(
        avatar: snapshot.data()["avatar"],
        id: snapshot.id,
        userId: snapshot.data()["userId"]);
  }
}
