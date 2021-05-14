import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/models/usermodel.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/userservice.dart';
import 'package:whalechat/core/widgets/loading.dart';
import 'package:whalechat/core/widgets/user_card.dart';

userlist(BuildContext context) {
  String id =
      Provider.of<FirebaseAuthService>(context, listen: false).activeuserid;
  return ListView(
    children: [SizedBox(height: 20), form(context, id), userslist(id)],
  );
}

Container userslist(String id) {
  return Container(
    width: double.infinity,
    height: 480,
    child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseUserService().getUsers(id: id),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            List<String> users = snapshots.data.docs.map((e) => e.id).toList();
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<UserModel>(
                      future: FirebaseUserService().getUser(id: users[index]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          UserModel user = snapshot.data;
                          return UserCard(
                            avatar: user.avatar,
                            friendId: user.id,
                            id: id,
                            username: user.username,
                          );
                        }
                        return load();
                      });
                });
          }
          return load();
        }),
  );
}

Future<void> dialog(
    BuildContext context, List<UserModel> model, String id) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alertDialog(context, model, id);
      });
}

AlertDialog alertDialog(
    BuildContext context, List<UserModel> model, String id) {
  return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      content: ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(model[0].avatar)),
          title: Text(model[0].username, style: TextStyle(fontSize: 12)),
          trailing: Container(
              width: 100,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                IconButton(
                    icon: Icon(Icons.add, size: 15),
                    onPressed: () async {
                      await FirebaseUserService()
                          .addFriend(userId: id, friendId: model[0].id);
                      await FirebaseUserService().addHistory(
                          id: id,
                          state: "${model[0].username} ile arkadaş oldum");
                      model.clear();
                      Navigator.pop(context);
                    }),
                IconButton(
                    icon: Icon(Icons.clear_outlined, size: 15),
                    onPressed: () {
                      model.clear();
                      Navigator.pop(context);
                    })
              ]))));
}

Widget form(context, String id) {
  List<UserModel> model;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Form(
        key: _formkey,
        child: TextFormField(
          maxLength: 7,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (_formkey.currentState.validate()) {
                      _formkey.currentState.save();
                      if (model != null) {
                        dialog(context, model, id);
                      }
                    }
                  })),
          validator: (String value) {
            if (value.trim().length < 7) {
              return "lütfen istenilen kodu giriniz";
            }
            return null;
          },
          onSaved: (String value) async {
            model =
                await FirebaseUserService().getCode(code: value.trim(), id: id);
          },
        )),
  );
}
