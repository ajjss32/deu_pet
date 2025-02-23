import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deu_pet/model/user.dart';

class UsuarioService {
  final CollectionReference usuariosCollection =
      FirebaseFirestore.instance.collection('usuarios');

  Future<void> criarUsuario(Usuario usuario) async {
    try {
      await usuariosCollection.doc(usuario.id).set(usuario.toMap());
      print('Usuário criado com sucesso!');
    } catch (e) {
      print('Erro ao criar usuário: $e');
    }
  }

  Future<Usuario?> buscarUsuario(String id) async {
    try {
      DocumentSnapshot doc = await usuariosCollection.doc(id).get();
      if (doc.exists) {
        return Usuario.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Erro ao buscar usuário: $e');
    }
    return null;
  }

  Future<void> atualizarUsuario(Usuario usuario) async {
    try {
      usuario.dataAtualizacao = DateTime.now();
      await usuariosCollection.doc(usuario.id).update(usuario.toMap());
      print('Usuário atualizado com sucesso!');
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
    }
  }

  Future<void> deletarUsuario(String id) async {
    try {
      await usuariosCollection.doc(id).delete();
      print('Usuário deletado com sucesso!');
    } catch (e) {
      print('Erro ao deletar usuário: $e');
    }
  }
}