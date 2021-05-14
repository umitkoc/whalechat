import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final String userId;
  final String value;
  final String date;
  final String id;
  final String username; //username is remove

  const MessageCard(
      {this.userId, this.value, this.date, this.id, this.username});
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            id == userId ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  padding: const EdgeInsets.all(16),
                  constraints: BoxConstraints(maxWidth: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: id == userId
                        ? Colors.teal[300]
                        : Colors.deepPurple[300],
                  ),
                  child: Column(children: [
                    Text(value, style: TextStyle(color: Colors.white)),
                    Text(date,
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                  ])))
        ]);
  }
}
