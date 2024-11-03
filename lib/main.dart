import 'package:deu_pet/pages/favorite_page.dart';
import 'package:deu_pet/pages/pet_registration.dart';
import 'package:flutter/material.dart';
import 'components/custom_app_bar.dart';
import 'components/custom_bottom_nav_bar.dart';
import 'components/swipe_card.dart';

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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
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

  // Função que retorna o conteúdo baseado no índice selecionado
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return SwipeCard(
            showFavorites: _goToFavorites); // Passa a função para SwipeCard
      case 1:
        return Center(child: FavoritePage()); // Placeholder para "Favoritos"
      case 2:
        return Center(child: Text('Chat Página')); // Placeholder para "Chat"
      case 3:
        return Center(child: PetRegistration()); // Placeholder para "Chat"
      case 4:
        return Center(
            child: Text('Perfil Página')); // Placeholder para "Perfil"
      default:
        return Center(child: Text('Página desconhecida'));
    }
  }

  // Função para alterar o índice para a aba Favoritos
  void _goToFavorites() {
    setState(() {
      _selectedIndex = 2; // Define o índice da aba Favoritos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _buildContent(), // Exibe o conteúdo com base no índice selecionado
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
