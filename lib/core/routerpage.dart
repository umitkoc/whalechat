import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/models/usermodel.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/views/account.dart';
import 'package:whalechat/core/views/home.dart';

class RouterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _service = Provider.of<FirebaseAuthService>(context, listen: false);
    return StreamBuilder(
      stream: _service.userControl,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          UserModel user = snapshot.data;
          _service.activeuserid = user.id;
          return Home();
        }
        return Account();
      },
    );
  }
}
