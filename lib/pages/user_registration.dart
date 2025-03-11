import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:deu_pet/services/auth_service.dart';
import 'package:deu_pet/services/user_service.dart';
import 'package:deu_pet/model/user.dart';
import 'package:deu_pet/pages/login_page.dart';
import 'package:deu_pet/utils/validators.dart';

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
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _cpfCnpjController = TextEditingController();
  String? _selectedTipo;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final AuthService _authService = AuthService();
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 80),
                    Text(
                      "Crie uma conta",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4E59D9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Cadastre-se para encontrar e adotar um pet!",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(_nameController, "Nome", Icons.person),
              _buildTextField(_emailController, "Email", Icons.email,
                  keyboardType: TextInputType.emailAddress),
              _buildTextField(_telefoneController, "Telefone", Icons.phone,
                  keyboardType: TextInputType.phone),
              _buildTextField(_enderecoController, "Endereço", Icons.home),
              _buildTextField(_descricaoController, "Descrição", Icons.info),
              _buildTextField(_dataNascimentoController, "Data de Nascimento",
                  Icons.calendar_today),
              _buildTextField(_cpfCnpjController, "CPF/CNPJ", Icons.badge,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Campo obrigatório";
                }
                if (!Validators.validarCPF(value) &&
                    !Validators.validarCNPJ(value)) {
                  return "CPF ou CNPJ inválido";
                }
                return null;
              }),
              DropdownButtonFormField<String>(
                value: _selectedTipo,
                decoration: InputDecoration(
                  labelText: "Tipo",
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFCCCCCE), width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFCCCCCE), width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFCCCCCE), width: 0.5),
                  ),
                  prefixIcon: Icon(Icons.category),
                ),
                items: [
                  DropdownMenuItem(value: "adotante", child: Text("Adotante")),
                  DropdownMenuItem(
                      value: "voluntario", child: Text("Voluntário")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedTipo = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Selecione um tipo" : null,
              ),
              _buildTextField(_passwordController, "Senha", Icons.lock,
                  obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Color(0xFF50BB88),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _registerUser,
                child: Center(
                  child: Text(
                    "Cadastrar",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    "Já tem uma conta? Entrar",
                    style: TextStyle(color: Colors.grey), // Define a cor cinza
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFCCCCCE), width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFCCCCCE), width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFCCCCCE), width: 0.5),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          prefixIcon: Icon(icon),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator:
            validator ?? (value) => value!.isEmpty ? "Campo obrigatório" : null,
      ),
    );
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cadastrando...")),
      );

      try {
        // Converte a imagem para Base64, se existir
        String? fotoBase64;
        if (_selectedImage != null) {
          fotoBase64 = base64Encode(_selectedImage!.readAsBytesSync());
        }

        // Cria o usuário no Firebase Auth e obtém o UID
        UserCredential userCredential = await _authService.userRegistration(
          name: _nameController.text,
          password: _passwordController.text,
          email: _emailController.text,
        );

        String uid = userCredential.user!.uid; // Obtém o UID do usuário

        // Criar objeto usuário com UID correto
        Usuario novoUsuario = Usuario(
          uid: uid, // UID vindo do Firebase Auth
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

        // Salva o usuário no Firestore com o UID correto
        await _usuarioService.criarUsuario(novoUsuario);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário cadastrado com sucesso!")),
        );

        // Navega para a tela de login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao cadastrar usuário: $e")),
        );
      }
    }
  }
}
