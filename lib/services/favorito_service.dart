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
      await favoritosCollection.doc(favorite.id).set(favorite.toMap());
      
      print('favorito criado com sucesso!');
    } catch (e) {
      print('Erro ao criar favorito: $e');
    }
  }
}
