import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Map<String, String>> favoritePets;

  FavoriteScreen({required this.favoritePets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
      ),
      body: favoritePets.isEmpty
          ? Center(child: Text('Nenhum pet adicionado aos favoritos ainda.'))
          : GridView.builder(
              padding: EdgeInsets.all(8.0), // Espaço ao redor do Grid
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de colunas
                crossAxisSpacing: 8.0, // Espaço entre as colunas
                mainAxisSpacing: 8.0, // Espaço entre as linhas
                childAspectRatio: 0.65, // Proporção do espaço para cada item
              ),
              itemCount: favoritePets.length,
              itemBuilder: (context, index) {
                final pet = favoritePets[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(16.0), // Bordas arredondadas
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 1,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  clipBehavior: Clip
                      .antiAlias, // Para garantir que a imagem não ultrapasse as bordas
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        pet['image']!,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: Colors.black.withOpacity(
                            0.3), // Adiciona uma camada preta semitransparente
                      ),
                      Positioned(
                        bottom: 8.0,
                        left: 8.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            pet['name']!,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
