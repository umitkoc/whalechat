import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String avatar;
  final String username;
  final String code;
  final String email;

  UserModel({this.id, this.avatar, this.username, this.code, this.email});

  factory UserModel.createfirebasedocument(DocumentSnapshot snapshot) {
    return UserModel(
        id: snapshot.id,
        username: snapshot.data()['username'],
        email: snapshot.data()['email'],
        avatar: snapshot.data()['avatar'],
        code: snapshot.data()['code']);
  }

  factory UserModel.createfirebaseuser(User user) {
    return UserModel(
        id: user.uid,
        avatar: user.photoURL,
        email: user.email,
        username: user.displayName);
  }
}
