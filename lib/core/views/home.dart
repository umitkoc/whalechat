import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/models/callmodel.dart';
import 'package:whalechat/core/models/usermodel.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/callservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/messageservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/userservice.dart';
import 'package:whalechat/core/validator/user/image.dart';
import 'package:whalechat/core/views/getcall.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whalechat/core/widgets/loading.dart';
import 'package:whalechat/core/widgets/user_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  final dizi = {"id": "", "username": "", "avatar": "", "ok": ""};
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _textcontroller = TextEditingController();
  bool loading;
  int index;
  String _code;
  bool username;

  @override
  void initState() {
    loading = username = false;
    index = 0;
    _code = "";
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _service = Provider.of<FirebaseAuthService>(context, listen: false);

    return StreamBuilder<DocumentSnapshot>(
        stream: CallService().getCall(userId: _service.activeuserid),
        builder: (_, snapshots) {
          if (snapshots.hasData && snapshots.data.exists) {
            CallModel call = CallModel.createfirebase(snapshots.data);
            return GetCall(
              id: snapshots.data.id,
              avatar: call.avatar,
              channelId: call.channelId,
              userId: call.id,
              username: call.username,
            );
          }
          return scaffoldHome(_service);
        });
  }

  Scaffold scaffoldHome(FirebaseAuthService _service) {
    return Scaffold(
      appBar: appBar(_service),
      body: Stack(
        alignment: Alignment.center,
        children: [
          bodys(context, _service.activeuserid),
          loading ? load() : SizedBox(height: 0.0)
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget appBar(FirebaseAuthService _service) {
    return AppBar(
        backgroundColor: Colors.teal,
        title: Text("WhaleChat",
            style: TextStyle(
                fontFamily: "Akaya", color: Colors.white, fontSize: 25)),
        centerTitle: true,
        actions: [
          index == 0
              ? IconButton(
                  color: Colors.amber,
                  icon: Icon(Icons.messenger_outline_sharp),
                  onPressed: () => null)
              : index == 1
                  ? Icon(Icons.supervisor_account_outlined, color: Colors.amber)
                  : IconButton(
                      color: Colors.amber,
                      icon: Icon(Icons.close_rounded),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        await _service.signOut();
                      })
        ]);
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (int value) {
        setState(() {
          index = value;
          _pageController.jumpToPage(value);
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "message"),
        BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account_outlined), label: "User"),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), label: "Profile"),
      ],
    );
  }

  Widget bodys(BuildContext context, String id) {
    return PageView(
        physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
        controller: _pageController,
        children: [
          _messagelist(id),
          _userlist(context, id),
          profile(context, id),
          editProfile(),
        ]);
  }

  Widget editProfile() {
    final GlobalKey<FormState> _formeditkey = GlobalKey<FormState>();
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _formeditkey,
            child: Column(children: [
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: dizi["avatar"] == ""
                                  ? AssetImage("assets/images/logo.png")
                                  : NetworkImage(dizi["avatar"]))))),
              Expanded(
                  child: Column(children: [
                SizedBox(height: 15.0),
                TextFormField(
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return "please username is not empty";
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    _code = value.trim();
                  },
                  keyboardType: TextInputType.emailAddress,
                  initialValue: "${dizi["username"]}",
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    hintText: 'username:',
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          if (_formeditkey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            _formeditkey.currentState.save();
                            _pageController.jumpToPage(2);
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        icon: Icon(Icons.save),
                        label: Text("Save")))
              ]))
            ])));
  }

  Widget _messagelist(String userId) {
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
                        return Text("");
                      });
                });
          }
          return Center(child: RefreshProgressIndicator());
        });
  }

  Widget _userlist(BuildContext context, String id) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 5),
        searchcode(id),
        friendlist(id),
      ],
    );
  }

  Widget searchcode(String id) {
    return Expanded(
        child: ListView(children: [
      searchform(),
      dizi["ok"].isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: addfriendcard(id),
            )
          : SizedBox(height: 20.0)
    ]));
  }

  Widget searchform() {
    return Form(
        key: _formkey,
        child: TextFormField(
            validator: (String value) {
              if (value.trim().length < 7) {
                return "please min 7 character code ";
              }
              return null;
            },
            onSaved: (String value) {
              _code = value.trim();
              _textcontroller.clear();
            },
            maxLength: 7,
            controller: _textcontroller,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    alignment: Alignment.center,
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        _formkey.currentState.save();
                        setState(() {
                          dizi["ok"] = "";
                          loading = true;
                        });
                        List<UserModel> model =
                            await FirebaseUserService().getCode(code: _code);
                        if (model != null) {
                          setState(() {
                            dizi["id"] = model[0].id;
                            dizi["avatar"] = model[0].avatar;
                            dizi["username"] = model[0].username;
                            dizi["code"] = _code;
                            dizi["ok"] = "ok";
                          });
                        }
                        setState(() {
                          loading = false;
                        });
                      }
                    }),
                hintText: "Code...",
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5)))));
  }

  Widget addfriendcard(String userId) {
    return Card(
        child: ListTile(
      leading: Avatar(avatar: dizi["avatar"]),
      title: Text('${dizi["username"]}'),
      trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            await FirebaseUserService()
                .addFriend(friendId: dizi["id"], userId: userId);
            setState(() {
              loading = false;
              dizi["ok"] = "";
            });
          }),
    ));
  }

  Widget friendlist(String userId) {
    return Expanded(
        flex: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Friends",
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseUserService().getUsers(id: userId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<String> users =
                                snapshot.data.docs.map((e) => e.id).toList();
                            return ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (_, index) {
                                  return FutureBuilder<UserModel>(
                                      future: FirebaseUserService()
                                          .getUser(id: users[index]),
                                      builder: (_, snapshot) {
                                        if (snapshot.hasData) {
                                          UserModel user = snapshot.data;
                                          return Card(
                                              child: UserCard(
                                            avatar: user.avatar,
                                            friendId: user.id,
                                            id: userId,
                                            username: user.username,
                                          ));
                                        }
                                        return Text("");
                                      });
                                });
                          }
                          return Center(child: RefreshProgressIndicator());
                        })))
          ],
        ));
  }

  Widget profile(BuildContext context, String id) {
    return FutureBuilder<UserModel>(
        future: FirebaseUserService().getUser(id: id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel user = snapshot.data;
            dizi["avatar"] = user.avatar;
            dizi["username"] = user.username;
            dizi["id"] = user.id;
            return Column(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: user.avatar == ""
                              ? AssetImage("assets/images/logo.png")
                              : NetworkImage(user.avatar))),
                ),
              ),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                    ListTile(
                        title: Text("username"),
                        subtitle: Text("${user.username}")),
                    ListTile(
                        title: Text("email"), subtitle: Text("${user.email}")),
                    ListTile(
                        title: Text("code"), subtitle: Text("${user.code}")),
                    Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _pageController.jumpToPage(3);
                              });
                            },
                            icon: Icon(Icons.account_circle),
                            label: Text("Edit Profile")))
                  ]))
            ]);
          }
          return Center(child: RefreshProgressIndicator());
        });
  }
}
