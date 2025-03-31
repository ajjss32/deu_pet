import 'package:firebase_auth/firebase_auth.dart';
import 'package:deu_pet/model/user.dart';
import 'package:deu_pet/services/user_service.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Método para registrar um novo usuário
  Future<UserCredential> userRegistration({
    required String name,
    required String password,
    required String email,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Método para login do usuário
  Future<UserCredential?> userLogin({
    required String email,
    required String password,
  }) async {
    try {
      // Tenta fazer o login com o email e a senha
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print("Erro no login: $e");
      return null;
    }
  }

  // Método para obter o usuário logado
  Future<Usuario?> getUsuarioLogado() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UsuarioService().buscarUsuarioPorUid(user.uid);
  }

  // Método para atualizar a senha do usuário
  Future<void> updatePassword(String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw Exception("Usuário não está logado.");
    }
  }
}
