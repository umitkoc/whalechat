import 'package:flutter/material.dart';

class ImageControl extends StatelessWidget {
  final String avatar;
  final double heigth;
  final double width;

  const ImageControl({this.avatar, this.heigth, this.width = double.infinity});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: heigth,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: avatar == ""
                    ? AssetImage("assets/images/logo.png")
                    : NetworkImage(avatar))));
  }
}
