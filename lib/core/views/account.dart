import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/models/usermodel.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/userservice.dart';
import 'package:whalechat/core/widgets/loading.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final PageController _controller = PageController();
  String _email, _password, _username;
  bool loading = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Stack(
        children: [bodys(), loading ? load() : SizedBox(height: 0.0)],
      ),
    );
  }

  Widget bodys() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.teal,
      child: Column(
        children: [
          logoimage(),
          logotitle(),
          form(),
        ],
      ),
    );
  }

  Widget form() {
    final _serviceauth =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return Expanded(
        flex: 3,
        child: PageView(
            physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            controller: _controller,
            scrollDirection: Axis.horizontal,
            children: [
              login(_serviceauth),
              register(_serviceauth),
              forgot(_serviceauth)
            ]));
  }

  Widget logotitle() {
    return Text(
      "WhaleChat",
      style:
          TextStyle(color: Colors.white, fontSize: 42.0, fontFamily: "Akaya"),
    );
  }

  Widget logoimage() {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage("assets/images/logo.png"))),
      ),
    );
  }

///////////////login widget
  Widget login(FirebaseAuthService service) {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: _formkey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                    validator: (String value) {
                      if (!value.contains("@gmail.com") ||
                          value.trim().isEmpty) {
                        return "error email!";
                      }
                      return null;
                    },
                    onSaved: (String value) => _email = value.trim(),
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.amber, fontSize: 18),
                        prefixIcon: Icon(Icons.email)),
                    cursorColor: Colors.amber),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                    validator: (String value) => value.trim().length < 8
                        ? "min 8 characters password"
                        : null,
                    onSaved: (String value) => _password = value.trim(),
                    style: TextStyle(fontSize: 24),
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.amber, fontSize: 18),
                        prefixIcon: Icon(Icons.email)),
                    cursorColor: Colors.amber),
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      _formkey.currentState.save();
                      setState(() {
                        loading = true;
                      });
                      await service.emailSignIn(
                          email: _email, password: _password);
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  icon: Icon(Icons.login),
                  label: Text("Login")),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber, onPrimary: Colors.black),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    UserModel user = await service.googleSign();

                    if (user != null) {
                      UserModel model =
                          await FirebaseUserService().getUser(id: user.id);
                      if (model == null) {
                        await FirebaseUserService().usercreate(
                            avatar: user.avatar,
                            email: user.email,
                            username: user.username,
                            id: user.id);
                      }
                    }
                    if (mounted) {
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  icon: Icon(Icons.login_outlined),
                  label: Text("Google")),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.jumpToPage(1);
                    });
                  },
                  icon: Icon(Icons.account_box),
                  label: Text("Register")),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _controller.jumpToPage(2);
                    });
                  },
                  child: Text("Forgot Password",
                      style: TextStyle(color: Colors.amber)))
            ],
          )),
    );
  }

/////////////register widget
  Widget register(FirebaseAuthService service) {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: _formkey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                    validator: (String value) => value.trim().length < 5
                        ? "username min 5 character"
                        : null,
                    onSaved: (String value) => _username = value.trim(),
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        hintText: "Username",
                        hintStyle: TextStyle(color: Colors.amber, fontSize: 18),
                        prefixIcon: Icon(Icons.account_circle)),
                    cursorColor: Colors.amber),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                    validator: (String value) {
                      if (!value.contains("@gmail.com") ||
                          value.trim().isEmpty) {
                        return "error email!";
                      }
                      return null;
                    },
                    onSaved: (String value) => _email = value.trim(),
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.amber, fontSize: 18),
                        prefixIcon: Icon(Icons.email)),
                    cursorColor: Colors.amber),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                    validator: (String value) => value.trim().length < 8
                        ? "min 8 characters password"
                        : null,
                    onSaved: (String value) => _password = value.trim(),
                    style: TextStyle(fontSize: 24),
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.amber, fontSize: 18),
                        prefixIcon: Icon(Icons.email)),
                    cursorColor: Colors.amber),
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      _formkey.currentState.save();

                      UserModel user = await service.emailSignUp(
                          email: _email, password: _password);
                      if (user != null) {
                        FirebaseUserService().usercreate(
                          id: user.id,
                          email: _email,
                          username: _username,
                          avatar: "",
                        );
                      }
                      if (mounted) {
                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  },
                  icon: Icon(Icons.account_box),
                  label: Text("Sign up")),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black, onPrimary: Colors.white),
                  onPressed: () async {
                    setState(() {
                      _controller.jumpToPage(0);
                    });
                  },
                  icon: Icon(Icons.arrow_back_ios_sharp),
                  label: Text("Back")),
            ],
          )),
    );
  }

///////////////forgot widget
  Widget forgot(FirebaseAuthService service) {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: _formkey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                    validator: (String value) {
                      if (!value.contains("@gmail.com") ||
                          value.trim().isEmpty) {
                        return "error email!";
                      }
                      return null;
                    },
                    onSaved: (String value) => _email = value.trim(),
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.amber, fontSize: 18),
                        prefixIcon: Icon(Icons.email)),
                    cursorColor: Colors.amber),
              ),
              Text(
                "Please check the link to your gmail account after the transaction.",
                style: TextStyle(color: Colors.amber),
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      _formkey.currentState.save();
                      setState(() {
                        loading = true;
                      });
                      await service.resetpassword(email: _email);
                      setState(() {
                        loading = false;
                        _controller.jumpToPage(0);
                      });
                    }
                  },
                  icon: Icon(Icons.account_box),
                  label: Text("Reset Password")),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black, onPrimary: Colors.white),
                  onPressed: () {
                    setState(() {
                      _controller.jumpToPage(0);
                    });
                  },
                  icon: Icon(Icons.arrow_back_ios_sharp),
                  label: Text("Back")),
            ],
          )),
    );
  }
/////////////
}
