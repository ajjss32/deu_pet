import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:deu_pet/services/auth_service.dart';
import 'package:deu_pet/pages/user_registration.dart';
import 'package:deu_pet/pages/profile_page.dart';
import 'package:deu_pet/main.dart';
import 'package:deu_pet/services/user_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final UsuarioService _userService = UsuarioService();

  get userType => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            // Título e subtítulo no estilo da imagem
            Text(
              "Entrar",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E59D9), // Azul escuro
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              "Bem vindo de volta!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(_emailController, "Email", Icons.email,
                      keyboardType: TextInputType.emailAddress),
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
                    onPressed: _loginUser,
                    child: Center(
                      child: Text(
                        "Entrar",
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
                          MaterialPageRoute(
                              builder: (context) => RegistrationPage()),
                        );
                      },
                      child: Text(
                        "Não tem uma conta? Cadastre-se",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 400),

            // Logo no final da página
            Padding(
              padding: EdgeInsets.only(bottom: 20), // Adiciona margem inferior
              child: Image.asset(
                'assets/logo.png',
                width: 50,
                height: 50,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
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
          prefixIcon: Icon(icon),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
      ),
    );
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Fazendo login do usuário
        await _authService.userLogin(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Recuperando o UID do usuário autenticado
        var user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String uid = user.uid;

          // Aguarda a resposta antes de navegar
          String? userType = await _userService.obterTipoUsuario(uid);

          if (userType != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(userType: userType),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Tipo de usuário não encontrado")),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao fazer login: $e")),
        );
      }
    }
  }
}
