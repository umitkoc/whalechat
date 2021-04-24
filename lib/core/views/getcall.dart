import 'dart:async';
import 'package:flutter/material.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/callservice.dart';
import 'package:whalechat/core/views/call_screen.dart';
import 'package:whalechat/core/widgets/boxdec_image.dart';

class GetCall extends StatefulWidget {
  final String id;
  final String userId;
  final String avatar;
  final String username;
  final String channelId;

  const GetCall(
      {this.id, this.userId, this.avatar, this.username, this.channelId});
  @override
  _GetCallState createState() => _GetCallState();
}

class _GetCallState extends State<GetCall> {
  Timer _timer;
  int _start = 15;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start > 0) {
          setState(() {
            _start--;
            print("start:  $_start");
          });
        } else {
          print("start2:  $_start");
          _timer.cancel();
          endCall();
        }
      },
    );
  }

  Future<void> endCall() async {
    await CallService().endCall(userId: this.widget.id);
    print(this.widget.id);
    print("sonlandırıldı");
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
                          ImageControl(
                            avatar: this.widget.avatar,
                            width: 200,
                            heigth: 200,
                          ),
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
                                            .endCall(userId: this.widget.id);
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
                                            .answerCall(userId: this.widget.id);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CallScreen(
                                                        userId: this.widget.id,
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
