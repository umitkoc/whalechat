import 'package:firebase_auth/firebase_auth.dart';
import 'package:whalechat/core/models/usermodel.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  String activeuserid;

  UserModel _createuser(User user) {
    if (user == null) {
      return null;
    }
    return UserModel.createfirestore(user);
  }

  Stream<UserModel> get userControl {
    return _firebaseauth.authStateChanges().map(_createuser);
  }
}
