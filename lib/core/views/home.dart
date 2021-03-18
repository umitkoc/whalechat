import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/userservice.dart';
import 'package:whalechat/core/views/message.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  bool loading = false;
  int index = 0;
  String _code;
  bool username = false;

  @override
  void initState() {
    super.initState();
  }

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
                        onPressed: () => close())
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
          _messagelist(),
          _userlist(_formkey),
          profiledemo(context),
        ]);
  }

  ListView _messagelist() {
    return ListView(
      children: [
        _usermessage(),
        _usermessage(),
        _usermessage(),
        _usermessage(),
      ],
    );
  }

  ListView _userlist(GlobalKey<FormState> _formkey) {
    return ListView(children: [
      _formfriendsearch(_formkey),
      // ignore: todo
      //TODO:here add stream--->user list
      _user()
    ]);
  }

  Widget profiledemo(BuildContext context) {
    return ListView(children: [
      Stack(alignment: Alignment.bottomRight, children: [
        Container(
          width: double.infinity,
          height: 300.0,
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage("assets/images/logo.png"))),
        ),
        Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.amber,
            ),
            child: IconButton(icon: Icon(Icons.image), onPressed: () => null))
      ]),
      Column(children: [
        SizedBox(height: 10.0),
        GestureDetector(
          onTap: () {
            setState(() {
              username = true;
            });
          },
          child: Form(
              child: TextFormField(
                  enabled: username,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            setState(() {
                              username = false;
                            });
                          }),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      hintText: "Username:demo123"))),
        ),
        SizedBox(height: 10.0),
        Form(
            child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                    hintText: "Email:demo@gmail.com"))),
        SizedBox(height: 10.0),
        Form(
            child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                    hintText: "Code:XA12c8a"))),
      ])
    ]);
  }

  Widget _formfriendsearch(GlobalKey<FormState> _formkey) {
    return Form(
      key: _formkey,
      child: TextFormField(
          validator: (String value) =>
              value.trim().isEmpty ? "error empty code!" : null,
          onSaved: (String value) => _code = value.trim(),
          maxLength: 8,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (_formkey.currentState.validate()) {
                      _formkey.currentState.save();
                      print(_code);
                      //ignore:todo
                      //TODO: buraya code ile kullanıcı çağıracak
                    }
                  }),
              hintText: "Search Code")),
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
            trailing: IconButton(icon: Icon(Icons.add), onPressed: () {})));
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
        return ListView();
      },
    );
  }
}
