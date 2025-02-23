class Favorito {
 String id;
 String usuarioId;
 String petId;

  Favorito({
    required this.id,
    required this.usuarioId,
    required this.petId,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario_id': usuarioId,
      'pet_id': petId,
    };
  }

  factory Favorito.fromMap(String id, Map<String, dynamic> map) {
    return Favorito(
      id: id,
      usuarioId: map['usuario_id'],
      petId: map['pet_id'],
    );
  }
}