import 'package:deu_pet/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deu_pet/services/auth_service.dart';
import 'package:deu_pet/model/user.dart';
import 'package:deu_pet/pages/edit_profile_page.dart'; // Importe a tela de edição
import 'package:deu_pet/pages/login_page.dart'; // Importe a tela de login
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ProfilePage extends StatefulWidget {
  final StreamChatClient client;

  ProfilePage({required this.client});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Usuario? _usuario;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Registra o RouteObserver para monitorar a navegação
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }

    // Recarrega os dados do usuário sempre que a tela for acessada
    _carregarUsuario();
  }

  @override
  void dispose() {
    // Cancela a inscrição do RouteObserver
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Recarrega os dados do usuário ao voltar para a tela de perfil
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final usuario = await _authService.getUsuarioLogado();
    setState(() {
      _usuario = usuario;
    });
  }

  Future<void> _logout() async {
    await ChatService()
        .disconnectStreamChat(widget.client); // Desconecta do chat
    await _auth.signOut(); // Faz logout no Firebase

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(client: widget.client),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Perfil",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            if (_usuario != null) // Exibe o tipo de usuário como subtítulo
              Text(
                _usuario!.tipo == "adotante"
                    ? "Adotante"
                    : "Voluntário", // Verifica o tipo de usuário
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
        centerTitle: true,
      ),
      body: _usuario == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exibição da imagem do perfil
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _usuario!.foto != null
                              ? NetworkImage(_usuario!.foto!)
                              : AssetImage('assets/images/default_profile.png')
                                  as ImageProvider, // Imagem padrão caso não haja foto
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.camera_alt, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildInfoRow("Nome", _usuario!.nome, Icons.person),
                  _buildInfoRow(
                      "Email", _auth.currentUser?.email ?? '', Icons.email),
                  _buildInfoRow("Telefone", _usuario!.telefone, Icons.phone),
                  _buildInfoRow("Data de Nascimento", _usuario!.dataNascimento,
                      Icons.calendar_today),
                  _buildInfoRow("CPF/CNPJ", _usuario!.cpf_cnpj,
                      Icons.assignment), // Novo campo
                  _buildDescricaoRow(
                      "Descrição", _usuario!.descricao, Icons.info),
                  _buildInfoRow("Endereço", _usuario!.endereco, Icons.place),
                  SizedBox(height: 20),
                  // Botão de logout centralizado e menor
                  Center(
                    child: SizedBox(
                      width: 150, // Largura fixa para o botão
                      child: ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                              vertical: 12), // Altura do botão
                        ),
                        child:
                            Text('Sair', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Espaço extra para evitar sobreposição
                ],
              ),
            ),
      // Botão de edição no canto inferior direito
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega para a tela de edição
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(usuario: _usuario!),
            ),
          );
        },
        backgroundColor: Color(0xFF4E59D9), // Cor roxa padrão
        child: Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        readOnly: true,
        initialValue: value,
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
          prefixIcon: Icon(icon, color: Colors.grey),
        ),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDescricaoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity, // Largura fixa igual aos outros campos
            height: 100, // Altura fixa para o campo de descrição
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFCCCCCE), width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// RouteObserver para monitorar a navegação
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
