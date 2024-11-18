import 'package:flutter/material.dart';
import 'package:deu_pet/pages/favorite_page.dart';
import 'package:deu_pet/pages/pet_registration.dart';
import 'package:deu_pet/pages/pet_lista.dart';
import 'components/custom_app_bar.dart';
import 'components/custom_bottom_nav_bar.dart';
import 'components/custom_bottom_nav_bar_ong.dart';
import 'components/swipe_card.dart';

// Página para escolha do tipo de usuário (Adotante ou Voluntário)
class UserTypePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Escolha seu Tipo de Usuário")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo centralizado
            Image.asset(
              'assets/logo.png', // Substitua pelo caminho correto da sua imagem
              width: 150,
              height: 150,
            ),
            SizedBox(height: 40), // Espaço entre o logo e os botões

            // Botão "Adotante"
            ElevatedButton(
              onPressed: () {
                // Ação do botão "Adotante"
                print("Adotante escolhido");
                // Navegar para a HomeScreen e definir o tipo de usuário
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(userType: 'adotante'),
                  ),
                );
              },
              child: Text("Adotante"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20), // Espaço entre os botões

            // Botão "Voluntário"
            ElevatedButton(
              onPressed: () {
                // Ação do botão "Voluntário"
                print("Voluntário escolhido");
                // Navegar para a HomeScreen e definir o tipo de usuário
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(userType: 'voluntario'),
                  ),
                );
              },
              child: Text("Voluntário"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deu Pet - Tinder Swiping',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserTypePage(), // Tela inicial para escolher o tipo de usuário
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String userType; // Recebe o tipo de usuário como parâmetro

  HomeScreen({required this.userType});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Função que é chamada ao tocar em um item do BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Função que retorna o conteúdo baseado no índice selecionado e no tipo de usuário
  Widget _buildContent() {
    if (widget.userType == 'adotante') {
      // Conteúdo para Adotante
      switch (_selectedIndex) {
        case 0:
          return SwipeCard(showFavorites: _goToFavorites);
        case 1:
          return FavoritePage();
        case 2:
          return Center(child: Text('Chat Página'));
        case 3:
          return Center(child: Text('Perfil Página'));
        default:
          return Center(child: Text('Página desconhecida'));
      }
    } else if (widget.userType == 'voluntario') {
      // Conteúdo para Voluntário/Ong
      switch (_selectedIndex) {
        case 0:
          return PetRegistration(); // Cadastro de animal
        case 1:
          return PetListScreen(); // Listagem de animais
        case 2:
          return Center(child: Text('Chat Página'));
        case 3:
          return Center(child: Text('Perfil Página'));
        default:
          return Center(child: Text('Página desconhecida'));
      }
    }
    return Center(child: Text('Tipo de usuário desconhecido'));
  }

  // Função para alterar o índice para a aba Favoritos
  void _goToFavorites() {
    setState(() {
      _selectedIndex = 1; // Define o índice da aba Favoritos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _buildContent(), // Exibe o conteúdo com base no índice selecionado
      bottomNavigationBar: widget.userType == 'adotante'
          ? CustomBottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            )
          : CustomBottomNavBarOng(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
    );
  }
}
