import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whalechat/core/models/randomcode.dart';
import 'package:whalechat/core/models/usermodel.dart';

class FirebaseUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateTime date = new DateTime.now();

  Future<void> usercreate(
      {String email, String username, String id, String avatar = ""}) async {
    await _firestore.collection("user").doc(id).set({
      "email": email,
      "username": username,
      "create_date": date,
      "avatar": avatar,
      "code": RandomCode().getRandomString(7),
      "about": "hello whalechat app ❤️"
    });
    await addHistory(id: id, state: "uygulamaya kayıt oldum");
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

  Stream<QuerySnapshot> getUsers({String id}) =>
      _firestore.collection("user").doc(id).collection("users").snapshots();

  Future<List<UserModel>> getCode({String code, String id}) async {
    QuerySnapshot snapshot = await _firestore
        .collection("user")
        .where("code", isEqualTo: code)
        .get();

    if (snapshot.docs.isNotEmpty) {
      List<UserModel> model = snapshot.docs
          .map((e) => UserModel.createfirebasedocument(e))
          .toList();
      if (model[0].id != id) {
        return model;
      }
    }
    return null;
  }

  Future<void> addFriend({String userId, String friendId}) async {
    if (userId != friendId) {
      await _firestore
          .collection("user")
          .doc(userId)
          .collection("users")
          .doc(friendId)
          .set({});
      await _firestore
          .collection("user")
          .doc(friendId)
          .collection("users")
          .doc(userId)
          .set({});
      await _firestore.collection("user").doc(friendId).update({
        "code": RandomCode().getRandomString(7),
      });
    }
  }

  Future<void> usernameUpdate({String id, String username}) async {
    await _firestore.collection("user").doc(id).update({"username": username});
    await addHistory(
        id: id, state: "kullanıcı adımı $username olarak değiştirdim");
  }

  Future<void> profileUpdate({String url, String id}) async {
    await _firestore.collection("user").doc(id).update({"avatar": url});
    await addHistory(id: id, state: "profilimi değiştirdim");
  }

  Future<void> addHistory({String state, String id}) async {
    await _firestore
        .collection("user")
        .doc(id)
        .collection("history")
        .add({"state": state, "date": date});
  }

  Stream<QuerySnapshot> getHistory({String id}) => _firestore
      .collection("user")
      .doc(id)
      .collection("history")
      .orderBy("date")
      .snapshots();
}
