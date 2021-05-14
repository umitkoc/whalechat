import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/models/usermodel.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/messageservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/userservice.dart';
import 'package:whalechat/core/widgets/loading.dart';
import 'package:whalechat/core/widgets/user_card.dart';

Widget messagelist(BuildContext context) {
  String userId =
      Provider.of<FirebaseAuthService>(context, listen: false).activeuserid;
  return StreamBuilder<QuerySnapshot>(
      stream: MessageService().getMessages(id: userId),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          List<String> users = snapshot.data.docs.map((e) => e.id).toList();
          List<DocumentSnapshot> usermessage = snapshot.data.docs.toList();
          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                return FutureBuilder<UserModel>(
                    future: FirebaseUserService().getUser(id: users[index]),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        UserModel user = snapshot.data;
                        return UserCard(
                            avatar: user.avatar,
                            friendId: user.id,
                            id: userId,
                            username: user.username,
                            value: usermessage[index].data()["value"]);
                      }
                      return load();
                    });
              });
        }
        return load();
      });
}
