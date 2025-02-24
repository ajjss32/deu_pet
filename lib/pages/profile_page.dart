import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deu_pet/pages/login_page.dart';
import 'package:deu_pet/services/auth_service.dart';
import 'package:deu_pet/model/user.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario?>(
      future: _authService.getUsuarioLogado(),
      builder: (BuildContext context, AsyncSnapshot<Usuario?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar o perfil: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Usuário não encontrado.'));
        }

        Usuario usuario = snapshot.data!;
        String name = usuario.nome;
        String? email = _auth.currentUser?.email;

        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(radius: 60),
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
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: name),
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: email),
                  readOnly: true,
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Sair', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
