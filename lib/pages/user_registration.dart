import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:deu_pet/services/auth_service.dart';
import 'package:deu_pet/services/user_service.dart';
import 'package:deu_pet/model/user.dart';
import 'package:deu_pet/pages/login_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class RegistrationPage extends StatefulWidget {
  final StreamChatClient client;

  RegistrationPage({required this.client});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  String? _selectedTipo;
  final AuthService _authService = AuthService();
  final UsuarioService _usuarioService = UsuarioService();

  bool validarCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length != 11) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    // Validação do CPF
    for (int i = 9; i < 11; i++) {
      int soma = 0;
      for (int j = 0; j < i; j++) {
        soma += int.parse(cpf[j]) * (i + 1 - j);
      }
      int resto = soma % 11;
      int digito = resto < 2 ? 0 : 11 - resto;
      if (digito != int.parse(cpf[i])) return false;
    }
    return true;
  }

  bool validarCNPJ(String cnpj) {
    cnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    if (cnpj.length != 14) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cnpj)) return false;

    // Validação do CNPJ
    for (int i = 12; i < 14; i++) {
      int soma = 0;
      int peso = i - 7;
      for (int j = 0; j < i; j++) {
        soma += int.parse(cnpj[j]) * peso;
        peso = peso == 2 ? 9 : peso - 1;
      }
      int resto = soma % 11;
      int digito = resto < 2 ? 0 : 11 - resto;
      if (digito != int.parse(cnpj[i])) return false;
    }
    return true;
  }

  Future<void> _buscarCEP() async {
    try {
      final endereco =
          await _usuarioService.buscarEnderecoPorCEP(_cepController.text);
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

  Future<void> _selecionarDataNascimento() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      final formattedDate =
          "${dataSelecionada.day.toString().padLeft(2, '0')}/${dataSelecionada.month.toString().padLeft(2, '0')}/${dataSelecionada.year}";
      setState(() {
        _dataNascimentoController.text = formattedDate;
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
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTextField(
                        _cepController, "CEP", Icons.location_on,
                        keyboardType: TextInputType.number),
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
              _buildTextField(_logradouroController, "Logradouro", Icons.place,
                  enabled: false),
              _buildTextField(_bairroController, "Bairro", Icons.place,
                  enabled: false),
              _buildTextField(_cidadeController, "Cidade", Icons.location_city,
                  enabled: false),
              _buildTextField(_estadoController, "Estado", Icons.flag,
                  enabled: false),
              _buildDescricaoField(
                  _descricaoController, "Descrição", Icons.info),
              GestureDetector(
                onTap: _selecionarDataNascimento,
                child: AbsorbPointer(
                  child: _buildTextField(_dataNascimentoController,
                      "Data de Nascimento", Icons.calendar_today),
                ),
              ),
              _buildTextField(_cpfCnpjController, "CPF/CNPJ", Icons.badge),
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
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginPage(client: widget.client)),
                    );
                  },
                  child: Text(
                    "Já tem uma conta? Entrar",
                    style: TextStyle(color: Colors.grey),
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
      bool enabled = true}) {
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
        enabled: enabled,
        validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
      ),
    );
  }

  Widget _buildDescricaoField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFCCCCCE), width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Validação de CPF/CNPJ
      if (!validarCPF(_cpfCnpjController.text) &&
          !validarCNPJ(_cpfCnpjController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("CPF/CNPJ inválido")),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cadastrando...")),
      );

      try {
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
          cpf_cnpj: _cpfCnpjController.text,
          email: _emailController.text,
          foto: "",
          tipo: _selectedTipo ?? "",
          nome: _nameController.text,
          telefone: _telefoneController.text,
          endereco:
              "${_logradouroController.text}, ${_bairroController.text}, ${_cidadeController.text}, ${_estadoController.text}",
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
          MaterialPageRoute(
              builder: (context) => LoginPage(client: widget.client)),
        );
      } catch (e) {
        if (e is FirebaseAuthException && e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("A senha deve ter pelo menos 6 caracteres"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erro desconhecido. Tente novamente."),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }
}
