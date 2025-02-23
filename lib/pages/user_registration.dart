import 'dart:io';
import 'dart:convert';
import 'package:deu_pet/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:deu_pet/services/user_service.dart';
import 'package:deu_pet/model/user.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();
  final TextEditingController _cpfCnpjController = TextEditingController();
  String? _selectedTipo; // Para armazenar o tipo selecionado
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  AuthService _authService = AuthService();
  final UsuarioService _usuarioService = UsuarioService();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registration")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, coloque um email válido!";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "A senha deve conter no mínimo 6 caracteres";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Enter a name" : null,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                validator: (value) => value!.isEmpty ? "Enter a phone number" : null,
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: "Endereço"),
                validator: (value) => value!.isEmpty ? "Enter an address" : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: "Descrição"),
                validator: (value) => value!.isEmpty ? "Enter a description" : null,
              ),
              TextFormField(
                controller: _dataNascimentoController,
                decoration: InputDecoration(labelText: "Data de Nascimento"),
                validator: (value) => value!.isEmpty ? "Enter a birth date" : null,
              ),
              TextFormField(
                controller: _cpfCnpjController,
                decoration: InputDecoration(labelText: "CPF/CNPJ"),
                validator: (value) => value!.isEmpty ? "Enter a CPF or CNPJ" : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedTipo,
                decoration: InputDecoration(labelText: "Tipo"),
                items: [
                  DropdownMenuItem(value: "adotante", child: Text("Adotante")),
                  DropdownMenuItem(value: "voluntario", child: Text("Voluntário")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedTipo = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Selecione um tipo";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: _selectedImage == null
                    ? Container(
                        height: 150,
                        width: 150,
                        color: Colors.grey[300],
                        child: Icon(Icons.camera_alt, size: 50),
                      )
                    : Image.file(
                        _selectedImage!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Cadastrando...")),
                    );
                    try {
                      // Converter a imagem para base64
                      String? fotoBase64;
                      if (_selectedImage != null) {
                        fotoBase64 = base64Encode(_selectedImage!.readAsBytesSync());
                      }

                      Usuario novoUsuario = Usuario(
                        id: _cpfCnpjController.text,
                        email: _emailController.text,
                        foto: fotoBase64 ?? "",
                        tipo: _selectedTipo ?? "",
                        nome: _nameController.text,
                        telefone: _telefoneController.text,
                        endereco: _enderecoController.text,
                        descricao: _descricaoController.text,
                        dataNascimento: _dataNascimentoController.text,
                        dataCriacao: DateTime.now(),
                        dataAtualizacao: DateTime.now(),
                      );

                      await _usuarioService.criarUsuario(novoUsuario);

                      _authService.userRegistration(
                        name: _nameController.text,
                        password: _passwordController.text,
                        email: _emailController.text);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Usuário cadastrado com sucesso!")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Erro ao cadastrar usuário: $e")),
                      );
                    }
                  }
                },
                child: Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
