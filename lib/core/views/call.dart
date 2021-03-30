import 'package:flutter/material.dart';

class Call extends StatefulWidget {
  final String id;
  final String avatar;

  const Call({this.id, this.avatar});
  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> {
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
                  Container(
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(Icons.call_end),
                      )),
                ]),
          ),
        ),
      ),
    );
  }
}
