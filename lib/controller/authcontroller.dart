import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redlenshoescleaning/model/usermodel.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  bool get success => false;

  Future<User?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _auth.currentUser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  UserModel? getCurrentUser() {
    final User? user = _auth.currentUser;

    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
