import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/userservice.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  bool loading = false;
  int index = 0;
  // ignore: unused_field
  String _code;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("WhaleChat",
              style: TextStyle(
                  fontFamily: "Akaya", color: Colors.white, fontSize: 30)),
          centerTitle: true,
          actions: [
            index == 0
                ? Icon(Icons.message)
                : index == 1
                    ? Icon(Icons.supervisor_account_outlined)
                    : IconButton(
                        icon: Icon(Icons.settings), onPressed: () => close())
          ]),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: bodys(),
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

  Widget bodys() {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    return PageView(
        physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
        controller: _pageController,
        children: [
          // ignore: todo
          //TODO:here add stream --->message list
          ListView(
            children: [
              _user(),
              _user(),
              _user(),
              _user(),
            ],
          ),

          ListView(children: [
            Form(
              key: _formkey,
              child: TextFormField(
                  validator: (String value) =>
                      value.trim().isEmpty ? "error empty code!" : null,
                  onSaved: (String value) => _code = value.trim(),
                  maxLength: 8,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            if (_formkey.currentState.validate()) {
                              _formkey.currentState.save();
                              //ignore:todo
                              //TODO: buraya code ile kullanıcı çağıracak
                            }
                          }),
                      hintText: "Search Code")),
            ),
            // ignore: todo
            //TODO:here add stream--->user list
            _user()
          ]),

          // ignore:todo
          // TODO: here add profile---->profile
          Column(
            children: [],
          ),
        ]);
  }

  Widget _user() {
    return Card(
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
      trailing: Text(DateTime.now().toString().substring(10, 16)),
    ));
  }

  void close() async {
    final _authservice =
        Provider.of<FirebaseAuthService>(context, listen: false);
    setState(() {
      loading = true;
    });
    await _authservice.signOut();
  }

  void addfriends() {}

  Widget profile(BuildContext context) {
    return FutureBuilder(
      future: FirebaseUserService().getUser(id: ""),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: RefreshProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Center(child: RefreshProgressIndicator());
        }
        return ListView(
          
        );
      },
    );
  }
}
