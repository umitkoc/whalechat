import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whalechat/core/models/usermodel.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  String activeuserid;

  UserModel _createuser(User user) {
    if (user == null) {
      return null;
    }
    return UserModel.createfirebaseuser(user);
  }

  Stream<UserModel> get userControl =>
      _firebaseauth.authStateChanges().map(_createuser);

  Future<UserModel> emailSignUp({String email, String password}) async {
    var _user = await _firebaseauth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _createuser(_user.user);
  }

  Future<UserModel> emailSignIn({String email, String password}) async {
    var _user = await _firebaseauth.signInWithEmailAndPassword(
        email: email, password: password);
    return _createuser(_user.user);
  }

  Future<void> signOut() async {
    await _firebaseauth.signOut();
  }

  Future<void> resetpassword({String email}) async {
    await _firebaseauth.sendPasswordResetEmail(email: email);
  }

  Future<UserModel> googleSign() async {
    GoogleSignInAccount sign = await GoogleSignIn().signIn();
    GoogleSignInAuthentication authentication = await sign.authentication;
    AuthCredential provider = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken);
    User _user = await _firebaseauth
        .signInWithCredential(provider)
        .then((value) => value.user);
    return _createuser(_user);
  }
}
