class Match {
  String id;
  String usuarioId;
  String petId;
  String status;
  DateTime data;

  Match({
    required this.id,
    required this.usuarioId,
    required this.petId,
    required this.status,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario_id': usuarioId,
      'pet_id': petId,
      'status': status,
      'data': data.toIso8601String(),
    };
  }

  factory Match.fromMap(String id, Map<String, dynamic> map) {
    return Match(
      id: id,
      usuarioId: map['usuario_id'],
      petId: map['pet_id'],
      status: map['status'],
      data: DateTime.parse(map['data']),
    );
  }
}