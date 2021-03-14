import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whalechat/core/routerpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.amber),
        title: 'WhaleChat',
        home: RouterPage());
  }
}
