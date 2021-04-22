import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/callservice.dart';
import 'package:whalechat/core/views/call_screen.dart';

class GetCall extends StatefulWidget {
  final String id;
  final String avatar;
  final String username;
  final String channelId;

  const GetCall({this.id, this.avatar, this.username, this.channelId});
  @override
  _GetCallState createState() => _GetCallState();
}

class _GetCallState extends State<GetCall> {
  Timer _timer;
  int _start = 30;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            Navigator.of(context).pop();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userservice =
        Provider.of<FirebaseAuthService>(context, listen: false).activeuserid;
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
                          Column(
                            children: [
                              Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red),
                                      onPressed: () async {
                                        await CallService()
                                            .endCall(userId: _userservice);
                                      },
                                      child: Icon(Icons.call_end))),
                              Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.green),
                                      onPressed: () async {
                                        _timer.cancel();
                                        await CallService()
                                            .answerCall(userId: _userservice);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CallScreen(
                                                        channelId: this
                                                            .widget
                                                            .channelId)));
                                      },
                                      child: Icon(Icons.call))),
                            ],
                          ),
                          Text("$_start")
                        ])))));
  }
}
