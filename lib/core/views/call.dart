import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/callservice.dart';
import 'package:whalechat/core/views/call_screen.dart';

class Call extends StatefulWidget {
  final String id;
  final String avatar;
  final String username;

  const Call({this.id, this.avatar, this.username});
  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: CallService().getCall(userId: this.widget.id),
        builder: (context, snapshots) {
          if (snapshots.hasData && snapshots.data.exists) {
            var snapshot = snapshots.data;
            if (snapshot.data()["state"]) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CallScreen(
                          userId: snapshot.id,
                          channelId: snapshot.data()["channelId"])));
            }
            return callscaffold(context);
          } else if (!snapshots.data.exists) {
            Navigator.of(context).pop();
          }
          return callscaffold(context);
        });
  }

  Scaffold callscaffold(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.teal,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                      repeat: ImageRepeat.noRepeat,
                                      fit: BoxFit.fitHeight,
                                      image: this.widget.avatar == ""
                                          ? AssetImage("assets/images/logo.png")
                                          : NetworkImage(this.widget.avatar)))),
                          Column(children: [
                            Container(
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50)),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red),
                                    onPressed: () async {
                                      await CallService()
                                          .endCall(userId: this.widget.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(Icons.call_end)))
                          ]),
                        ])))));
  }
}
