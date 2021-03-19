import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:whalechat/core/models/messagemodel.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/messageservice.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final TextEditingController _controller = TextEditingController();
  String userid = "2";
  String seconduserid = "1";
  List<String> users = ["1", "2", "1", "2", "1", "2", "1", "2", "1", "2"];

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('tr', timeago.TrMessages());
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
                backgroundColor: Colors.amber,
              ),
              SizedBox(width: 20.0),
              Text(
                "username",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
        ),
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [messagelistdemo(), messageform()])));
  }

  Widget messagelistdemo() {
    return Expanded(
        child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: users[index] == "1"
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      constraints: BoxConstraints(
                        maxWidth: 280,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: users[index] == "1"
                            ? Colors.deepPurple[300]
                            : Colors.teal[300],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "username",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            " Eveniet optio aspernatur qui recusandae.",
                            style: TextStyle(color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                timeago.format(DateTime.now(), locale: 'tr'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }));
  }

  Widget messagelist() => Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: MessageService().getMessage(userid, seconduserid),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(child: RefreshProgressIndicator());
            }
            if (!snapshots.hasData) {
              return SizedBox(height: 0.0);
            } else {
              return ListView.builder(
                  itemCount: snapshots.data.docs.length,
                  itemBuilder: (context, index) {
                    MessageModel model =
                        MessageModel.createdocument(snapshots.data.docs[index]);
                    return Container(child: Text(model.value));
                  });
            }
          }));

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
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  print(_controller.text);

                  ///message create function
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