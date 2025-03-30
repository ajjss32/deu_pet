import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:deu_pet/model/match.dart';

class MatchService {
  final CollectionReference matchesCollection =
      FirebaseFirestore.instance.collection('matches');

  Future<List<Match>> buscarMatchesPorUsuario(
    String usuarioId,
    BuildContext context,
  ) async {
    try {
      QuerySnapshot querySnapshot = await matchesCollection
          .where('usuario_id', isEqualTo: usuarioId)
          .get();
      return querySnapshot.docs
          .map((doc) =>
              Match.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Erro ao buscar matches: $e');
      return [];
    }
  }

  Future<List<Match>> buscarMatchesPorPet(
    String petId,
    BuildContext context,
  ) async {
    try {
      QuerySnapshot querySnapshot =
          await matchesCollection.where('pet_id', isEqualTo: petId).get();
      return querySnapshot.docs
          .map((doc) =>
              Match.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Erro ao buscar matches: $e');
      return [];
    }
  }

  Future<void> criarMatch(Match match) async {
    try {
      await matchesCollection.doc(match.id).set(match.toMap());
      print('match criado com sucesso!');
    } catch (e) {
      print('Erro ao criar match: $e');
    }
  }

  Future<void> atualizarMatch(Match match) async {
    try {
      match.data = DateTime.now();
      await matchesCollection.doc(match.id).update(match.toMap());
      print('Match atualizado com sucesso!');
    } catch (e) {
      print('Erro ao atualizar match: $e');
    }
  }

  Future<void> deletarMatch(String id) async {
    try {
      await matchesCollection.doc(id).delete();
      print('Match deletado com sucesso!');
    } catch (e) {
      print('Erro ao deletar match: $e');
    }
  }
}
