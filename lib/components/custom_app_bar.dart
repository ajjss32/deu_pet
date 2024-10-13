import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56.0); // Altura padrão do AppBar

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'assets/logo.png', // Caminho do logo no projeto
        height: 40.0,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search), // Ícone de pesquisa
          onPressed: () {
            print('Pesquisa acionada');
          },
        ),
        IconButton(
          icon: Icon(Icons.filter_list), // Ícone de filtro
          onPressed: () {
            print('Filtro aplicado');
          },
        ),
      ],
    );
  }
}
