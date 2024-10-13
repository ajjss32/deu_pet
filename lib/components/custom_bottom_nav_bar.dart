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
          icon: Icon(Icons.water_drop), // Ícone de gota
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.widgets),
          label: 'Buscar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star), // Ícone personalizado de estrela
          label: 'Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat), // Ícone de chat
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person), // Ícone de perfil
          label: 'Perfil',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Color(0xFF4E59D9), // Cor do item selecionado (#7C8692)
      unselectedItemColor: Color(0xFF7C8692), // Cor dos itens não selecionados
      onTap: onItemTapped,
    );
  }
}
