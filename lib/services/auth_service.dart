import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  userRegistration({
    required String name,
    required String password,
    required String email,
  }) {
    _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
}
