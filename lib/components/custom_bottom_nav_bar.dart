import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  CustomBottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'Cadastro Animal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pets), // Novo ícone de "Animais Cadastrados"
          label: 'Animais',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Color(0xFF4E59D9), // Cor do item selecionado
      unselectedItemColor: Color(0xFF7C8692), // Cor dos itens não selecionados
      onTap: onItemTapped,
    );
  }
}
