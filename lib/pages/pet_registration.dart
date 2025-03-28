import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:deu_pet/services/pet_service.dart';
import 'package:deu_pet/model/pet.dart';
import 'package:deu_pet/services/cep_service.dart'; // Importe o CEPService
import 'package:intl/intl.dart'; // Para manipulação de data

class PetRegistration extends StatefulWidget {
  @override
  _PetRegistrationState createState() => _PetRegistrationState();
}

class _PetRegistrationState extends State<PetRegistration> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _healthController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  String? _specialNeeds; // Alterei para armazenar a escolha "Sim" ou "Não"
  final TextEditingController _historyController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();

  String? _selectedSex;
  String? _selectedSize;
  String? _selectedTemperament;

  final PetService _petService = PetService();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _buscarCEP() async {
    try {
      // Busca os dados do CEP usando o CEPService
      final endereco = await CEPService.buscarCEP(_cepController.text);

      // Preenche os campos com os dados retornados
      setState(() {
        _logradouroController.text = endereco['logradouro'] ?? '';
        _bairroController.text = endereco['bairro'] ?? '';
        _cidadeController.text = endereco['localidade'] ?? '';
        _estadoController.text = endereco['uf'] ?? '';
      });
    } catch (e) {
      // Exibe uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _clearFields() {
    _nameController.clear();
    _birthdateController.clear();
    _healthController.clear();
    _cepController.clear();
    _logradouroController.clear();
    _bairroController.clear();
    _cidadeController.clear();
    _estadoController.clear();
    setState(() {
      _image = null;
      _selectedSex = null;
      _selectedSize = null;
      _selectedTemperament = null;
      _specialNeeds = null; // Limpa a seleção de necessidades especiais
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(20),
          content: Stack(
            children: [
              Container(
                width: 221,
                height: 86,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Animal cadastrado com sucesso!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF787879),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                top: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String? _validateRequiredField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório!';
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório!';
    }
    try {
      DateFormat('dd/MM/yyyy').parse(value); // Tenta parse a data
    } catch (e) {
      return 'Data inválida';
    }
    return null;
  }

  int _calculateAge(DateTime birthdate) {
    final today = DateTime.now();
    int age = today.year - birthdate.year;
    if (today.month < birthdate.month ||
        (today.month == birthdate.month && today.day < birthdate.day)) {
      age -= 1;
    }
    return age;
  }

  void _registerPet() async {
    if (_formKey.currentState!.validate()) {
      try {
        final User? user = FirebaseAuth.instance.currentUser;
        final String? userUid = user?.uid;

        if (userUid == null) {
          throw Exception("Usuário não está logado.");
        }

        String petId = Uuid().v4();

        // Converter a imagem para base64
        String? fotoBase64;
        if (_image != null) {
          fotoBase64 = base64Encode(_image!.readAsBytesSync());
        }

        // Calculando a idade com base na data de nascimento
        final birthdateString = _birthdateController.text;
        final birthdate = DateFormat('dd/MM/yyyy').parse(birthdateString);
        final age = _calculateAge(birthdate);

        Pet novoPet = Pet(
          id: petId,
          nome: _nameController.text,
          foto: fotoBase64 ?? "",
          idade: _calculateAge(birthdate),
          porte: _selectedSize ?? "",
          sexo: _selectedSex ?? "",
          temperamento: _selectedTemperament ?? "",
          estadoDeSaude: _healthController.text,
          endereco:
              "${_logradouroController.text}, ${_bairroController.text}, ${_cidadeController.text}, ${_estadoController.text}",
          necessidades: _specialNeeds ?? "", // Utilizando a nova variável
          historia: _historyController.text,
          status: "Disponível",
          voluntarioUid: userUid,
          dataCriacao: DateTime.now(),
          dataAtualizacao: DateTime.now(),
        );

        await _petService.criarPet(novoPet, context);
        _showSuccessDialog();
        _clearFields();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar pet: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Por favor, preencha todos os campos corretamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _image == null
                        ? Icon(Icons.add_a_photo,
                            size: 50, color: Colors.grey[600])
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _speciesController,
                decoration: InputDecoration(
                  labelText: 'Espécie/Raça',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _birthdateController,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  border: OutlineInputBorder(),
                ),
                validator: _validateDate,
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  // Mostra um seletor de data
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _birthdateController.text =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedSex,
                      decoration: InputDecoration(
                        labelText: 'Sexo',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Macho', 'Fêmea']
                          .map((sex) => DropdownMenuItem(
                                value: sex,
                                child: Text(sex),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSex = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Campo obrigatório' : null,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedSize,
                      decoration: InputDecoration(
                        labelText: 'Porte',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Pequeno', 'Médio', 'Grande']
                          .map((size) => DropdownMenuItem(
                                value: size,
                                child: Text(size),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSize = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Campo obrigatório' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedTemperament,
                      decoration: InputDecoration(
                        labelText: 'Temperamento',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Calmo', 'Agitado', 'Brincalhão', 'Tímido']
                          .map((temperament) => DropdownMenuItem(
                                value: temperament,
                                child: Text(temperament),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTemperament = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Campo obrigatório' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _healthController,
                decoration: InputDecoration(
                  labelText: 'Estado de Saúde',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _cepController,
                      decoration: InputDecoration(
                        labelText: 'CEP',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateRequiredField,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _buscarCEP,
                      child: Text("Buscar CEP"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _logradouroController,
                decoration: InputDecoration(
                  labelText: 'Logradouro',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _bairroController,
                decoration: InputDecoration(
                  labelText: 'Bairro',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cidadeController,
                decoration: InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _estadoController,
                decoration: InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _specialNeeds,
                decoration: InputDecoration(
                  labelText: 'Possui Necessidades Especiais?',
                  border: OutlineInputBorder(),
                ),
                items: ['Sim', 'Não']
                    .map((need) => DropdownMenuItem(
                          value: need,
                          child: Text(need),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _specialNeeds = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _historyController,
                decoration: InputDecoration(
                  labelText: 'História',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerPet,
                child: Text('Cadastrar Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
