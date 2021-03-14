import 'package:flutter/material.dart';
import 'package:whalechat/core/models/usermodel.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/views/account/account.dart';
import 'package:whalechat/core/views/home/home.dart';

class RouterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuthService().userControl,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          // ignore: unused_local_variable
          UserModel user = snapshot.data;
          return Home();
        }
        return Account();
      },
    );
  }
}
