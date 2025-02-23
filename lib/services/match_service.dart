import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:deu_pet/model/match.dart';

class MatchService {
  final CollectionReference matchesCollection = FirebaseFirestore.instance.collection('matches');

  Future<List<Match>> buscarMatchesPorUsuario(String usuarioId, BuildContext context) async {
    try {
      QuerySnapshot querySnapshot = await matchesCollection.where('usuario_id', isEqualTo: usuarioId).get();
      return querySnapshot.docs.map((doc) => Match.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Erro ao buscar matches: $e');
      return [];
    }
  }

  Future<List<Match>> buscarMatchesPorPet(String petId, BuildContext context) async {
    try {
      QuerySnapshot querySnapshot = await matchesCollection.where('pet_id', isEqualTo: petId).get();
      return querySnapshot.docs.map((doc) => Match.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Erro ao buscar matches: $e');
      return [];
    }
  }
}