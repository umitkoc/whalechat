import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

var dizi = [
  1,
  0,
  1,
  0,
  0,
  1,
  1,
  1,
  0,
  0,
  0,
  1,
  0,
  1,
  1,
  0,
  1,
  0,
  1,
  0,
  1,
  0,
  1,
  0,
  1,
  0,
  1,
  1,
  0,
  1,
  0,
  1,
  0,
  1,
  0,
  1,
  0
];

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        body: Column(children: [
          Expanded(
              flex: 9,
              child: Container(
                color: Colors.teal[200],
                child: ListView.builder(
                    reverse: true,
                    itemCount: dizi.length,
                    itemBuilder: (context, index) {
                      if (dizi[index] == 0) {
                        return Row(children: [
                          rightmessage(context),
                          Expanded(child: SizedBox())
                        ]);
                      } else {
                        return Row(children: [
                          Expanded(child: SizedBox()),
                          leftmessage(context)
                        ]);
                      }
                    }),
              )),
          Expanded(
              child: Container(
            color: Colors.teal[100],
            child: Form(
                child: Center(
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    hintText: "Message...",
                    suffixIcon:
                        IconButton(icon: Icon(Icons.send), onPressed: () {})),
              ),
            )),
          ))
        ]));
  }

  Widget rightmessage(BuildContext context) {
    return Expanded(
        flex: 4,
        child: Card(
            color: Colors.teal[400],
            child: ListTile(
              title: Text("username", style: TextStyle(color: Colors.white)),
              subtitle: Text("culpa ducimus quiculpa ducimus"),
              trailing: Text(DateTime.now().toString().substring(10, 16),
                  style: TextStyle(color: Colors.white)),
              leading: CircleAvatar(backgroundColor: Colors.amber[200]),
            )));
  }

  Widget leftmessage(BuildContext context) {
    return Expanded(
        flex: 4,
        child: Card(
            color: Colors.red[300],
            child: ListTile(
              title: Text("username", style: TextStyle(color: Colors.white)),
              subtitle: Text(
                  "Nemo temporibus illo et quis expedita perspiciatis inventore est. Ut numquam iure quam. Blanditiis quia omnis velit deleniti voluptatum veniam expedita."),
              leading: Text(DateTime.now().toString().substring(10, 16),
                  style: TextStyle(color: Colors.white)),
              trailing: CircleAvatar(backgroundColor: Colors.blueAccent),
            )));
  }
}
