import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whalechat/core/models/randomcode.dart';
import 'package:whalechat/core/models/usermodel.dart';

class FirebaseUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateTime date = new DateTime.now();

  Future<void> usercreate(
      {String email, String username, String id, String avatar = ""}) async {
    await _firestore.collection("user").doc(id).set({
      "id": id,
      "email": email,
      "username": username,
      "create_date": date,
      "avatar": avatar,
      "code": RandomCode().getRandomString(7),
      "about": "hello whalechat app ❤️",
    });
  }

  Future<UserModel> getUser({String id}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection("user").doc(id).get();
    if (snapshot.exists) {
      UserModel user = UserModel.createfirebasedocument(snapshot);
      return user;
    }
    return null;
  }
}
