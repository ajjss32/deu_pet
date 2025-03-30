class Pet {
  String id;
  String nome;
  String foto;
  String idade;
  String especie;
  String raca;
  String porte;
  String sexo;
  String temperamento;
  String estadoDeSaude;
  String endereco;
  String necessidades;
  String historia;
  String status;
  String voluntarioUid;
  DateTime dataCriacao;
  DateTime dataAtualizacao;

  Pet({
    required this.id,
    required this.nome,
    required this.foto,
    required this.idade,
    required this.especie,
    required this.raca,
    required this.porte,
    required this.sexo,
    required this.temperamento,
    required this.estadoDeSaude,
    required this.endereco,
    required this.necessidades,
    required this.historia,
    required this.status,
    required this.voluntarioUid,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'foto': foto,
      'idade': idade,
      'especie': especie,
      'raca': raca,
      'porte': porte,
      'sexo': sexo,
      'temperamento': temperamento,
      'estado_de_saude': estadoDeSaude,
      'endereco': endereco,
      'necessidades': necessidades,
      'historia': historia,
      'status': status,
      'voluntario_uid': voluntarioUid,
      'data_criacao': dataCriacao.toIso8601String(),
      'data_atualizacao': dataAtualizacao.toIso8601String(),
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map, Map<String, dynamic> data) {
    return Pet(
      id: map['id'],
      nome: map['nome'],
      foto: map['foto'],
      idade: map['idade'],
      especie: map['especie'],
      raca: map['raca'],
      porte: map['porte'],
      sexo: map['sexo'],
      temperamento: map['temperamento'],
      estadoDeSaude: map['estado_de_saude'],
      endereco: map['endereco'],
      necessidades: map['necessidades'],
      historia: map['historia'],
      status: map['status'],
      voluntarioUid: map['voluntario_uid'],
      dataCriacao: DateTime.parse(map['data_criacao']),
      dataAtualizacao: DateTime.parse(map['data_atualizacao']),
    );
  }
}
