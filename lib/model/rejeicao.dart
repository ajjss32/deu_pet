class Rejeicao {
  String id;
  String usuarioId;
  String petId;
  DateTime dataRejeicao;

  Rejeicao({
    required this.id,
    required this.usuarioId,
    required this.petId,
    required this.dataRejeicao,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario_id': usuarioId,
      'pet_id': petId,
      'data_rejeicao': dataRejeicao.toIso8601String(),
    };
  }

  factory Rejeicao.fromMap(String id, Map<String, dynamic> map) {
    return Rejeicao(
      id: id,
      usuarioId: map['usuario_id'],
      petId: map['pet_id'],
      dataRejeicao: DateTime.parse(map['data_rejeicao']),
    );
  }
}
