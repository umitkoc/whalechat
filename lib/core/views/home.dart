import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/models/usermodel.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/userservice.dart';
import 'package:whalechat/core/views/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whalechat/core/widgets/loading.dart';

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

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("WhaleChat",
              style: TextStyle(
                  fontFamily: "Akaya", color: Colors.white, fontSize: 30)),
          centerTitle: true,
          actions: [
            index == 0
                ? IconButton(
                    color: Colors.amber,
                    icon: Icon(Icons.messenger_outline_sharp),
                    onPressed: () => null)
                : index == 1
                    ? Icon(Icons.supervisor_account_outlined,
                        color: Colors.amber)
                    : IconButton(
                        color: Colors.amber,
                        icon: Icon(Icons.close_rounded),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await _service.signOut();
                        })
          ]),
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
                          : NetworkImage(dizi["avatar"]))),
            )),
            Expanded(
              child: Column(
                children: [
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
                        label: Text("Save")),
                  )
                ],
              ),
            )
          ])),
    );
  }

  Widget _messagelist(String id) {
    //streambuilder ile kullanıcıların konuşma listesi gelecek
    return ListView(
      children: [
        _usermessage(),
        _usermessage(),
        _usermessage(),
        _usermessage(),
      ],
    );
  }

  Widget _usermessage() {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => Message())),
      child: Card(
          child: ListTile(
        autofocus: false,
        leading: CircleAvatar(
          backgroundColor: Colors.cyan,
        ),
        title: Text(
          "username",
          style: TextStyle(fontSize: 12),
        ),
        // ignore: todo
        //TODO: buraya en son atılan mesaj gösterilecek
        subtitle: Text("Message..."),
      )),
    );
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

  Widget addfriendcard(String id) {
    return Card(
        child: ListTile(
      leading: CircleAvatar(
        backgroundImage: dizi["avatar"].isEmpty
            ? AssetImage("assets/images/logo.png")
            : NetworkImage(dizi["avatar"]),
      ),
      title: Text('${dizi["username"]}'),
      trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            await FirebaseUserService()
                .addFriend(friendId: dizi["id"], userId: id);
            setState(() {
              loading = false;
              dizi["ok"] = "";
            });
          }),
    ));
  }

  Widget friendlist(String id) {
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
                        stream: FirebaseUserService().getUsers(id: id),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text("Error Code..."));
                          }
                          if (snapshot.hasData) {
                            List<String> users =
                                snapshot.data.docs.map((e) => e.id).toList();
                            return ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (_, index) {
                                  return FutureBuilder(
                                      future: FirebaseUserService()
                                          .getUser(id: users[index]),
                                      builder: (_, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(
                                              child: Text("no has data"));
                                        } else if (snapshot.hasData) {
                                          UserModel user = snapshot.data;
                                          return Card(
                                              child: GestureDetector(
                                                  onTap: () {
                                                    print(user.id);
                                                  },
                                                  child: ListTile(
                                                      leading: CircleAvatar(
                                                          backgroundImage: user
                                                                      .avatar ==
                                                                  ""
                                                              ? AssetImage(
                                                                  "assets/images/logo.png")
                                                              : NetworkImage(
                                                                  user.avatar)),
                                                      title: Text(
                                                          "${user.username}"))));
                                        }
                                        return Center(
                                            child: RefreshProgressIndicator());
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: RefreshProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: RefreshProgressIndicator());
          } else {
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
                        subtitle: Text(
                          "${user.username}",
                        )),
                    ListTile(
                        title: Text("email"),
                        subtitle: Text(
                          "${user.email}",
                        )),
                    ListTile(
                        title: Text("code"),
                        subtitle: Text(
                          "${user.code}",
                        )),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _pageController.jumpToPage(3);
                            });
                          },
                          icon: Icon(Icons.account_circle),
                          label: Text("Edit Profile")),
                    ),
                  ]))
            ]);
          }
        });
  }
}
