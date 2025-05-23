import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deu_pet/model/user.dart';
import 'package:flutter/material.dart';
import 'package:deu_pet/model/pet.dart';

class PetService {
  final CollectionReference petsCollection =
      FirebaseFirestore.instance.collection('pets');

  Future<void> criarPet(Pet pet, BuildContext context) async {
    try {
      // Verifique se o ID do pet já existe antes de cadastrar
      await petsCollection.doc(pet.id).set(pet.toMap());
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

  Future<List<Pet>> buscarTodosPets(Usuario usuarioLogado) async {
    try {
      String cidadeUsuario = _extrairCidade(usuarioLogado.endereco);

      QuerySnapshot querySnapshot = await petsCollection.get();

      final results = querySnapshot.docs
          .map((doc) => Pet.fromMap({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .where((pet) {
        String cidadePet = _extrairCidade(pet.endereco);
        return cidadePet.toLowerCase() == cidadeUsuario.toLowerCase();
      }).toList();

      return results;
    } catch (e) {
      print('Erro ao buscar todos os pets: $e');
      return [];
    }
  }

  String _extrairCidade(String endereco) {
    List<String> partes = endereco.split(',');
    if (partes.length >= 3) {
      return partes[2].trim();
    } else {
      return '';
    }
  }

  int calcularIdade(DateTime dataDeNascimento) {
    DateTime agora = DateTime.now();

    // Calcula a diferença em anos, meses e dias
    int anos = agora.year - dataDeNascimento.year;
    int meses = agora.month - dataDeNascimento.month;
    int dias = agora.day - dataDeNascimento.day;

    // Ajusta para o caso de meses ou dias negativos
    if (meses < 0) {
      anos--;
      meses += 12;
    }
    if (dias < 0) {
      meses--;
      // Ajuste o número de dias com base no mês anterior
      dias += DateTime(agora.year, agora.month, 0).day;
    }

    // Se a diferença for menor que um ano, retorna em meses
    if (anos == 0 && meses == 0) {
      return dias; // Retorna em dias
    } else if (anos == 0) {
      return meses; // Retorna em meses
    } else {
      return anos; // Retorna em anos
    }
  }

  String formatarIdade(DateTime dataDeNascimento) {
    int idade = calcularIdade(dataDeNascimento);

    DateTime agora = DateTime.now();
    int anos = agora.year - dataDeNascimento.year;
    int meses = agora.month - dataDeNascimento.month;

    if (anos == 0 && meses == 0) {
      return '$idade dias';
    } else if (anos == 0) {
      return '$idade meses';
    } else {
      return '$idade anos';
    }
  }
}
