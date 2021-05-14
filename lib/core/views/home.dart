import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/models/callmodel.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/callservice.dart';
import 'package:whalechat/core/views/getcall.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whalechat/core/views/profile.dart';
import 'package:whalechat/core/widgets/history.dart';
import 'package:whalechat/core/widgets/loading.dart';
import 'package:whalechat/core/widgets/messagelist.dart';
import 'package:whalechat/core/widgets/userlist.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  bool loading;
  int index;

  @override
  void initState() {
    loading = false;
    index = 0;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
      body: Stack(alignment: Alignment.center, children: [
        bodys(context, _service.activeuserid),
        loading ? load() : SizedBox(height: 0.0)
      ]),
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
                  icon: Icon(Icons.account_circle),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile())))
              : SizedBox(height: 0)
        ]);
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (int value) => setState(() {
        index = value;
        _pageController.jumpToPage(value);
      }),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "message"),
        BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account_outlined), label: "User"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "history"),
      ],
    );
  }

  Widget bodys(BuildContext context, String id) => PageView(
      controller: _pageController,
      children: [messagelist(context), userlist(context), history(context)]);
}
