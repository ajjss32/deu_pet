import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:deu_pet/model/pet.dart';

class PetService {
  final CollectionReference petsCollection =
      FirebaseFirestore.instance.collection('pets');

  Future<void> criarPet(Pet pet, BuildContext context) async {
    try {
      // Verifique se o ID do pet já existe antes de cadastrar
      await petsCollection.doc(pet.id).set(pet.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pet cadastrado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar pet: $e')),
      );
    }
  }

  Future<Pet?> buscarPet(String id, BuildContext context) async {
    try {
      DocumentSnapshot doc = await petsCollection.doc(id).get();
      if (doc.exists) {
        // Convertendo os dados do Firestore para o modelo Pet
        return Pet.fromMap({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pet não encontrado!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar pet: $e')),
      );
    }
    return null;
  }

  Future<void> atualizarPet(Pet pet, BuildContext context) async {
    try {
      // Atualizando a data de atualização
      pet.dataAtualizacao = DateTime.now();
      await petsCollection.doc(pet.id).update(pet.toMap());
      print('Pet atualizado com sucesso!');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar pet: $e')),
      );
    }
  }

  Future<void> deletarPet(String id, BuildContext context) async {
    try {
      await petsCollection.doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pet deletado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar pet: $e')),
      );
    }
  }

  Future<List<Pet>> buscarPetsPorUsuario(String usuarioId) async {
    try {
      QuerySnapshot querySnapshot = await petsCollection
          .where('voluntario_uid', isEqualTo: usuarioId)
          .get();

      final results = querySnapshot.docs
          .map((doc) => Pet.fromMap({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();

      return results;
    } catch (e) {
      print('Erro ao buscar pets: $e');
      return [];
    }
  }

  Future<List<Pet>> buscarTodosPets() async {
    try {
      // Consulta sem filtros para buscar todos os pets
      QuerySnapshot querySnapshot = await petsCollection.get();

      final results = querySnapshot.docs
          .map((doc) => Pet.fromMap({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();

      return results;
    } catch (e) {
      print('Erro ao buscar todos os pets: $e');
      return [];
    }
  }

  // docs.map((doc) => Pet.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>}, doc.data() as Map<String, dynamic>)).toList();
  // Future<Usuario?> buscarUsuarioPorUid(String uid) async {
  //   try {
  //     QuerySnapshot querySnapshot =
  //         await usuariosCollection.where('uid', isEqualTo: uid).get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       var doc = querySnapshot.docs.first;
  //       Usuario usuario =
  //           Usuario.fromMap(uid, doc.data() as Map<String, dynamic>);
  //       return usuario;
  //     } else {
  //       print('Usuário não encontrado');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Erro ao buscar usuário: $e');
  //     return null;
  //   }
  // }
}
