import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:deu_pet/model/pet.dart';

class PetService {
  final CollectionReference petsCollection =
      FirebaseFirestore.instance.collection('pets');

  Future<void> criarPet(Pet pet, BuildContext context) async {
    try {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pet encontrado com sucesso!')),
        );
        return Pet.fromMap(doc.id, doc.data() as Map<String, dynamic>);
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
      pet.dataAtualizacao = DateTime.now();
      await petsCollection.doc(pet.id).update(pet.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pet atualizado com sucesso!')),
      );
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
}
