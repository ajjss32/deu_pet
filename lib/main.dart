import 'package:deu_pet/pages/chat/chat_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deu_pet/pages/favorite_page.dart';
import 'package:deu_pet/pages/profile_page.dart';
import 'package:deu_pet/pages/login_page.dart';
import 'package:deu_pet/pages/pet_registration.dart';
import 'package:deu_pet/pages/pet_lista.dart';
import 'components/custom_app_bar.dart';
import 'components/custom_bottom_nav_bar.dart';
import 'components/custom_bottom_nav_bar_ong.dart';
import 'components/swipe_card.dart';
import 'firebase_options.dart';
import 'package:deu_pet/model/user.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final StreamChatClient client = StreamChatClient(
    'gjp3ycatuazs',
    logLevel: Level.INFO,
  );

  await FirebaseAuth.instance.signOut();

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final StreamChatClient client;

  MyApp({required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deu Pet - Tinder Swiping',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        return StreamChat(
          client: client,
          streamChatThemeData: StreamChatThemeData.light(),
          child: child!,
        );
      },
      home: LoginPage(client: client),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String userType;
  final StreamChatClient client;

  HomeScreen({required this.userType, required this.client});

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(userType: userType, client: client);
}

class _HomeScreenState extends State<HomeScreen> {
  final String userType;
  final StreamChatClient client;

  _HomeScreenState({required this.userType, required this.client});

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildContent() {
    if (userType == 'adotante') {
      switch (_selectedIndex) {
        case 0:
          return SwipeCard(showFavorites: _goToFavorites);
        case 1:
          return FavoritePage();
        case 2:
          return ChannelListPage(client: client);
        case 3:
          return ProfilePage(client: client);
        default:
          return Center(child: Text('Página desconhecida'));
      }
    } else if (userType == 'voluntario') {
      switch (_selectedIndex) {
        case 0:
          return PetRegistration();
        case 1:
          return PetListScreen(client: client);
        case 2:
          return ChannelListPage(client: client);
        case 3:
          return ProfilePage(client: client);
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
