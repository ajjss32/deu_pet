import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:deu_pet/pages/favorite_page.dart';
import 'package:deu_pet/pages/user_registration.dart';
import 'package:deu_pet/pages/profile_page.dart';
import 'package:deu_pet/pages/login_page.dart';
import 'package:deu_pet/pages/login_signupp_page.dart';
import 'package:deu_pet/pages/pet_registration.dart';
import 'package:deu_pet/pages/pet_lista.dart';
import 'package:deu_pet/services/auth_service.dart';
import 'components/custom_app_bar.dart';
import 'components/custom_bottom_nav_bar.dart';
import 'components/custom_bottom_nav_bar_ong.dart';
import 'components/swipe_card.dart';
import 'firebase_options.dart';
import 'package:deu_pet/model/user.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: LoginPage(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String userType;

  HomeScreen({required this.userType});

  @override
  _HomeScreenState createState() => _HomeScreenState(userType: userType);
}

class _HomeScreenState extends State<HomeScreen> {
  final String userType;

  _HomeScreenState({required this.userType});

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          return ProfilePage();
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
          return ProfilePage();
        default:
          return Center(child: Text('Página desconhecida'));
      }
    }
    return Center(child: Text('Tipo de usuário desconhecido'));
  }

  void _goToFavorites() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _buildContent(),
      bottomNavigationBar: userType == 'adotante'
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
