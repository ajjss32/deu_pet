import 'package:deu_pet/model/user.dart';
import 'package:deu_pet/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:deu_pet/services/auth_service.dart';
import 'package:deu_pet/pages/user_registration.dart';
import 'package:deu_pet/main.dart';
import 'package:deu_pet/services/user_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream_chat;

class LoginPage extends StatefulWidget {
  final stream_chat.StreamChatClient client;

  LoginPage({required this.client});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final UsuarioService _userService = UsuarioService();
  final ChatService _chatService = ChatService();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
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
                                  builder: (context) =>
                                      RegistrationPage(client: widget.client)),
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
                  padding:
                      EdgeInsets.only(bottom: 20), // Adiciona margem inferior
                  child: Image.asset(
                    'assets/logo.png',
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black54.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
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
      setState(() {
        _isLoading = true;
      });

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
            // Recupera os dados do usuário do banco de dados
            Usuario? usuario = await _userService.buscarUsuarioPorUid(uid);

            // Obtem o token
            final token = await _fetchStreamToken(usuario!);

            // Conecta o usuário ao Stream Chat
            await connectToStreamChat(usuario, widget.client, token);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(userType: userType, client: widget.client),
              ),
            );
          } else {
            _showError("Tipo de usuário não encontrado");
          }
        }
      } catch (e) {
        String errorMessage = _getFirebaseErrorMessage(e);
        _showError(errorMessage);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  String _getFirebaseErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'Usuário não encontrado. Verifique o email e tente novamente.';
        case 'wrong-password':
          return 'Senha incorreta. Tente novamente.';
        case 'invalid-credential':
          return 'As credenciais fornecidas são inválidas ou expiraram. Tente novamente.';
        case 'email-already-exists':
          return 'O e-mail fornecido já está em uso. Tente outro e-mail.';
        case 'id-token-expired':
          return 'O token de autenticação expirou. Faça login novamente.';
        case 'id-token-revoked':
          return 'O token de autenticação foi revogado. Faça login novamente.';
        case 'insufficient-permission':
          return 'Permissões insuficientes para realizar esta operação.';
        case 'internal-error':
          return 'Ocorreu um erro interno no servidor de autenticação. Tente novamente.';
        case 'invalid-argument':
          return 'Argumento inválido fornecido para autenticação. Verifique os dados.';
        case 'invalid-email':
          return 'O e-mail fornecido é inválido. Verifique e tente novamente.';
        case 'invalid-password':
          return 'A senha fornecida é inválida. Certifique-se de que tem pelo menos 6 caracteres.';
        case 'operation-not-allowed':
          return 'Este provedor de login está desativado. Tente outro método.';
        case 'too-many-requests':
          return 'Você fez muitas tentativas de login. Tente novamente mais tarde.';
        case 'user-disabled':
          return 'Sua conta foi desativada. Entre em contato com o suporte.';
        default:
          return 'Ocorreu um erro desconhecido. Tente novamente mais tarde.';
      }
    } else {
      return 'Erro desconhecido. Tente novamente.';
    }
  }

  Future<void> connectToStreamChat(Usuario usuario,
      stream_chat.StreamChatClient client, String token) async {
    await Future.delayed(Duration(seconds: 3));
    await client.connectUser(
      stream_chat.User(
        id: usuario.uid,
        extraData: {
          'name': usuario.nome,
          'image': usuario.foto,
          'email': usuario.email,
          'tipo': usuario.tipo,
        },
      ),
      token,
    );
  }

  Future<String> _fetchStreamToken(Usuario usuario) async {
    final payload = {
      'user_id': usuario.uid,
      ...usuario.toMap(),
    };

    final token = await _chatService.gerarTokenJWT(
        '5ybdnxv26rnu8waqrqtapfgptuuu3bhqpg245nfegdcdtd2zarzr57yty9bc63mk',
        payload);
    return token;
  }
}
