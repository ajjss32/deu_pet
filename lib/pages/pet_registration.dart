// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:deu_pet/services/cloudinary_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  List<XFile> _images = [];
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
  String? _selectedSpecies; // Alterado para o nome da espécie
  String? _selectedBreed; // Adicionado para a raça

  String? _selectedSex;
  String? _selectedSize;
  String? _selectedTemperament;

  final PetService _petService = PetService();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles);
      });
    }
  }

  Future<void> _buscarCEP() async {
    try {
      final endereco = await CEPService.buscarCEP(_cepController.text);

      setState(() {
        _logradouroController.text = endereco['logradouro'] ?? '';
        _bairroController.text = endereco['bairro'] ?? '';
        _cidadeController.text = endereco['localidade'] ?? '';
        _estadoController.text = endereco['uf'] ?? '';
      });
    } catch (e) {
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
    _historyController.clear();
    setState(() {
      _images = [];
      _selectedSex = null;
      _selectedSize = null;
      _selectedTemperament = null;
      _specialNeeds = null;
      _selectedSpecies = null;
      _selectedBreed = null;
      _historyController.text = '';
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

  void _registerPet() async {
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione ao menos uma imagem!')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        final User? user = FirebaseAuth.instance.currentUser;
        final String? userUid = user?.uid;

        if (userUid == null) {
          throw Exception("Usuário não está logado.");
        }

        String petId = Uuid().v4();

        List<String> urls = [];
        if (!_images.isEmpty) {
          for (XFile image in _images) {
            String? url =
                await _cloudinaryService.uploadImageToCloudinary(image);
            if (url != null) {
              urls.add(url);
            }
          }
        }

        final birthdateString = _birthdateController.text;
        final birthdate = DateFormat('dd/MM/yyyy').parse(birthdateString);

        Pet novoPet = Pet(
          id: petId,
          nome: _nameController.text,
          fotos: urls,
          dataDeNascimento: birthdate,
          porte: _selectedSize ?? "",
          sexo: _selectedSex ?? "",
          temperamento: _selectedTemperament ?? "",
          estadoDeSaude: _healthController.text,
          endereco:
              "${_logradouroController.text}, ${_bairroController.text}, ${_cidadeController.text}, ${_estadoController.text}",
          necessidades: _specialNeeds ?? "",
          historia: _historyController.text,
          status: "Disponível",
          especie: _selectedSpecies ?? "",
          raca: _selectedBreed ?? "",
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
                  onTap: _pickImages,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: _buildSelectedImages(),
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
              DropdownButtonFormField<String>(
                value: _selectedSpecies,
                decoration: InputDecoration(
                  labelText: 'Espécie',
                  border: OutlineInputBorder(),
                ),
                items: ['Canino', 'Felino']
                    .map((species) => DropdownMenuItem(
                          value: species,
                          child: Text(species),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSpecies = value;
                  });
                },
                validator: _validateRequiredField,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedBreed,
                decoration: InputDecoration(
                  labelText: 'Raça',
                  border: OutlineInputBorder(),
                ),
                items: _selectedSpecies == 'Canino'
                    ? [
                        'Sem raça definida',
                        'Labrador',
                        'Bulldog',
                        'Pinscher',
                        'Beagle',
                        'Poodle',
                        'Chihuahua',
                        'Rottweiler',
                        'Dachshund',
                        'Boxer',
                        'Pastor Alemão',
                        'Golden Retriever',
                        'Shih Tzu',
                        'Cocker Spaniel',
                        'Pug',
                        'Border Collie',
                        'Akita',
                        'Husky Siberiano',
                        'São Bernardo',
                        'Maltês',
                        'Schnauzer',
                        'Spitz Alemão',
                        'Buldogue Francês',
                        'Dálmata',
                        'Basset Hound',
                        'Shiba Inu',
                        'Outra',
                      ]
                        .map((breed) => DropdownMenuItem(
                              value: breed,
                              child: Text(breed),
                            ))
                        .toList()
                    : [
                        'Sem raça definida',
                        'Siamês',
                        'Persa',
                        'Maine Coon',
                        'Ragdoll',
                        'Bengal',
                        'Sphynx',
                        'Outra',
                      ]
                        .map((breed) => DropdownMenuItem(
                              value: breed,
                              child: Text(breed),
                            ))
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBreed = value;
                  });
                },
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
                      child: Text("Buscar"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Color(0xFF50BB88),
                        foregroundColor: (Colors.white),
                      ),
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
                enabled: false,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _bairroController,
                decoration: InputDecoration(
                  labelText: 'Bairro',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
                enabled: false,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cidadeController,
                decoration: InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
                enabled: false,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _estadoController,
                decoration: InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
                enabled: false,
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
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color(0xFF50BB88),
                  foregroundColor: (Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedImages() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _images.length + 1,
      itemBuilder: (context, index) {
        if (index == _images.length) {
          return GestureDetector(
            onTap: _pickImages,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.add_a_photo, size: 30, color: Colors.grey[700]),
            ),
          );
        } else {
          final image = _images[index];
          return Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb
                      ? Image.network(image.path, fit: BoxFit.cover)
                      : Image.memory(
                          Uint8List.fromList(
                              File(image.path).readAsBytesSync()),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _images.removeAt(index);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
