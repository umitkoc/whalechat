import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/models/usermodel.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/userservice.dart';
import 'package:whalechat/core/widgets/boxdec_image.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _username;
  final formkey = GlobalKey<FormState>();

  String urlpath;

  @override
  Widget build(BuildContext context) {
    final String id =
        Provider.of<FirebaseAuthService>(context, listen: false).activeuserid;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (formkey.currentState.validate()) {
                formkey.currentState.save();
              }
            },
            child: Icon(Icons.save_outlined)),
        appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text("Profile",
                style: TextStyle(
                    fontFamily: "Akaya", color: Colors.white, fontSize: 25)),
            centerTitle: true),
        body: FutureBuilder<UserModel>(
            future: FirebaseUserService().getUser(id: id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserModel user = snapshot.data;
                return ListView(children: [
                  Card(
                      child: Stack(alignment: Alignment.bottomRight, children: [
                    ImageControl(avatar: user.avatar, heigth: 300),
                    IconButton(icon: Icon(Icons.image), onPressed: () => null)
                  ])),
                  username(user),
                  Card(
                      child: Container(
                          height: 50,
                          child: Center(child: Text("${user.email}")))),
                  Card(
                      child: Stack(alignment: Alignment.topRight, children: [
                    Container(
                        height: 200,
                        color: Colors.amber,
                        child: Center(
                            child: Text("${user.code}",
                                style: TextStyle(fontSize: 50)))),
                    IconButton(icon: Icon(Icons.copy), onPressed: () => null)
                  ]))
                ]);
              }
              return Center(child: RefreshProgressIndicator());
            }));
  }

  Card username(UserModel user) {
    return Card(
        child: Container(
            height: 50,
            child: Form(
              child: TextFormField(
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return "username not is empty";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _username = value.trim();
                  },
                  key: formkey,
                  maxLength: 20,
                  initialValue: "${user.username}",
                  decoration: InputDecoration(
                      hintText: "${user.username}",
                      icon: Icon(Icons.supervised_user_circle_rounded),
                      contentPadding: const EdgeInsets.all(10)),
                  keyboardType: TextInputType.emailAddress,
                  cursorHeight: 20),
            )));
  }
}
