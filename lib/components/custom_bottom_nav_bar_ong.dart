import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CustomBottomNavBarOng extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  CustomBottomNavBarOng(
      {required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'Cadastro Animal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pets), // Novo ícone de "Animais Cadastrados"
          label: 'Animais',
        ),
        BottomNavigationBarItem(
          icon: StreamBuilder<int>(
            stream: StreamChat.of(context).client.state.totalUnreadCountStream,
            builder: (context, snapshot) {
              final unreadCount = snapshot.data ?? 0;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.chat),
                  if (unreadCount > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(0xFF4E59D9),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          label: 'Chat',
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
