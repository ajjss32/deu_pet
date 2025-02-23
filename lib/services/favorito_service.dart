import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:deu_pet/model/favorito.dart';

class FavoritoService {
  final CollectionReference favoritosCollection = FirebaseFirestore.instance.collection('favoritos');

  Future<List<Favorito>> buscarFavoritosPorUsuario(String usuarioId, BuildContext context) async {
    try {
      QuerySnapshot querySnapshot = await favoritosCollection.where('usuario_id', isEqualTo: usuarioId).get();
      return querySnapshot.docs.map((doc) => Favorito.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Erro ao buscar favoritos: $e');
      return [];
    }
  }

  Future<List<Favorito>> buscarFavoritosPorPet(String petId, BuildContext context) async {
    try {
      QuerySnapshot querySnapshot = await favoritosCollection.where('pet_id', isEqualTo: petId).get();
      return querySnapshot.docs.map((doc) => Favorito.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Erro ao buscar favoritos: $e');
      return [];
    }
  }

}