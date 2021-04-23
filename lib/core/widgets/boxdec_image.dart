import 'package:flutter/material.dart';

class ImageControl extends StatelessWidget {
  final String avatar;

  const ImageControl({this.avatar});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            image: DecorationImage(
                repeat: ImageRepeat.noRepeat,
                fit: BoxFit.fitHeight,
                image: avatar == ""
                    ? AssetImage("assets/images/logo.png")
                    : NetworkImage(avatar))));
  }
}
