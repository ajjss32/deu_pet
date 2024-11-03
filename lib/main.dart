import 'package:deu_pet/pages/favorite_page.dart';
import 'package:flutter/material.dart';
import 'components/custom_app_bar.dart';
import 'components/custom_bottom_nav_bar.dart';
import 'components/swipe_card.dart';
import 'screens/favorite_screen.dart';

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
  List<Map<String, String>> favoritePets = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

<<<<<<< HEAD
  void _showFavorites() {
=======
  // Função que retorna o conteúdo baseado no índice selecionado
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return SwipeCard(
            showFavorites: _goToFavorites); // Passa a função para SwipeCard
      case 1:
        return Center(
            child: Text('Buscar Página')); // Placeholder para "Buscar"
      case 2:
        return Center(child: FavoritePage()); // Placeholder para "Favoritos"
      case 3:
        return Center(child: Text('Chat Página')); // Placeholder para "Chat"
      case 4:
        return Center(
            child: Text('Perfil Página')); // Placeholder para "Perfil"
      default:
        return Center(child: Text('Página desconhecida'));
    }
  }

  // Função para alterar o índice para a aba Favoritos
  void _goToFavorites() {
>>>>>>> origin/main
    setState(() {
      _selectedIndex = 2; // Índice da aba de Favoritos
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    switch (_selectedIndex) {
      case 0:
        currentPage = SwipeCard(
          showFavorites: _showFavorites,
          favoritePets: favoritePets,
        );
        break;
      case 2:
        currentPage = FavoriteScreen(favoritePets: favoritePets);
        break;
      default:
        currentPage = Center(child: Text('Outra página'));
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: currentPage,
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
