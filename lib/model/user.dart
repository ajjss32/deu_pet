class Usuario {
  String uid;
  String id;
  String email;
  String foto;
  String tipo;
  String nome;
  String telefone;
  String endereco;
  String descricao;
  String dataNascimento;
  DateTime dataCriacao;
  DateTime dataAtualizacao;

  Usuario({
    required this.uid,
    required this.id,
    required this.email,
    required this.foto,
    required this.tipo,
    required this.nome,
    required this.telefone,
    required this.endereco,
    required this.descricao,
    required this.dataNascimento,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'foto': foto,
      'tipo': tipo,
      'nome': nome,
      'telefone': telefone,
      'endereco': endereco,
      'descricao': descricao,
      'data_nascimento': dataNascimento,
      'data_criacao': dataCriacao.toIso8601String(),
      'data_atualizacao': dataAtualizacao.toIso8601String(),
    };
  }

  factory Usuario.fromMap(String uid, String id, Map<String, dynamic> map) {
    return Usuario(
      uid: uid,
      id: id,
      email: map['email'],
      foto: map['foto'],
      tipo: map['tipo'],
      nome: map['nome'],
      telefone: map['telefone'],
      endereco: map['endereco'],
      descricao: map['descricao'],
      dataNascimento: map['data_nascimento'],
      dataCriacao: DateTime.parse(map['data_criacao']),
      dataAtualizacao: DateTime.parse(map['data_atualizacao']),
    );
  }
}
