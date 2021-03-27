import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:whalechat/core/models/messagemodel.dart';
import 'package:whalechat/core/models/usermodel.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/messageservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/userservice.dart';

class Message extends StatefulWidget {
  final String userId;
  final String friendId;
  final String username;
  final String avatar;

  const Message({this.userId, this.friendId, this.username, this.avatar});

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final TextEditingController _controller = TextEditingController();
  UserModel model;
  @override
  void initState() {
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    getUser();
    super.initState();
  }

  Future<void> getUser() async {
    model = await FirebaseUserService().getUser(id: this.widget.userId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffdee2d6),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.teal,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: this.widget.avatar == ""
                    ? AssetImage("assets/images/logo.png")
                    : NetworkImage(this.widget.avatar),
              ),
              SizedBox(width: 20.0),
              Text(
                "${this.widget.username}",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
        ),
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [messagelist(), messageform()])));
  }

  // Widget messagelistdemo() {
  //   return Expanded(
  //       child: ListView.builder(
  //           reverse: true,
  //           itemCount: users.length,
  //           itemBuilder: (context, index) {
  //             return Row(
  //               mainAxisAlignment: users[index] == "1"
  //                   ? MainAxisAlignment.end
  //                   : MainAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Container(
  //                     padding: const EdgeInsets.all(16),
  //                     constraints: BoxConstraints(
  //                       maxWidth: 280,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(5),
  //                       color: users[index] == "1"
  //                           ? Colors.deepPurple[300]
  //                           : Colors.teal[300],
  //                     ),
  //                     child: Column(
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Text(
  //                               "username",
  //                               style: TextStyle(
  //                                   fontSize: 16,
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.bold),
  //                             )
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 5,
  //                         ),
  //                         Text(
  //                           " Eveniet optio aspernatur qui recusandae.",
  //                           style: TextStyle(color: Colors.white),
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             Text(
  //                               timeago.format(DateTime.now(), locale: 'tr'),
  //                               style: TextStyle(color: Colors.white),
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           }));
  // }

  Widget messagelist() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: MessageService().getMessage(
              friendId: this.widget.friendId, userId: this.widget.userId),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Text("has error");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: RefreshProgressIndicator());
            }
            List<MessageModel> user = snapshot.data.docs
                .map((e) => MessageModel.createdocument(e))
                .toList();
            return ListView.builder(
              itemCount: user.length,
              itemBuilder: (_, index) {
                return Row(
                  mainAxisAlignment: user[index].userid != this.widget.userId
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        constraints: BoxConstraints(maxWidth: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: user[index].userid != this.widget.userId
                              ? Colors.deepPurple[300]
                              : Colors.teal[300],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${user[index].value}",
                              style: TextStyle(color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${user[index].username}",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white)),
                                Text(
                                  timeago.format(user[index].date.toDate(),
                                      locale: 'tr'),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }),
    );
  }

  Widget messageform() => Container(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                ),
                minLines: 1,
                maxLines: 3,
              ),
            ),
            SizedBox(width: 5.0),
            RawMaterialButton(
              onPressed: () async {
                if (_controller.text.trim().isNotEmpty) {
                  await MessageService().createMessage(
                      friendId: this.widget.friendId,
                      userId: this.widget.userId,
                      value: _controller.text,
                      username: model.username);
                  _controller.clear();
                }
              },
              fillColor: Colors.teal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Gönder",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            )
          ],
        ),
      ));
}
