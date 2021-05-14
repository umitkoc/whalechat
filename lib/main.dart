import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/routerpage.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Provider<FirebaseAuthService>(
      create: (_) => FirebaseAuthService(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: Colors.amber),
          title: 'WhaleChat',
          home: RouterPage()));
}
