class Pet {
  String id;
  String nome;
  String foto;
  int idade;
  String porte;
  String sexo;
  String temperamento;
  String estadoDeSaude;
  String endereco;
  String necessidades;
  String historia;
  String status;
  String voluntarioId;
  DateTime dataCriacao;
  DateTime dataAtualizacao;

  Pet({
    required this.id,
    required this.nome,
    required this.foto,
    required this.idade,
    required this.porte,
    required this.sexo,
    required this.temperamento,
    required this.estadoDeSaude,
    required this.endereco,
    required this.necessidades,
    required this.historia,
    required this.status,
    required this.voluntarioId,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'foto': foto,
      'idade': idade,
      'porte': porte,
      'sexo': sexo,
      'temperamento': temperamento,
      'estado_de_saude': estadoDeSaude,
      'endereco': endereco,
      'necessidades': necessidades,
      'historia': historia,
      'status': status,
      'voluntario_id': voluntarioId,
      'data_criacao': dataCriacao.toIso8601String(),
      'data_atualizacao': dataAtualizacao.toIso8601String(),
    };
  }

  factory Pet.fromMap(String id, Map<String, dynamic> map) {
    return Pet(
      id: id,
      nome: map['nome'],
      foto: map['foto'],
      idade: map['idade'],
      porte: map['porte'],
      sexo: map['sexo'],
      temperamento: map['temperamento'],
      estadoDeSaude: map['estado_de_saude'],
      endereco: map['endereco'],
      necessidades: map['necessidades'],
      historia: map['historia'],
      status: map['status'],
      voluntarioId: map['voluntario_id'],
      dataCriacao: DateTime.parse(map['data_criacao']),
      dataAtualizacao: DateTime.parse(map['data_atualizacao']),
    );
  }
}