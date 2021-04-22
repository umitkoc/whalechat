import 'package:flutter/material.dart';
import 'package:whalechat/core/validator/user/image.dart';
import 'package:whalechat/core/views/message.dart';

class UserCard extends StatefulWidget {
  final String avatar;
  final String id;
  final String username;
  final String friendId;
  final String value;

  const UserCard(
      {this.avatar, this.id, this.username, this.friendId, this.value = ""});
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Message(
                      avatar: this.widget.avatar,
                      friendId: this.widget.friendId,
                      userId: this.widget.id,
                      username: this.widget.username,
                    )));
      },
      child: Card(
        child: ListTile(
          leading: Avatar(avatar: this.widget.avatar),
          title: Text("${this.widget.username}"),
          subtitle: Text(
              '${this.widget.value.length < 25 ? this.widget.value : this.widget.value.substring(0, 24) + '...'}'),
        ),
      ),
    );
  }
}
