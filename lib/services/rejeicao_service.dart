import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deu_pet/model/rejeicao.dart';

class RejeicaoService {
  final CollectionReference rejeicoesCollection =
      FirebaseFirestore.instance.collection('rejeicoes');

  Future<void> criarRejeicao(Rejeicao rejeicao) async {
    try {
      await rejeicoesCollection.doc(rejeicao.id).set(rejeicao.toMap());
    } catch (e) {
      print('Erro ao criar rejeição: $e');
    }
  }

  Future<List<Rejeicao>> buscarRejeicoesPorUsuario(String usuarioId) async {
    try {
      final querySnapshot = await rejeicoesCollection
          .where('usuario_id', isEqualTo: usuarioId)
          .get();

      return querySnapshot.docs
          .map((doc) => Rejeicao.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Erro ao buscar rejeições: $e');
      return [];
    }
  }

  Future<void> excluirRejeicoesExpiradas() async {
    final querySnapshot = await rejeicoesCollection.get();
    final agora = DateTime.now();

    for (var doc in querySnapshot.docs) {
      final rejeicao = Rejeicao.fromMap(doc.id, doc.data() as Map<String, dynamic>);

      if (agora.difference(rejeicao.dataRejeicao).inDays > 7) {
        await doc.reference.delete();
      }
    }
  }
}
