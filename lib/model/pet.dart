import 'package:intl/intl.dart';

class Pet {
  String id;
  String nome;
  List<String> fotos;
  DateTime dataDeNascimento;
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
    required this.fotos,
    required this.dataDeNascimento,
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
      'fotos': fotos,
      'data_de_nascimento': DateFormat('dd/MM/yyyy').format(dataDeNascimento),
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

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      nome: map['nome'],
      fotos: List<String>.from(map['fotos'] ?? []),
      dataDeNascimento: DateFormat('dd/MM/yyyy').parse(map['data_de_nascimento'] ?? ''),
      especie: map['especie'] ?? '',
      raca: map['raca'] ?? '',
      porte: map['porte'] ?? '',
      sexo: map['sexo'] ?? '',
      temperamento: map['temperamento'] ?? '',
      estadoDeSaude: map['estado_de_saude'] ?? '',
      endereco: map['endereco'] ?? '',
      necessidades: map['necessidades'] ?? '',
      historia: map['historia'] ?? '',
      status: map['status'] ?? '',
      voluntarioUid: map['voluntario_uid'] ?? '',
      dataCriacao: DateTime.parse(map['data_criacao'] ?? ''),
      dataAtualizacao: DateTime.parse(map['data_atualizacao'] ?? ''),
    );
  }

  Pet copyWith({
    String? id,
    String? nome,
    List<String>? fotos,
    DateTime? dataDeNascimento,
    String? especie,
    String? raca,
    String? porte,
    String? sexo,
    String? temperamento,
    String? estadoDeSaude,
    String? endereco,
    String? necessidades,
    String? historia,
    String? status,
    String? voluntarioUid,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) {
    return Pet(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      fotos: fotos ?? this.fotos,
      dataDeNascimento: dataDeNascimento ?? this.dataDeNascimento,
      especie: especie ?? this.especie,
      raca: raca ?? this.raca,
      porte: porte ?? this.porte,
      sexo: sexo ?? this.sexo,
      temperamento: temperamento ?? this.temperamento,
      estadoDeSaude: estadoDeSaude ?? this.estadoDeSaude,
      endereco: endereco ?? this.endereco,
      necessidades: necessidades ?? this.necessidades,
      historia: historia ?? this.historia,
      status: status ?? this.status,
      voluntarioUid: voluntarioUid ?? this.voluntarioUid,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}
