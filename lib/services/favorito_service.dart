import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:deu_pet/model/favorito.dart';

class FavoritoService {
  final CollectionReference favoritosCollection =
      FirebaseFirestore.instance.collection('favoritos');

  Future<List<Favorito>> buscarFavoritosPorUsuario(
      String usuarioId, BuildContext context) async {
    try {
      QuerySnapshot querySnapshot = await favoritosCollection
          .where('usuario_id', isEqualTo: usuarioId)
          .get();
      return querySnapshot.docs
          .map((doc) =>
              Favorito.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Erro ao buscar favoritos: $e');
      return [];
    }
  }

  Future<List<Favorito>> buscarFavoritosPorPet(
      String petId, BuildContext context) async {
    try {
      QuerySnapshot querySnapshot =
          await favoritosCollection.where('pet_id', isEqualTo: petId).get();
      return querySnapshot.docs
          .map((doc) =>
              Favorito.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Erro ao buscar favoritos: $e');
      return [];
    }
  }

  Future<void> deletarFavorito(String id) async {
    try {
      await favoritosCollection.doc(id).delete();
      print('Favorito deletado com sucesso!');
    } catch (e) {
      print('Erro ao deletar favorito: $e');
    }
  }

  Future<void> criarFavorito(Favorito favorite) async {
    try {
      // Verificar se o pet já está nos favoritos
      bool petJaFavorito =
          await checarPetFavorito(favorite.usuarioId, favorite.petId);

      if (petJaFavorito) {
        print('Este pet já foi adicionado aos favoritos.');
        return;
      }

      await favoritosCollection.doc(favorite.id).set(favorite.toMap());
      print('Favorito criado com sucesso!');
    } catch (e) {
      print('Erro ao criar favorito: $e');
    }
  }

  // Função para verificar se o pet já está nos favoritos
  Future<bool> checarPetFavorito(String usuarioId, String petId) async {
    try {
      QuerySnapshot querySnapshot = await favoritosCollection
          .where('usuario_id', isEqualTo: usuarioId)
          .where('pet_id', isEqualTo: petId)
          .get();

      return querySnapshot.docs.isNotEmpty; // Retorna true se já existir
    } catch (e) {
      print('Erro ao verificar pet favorito: $e');
      return false;
    }
  }
}
