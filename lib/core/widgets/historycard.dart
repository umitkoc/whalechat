import 'package:flutter/material.dart';

class HistoryCard extends StatefulWidget {
  final String state;
  final String date;

  const HistoryCard({this.state, this.date});
  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          CircleAvatar(backgroundImage: AssetImage("assets/images/logo.png")),
      subtitle: Text("${this.widget.date}", style: TextStyle(fontSize: 12)),
      title: Text("${this.widget.state}", style: TextStyle(fontSize: 12)),
    );
  }
}
