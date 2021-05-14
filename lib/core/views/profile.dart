import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/models/usermodel.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/userservice.dart';
import 'package:whalechat/core/services/firebase/firebasestorage/storage.dart';
import 'package:whalechat/core/widgets/loading.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File files;
  var file;
  String username = "";
  TextEditingController _controller = TextEditingController();

  dialog(String id) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(children: [
            SimpleDialogOption(
                child: IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: () async {
                      Navigator.pop(context);
                      var image = await ImagePicker().getImage(
                          source: ImageSource.camera,
                          maxWidth: 800,
                          maxHeight: 600,
                          imageQuality: 80);
                      setState(() {
                        try {
                          file = File(image.path);
                        } catch (error) {
                          print(error);
                        }
                      });
                      if (file != null) {
                        await StorageService().addImage(image: file, id: id);
                      }
                    })),
            SimpleDialogOption(
                child: IconButton(
                    icon: Icon(Icons.file_present),
                    onPressed: () async {
                      Navigator.pop(context);
                      var image = await ImagePicker().getImage(
                          source: ImageSource.gallery,
                          maxWidth: 800,
                          maxHeight: 600,
                          imageQuality: 80);
                      setState(() {
                        try {
                          file = File(image.path);
                        } catch (error) {
                          print(error);
                        }
                      });
                      if (file != null) {
                        await StorageService().addImage(image: file, id: id);
                      }
                    }))
          ]);
        });
  }

  Future<void> edittext({String id, String username}) async {
    await FirebaseUserService().usernameUpdate(id: id, username: username);
  }

  Future<void> edit({String id, String username}) async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(children: [
            SimpleDialogOption(
                child: TextFormField(
                    controller: _controller,
                    maxLength: 20,
                    decoration: InputDecoration(
                        hintText: "$username", border: InputBorder.none))),
            SimpleDialogOption(
              child: ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      username = _controller.text.trim();
                    });
                    if (username != "") {
                      await FirebaseUserService()
                          .usernameUpdate(id: id, username: username);
                    }
                    _controller.clear();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.edit),
                  label: Text("Save")),
            )
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    var service = Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("WhaleChat",
              style: TextStyle(
                  fontFamily: "Akaya", color: Colors.white, fontSize: 25)),
          centerTitle: true,
          actions: [
            IconButton(
                color: Colors.amber,
                icon: Icon(Icons.close_rounded),
                onPressed: () async {
                  await service.signOut();
                  Navigator.pop(context);
                })
          ],
        ),
        body: FutureBuilder<UserModel>(
            future: FirebaseUserService().getUser(id: service.activeuserid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserModel model = snapshot.data;
                return Column(children: [
                  Expanded(
                      flex: 3,
                      child: Stack(alignment: Alignment.bottomRight, children: [
                        Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: file == null
                                        ? model.avatar == ""
                                            ? AssetImage(
                                                "assets/images/logo.png")
                                            : NetworkImage(model.avatar)
                                        : FileImage(file)))),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: IconButton(
                                icon: Icon(Icons.image,
                                    size: 50, color: Colors.amber),
                                onPressed: () {
                                  dialog(model.id);
                                }))
                      ])),
                  Expanded(
                      flex: 2,
                      child: Stack(alignment: Alignment.bottomRight, children: [
                        Container(
                            child: Card(
                                child: Center(
                                    child: Text(
                                        "${username == "" ? model.username : username}",
                                        style: TextStyle(fontSize: 40))))),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  await edit(
                                      id: model.id, username: model.username);
                                }))
                      ])),
                  Expanded(
                      flex: 2,
                      child: Stack(alignment: Alignment.topLeft, children: [
                        Container(
                            child: Card(
                                child: Center(
                                    child: Text("${model.code}",
                                        style: TextStyle(fontSize: 40))))),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(Icons.code, size: 30))
                      ])),
                  Expanded(
                      flex: 2,
                      child: Stack(alignment: Alignment.topLeft, children: [
                        Container(
                            child: Card(
                                child: Center(
                                    child: Text("${model.email}",
                                        style: TextStyle(fontSize: 30))))),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(Icons.mail, size: 30))
                      ]))
                ]);
              }
              return load();
            }));
  }
}
