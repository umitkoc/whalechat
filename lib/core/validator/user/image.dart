import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String avatar;

  const Avatar({this.avatar});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundImage: this.avatar == ""
            ? AssetImage("assets/images/logo.png")
            : NetworkImage(this.avatar));
  }
}
