import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/widgets/loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final _authservice =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "WhaleChat",
          style:
              TextStyle(fontFamily: "Akaya", color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await _authservice.signOut();
              })
        ],
      ),
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.teal[700],
              child: Column(children: [])),
          loading ? load() : SizedBox(height: 0.0)
        ],
      ),
    );
  }
}
