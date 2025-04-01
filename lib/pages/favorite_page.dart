import 'package:deu_pet/model/favorito.dart';
import 'package:deu_pet/model/pet.dart';
import 'package:deu_pet/pages/pet_individual_page.dart';
import 'package:deu_pet/services/favorito_service.dart';
import 'package:deu_pet/services/pet_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FavoritoService favoritoService = FavoritoService();
  final PetService petService = PetService();

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        body: Center(child: Text('Usuário não autenticado')),
      );
    }

    return Scaffold(
      body: _buildBody(userId, context),
    );
  }

  Widget _buildBody(String userId, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Favoritos',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Favorito>>(
              future:
                  favoritoService.buscarFavoritosPorUsuario(userId, context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pets,
                          size: 100,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Erro ao carregar favoritos',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pets,
                          size: 100,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum favorito encontrado',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final favoritos = snapshot.data!;

                return FutureBuilder<List<Pet>>(
                  future: Future.wait(
                    favoritos.map((favorito) =>
                        petService.buscarPet(favorito.petId, context)),
                  ).then((pets) => pets.whereType<Pet>().toList()),
                  builder: (context, petSnapshot) {
                    if (petSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (petSnapshot.hasError) {
                      return Center(child: Text('Erro ao carregar pets'));
                    } else if (!petSnapshot.hasData ||
                        petSnapshot.data!.isEmpty) {
                      return Center(child: Text('Nenhum pet encontrado'));
                    }

                    final pets = petSnapshot.data!;

                    return GridView.builder(
                      itemCount: pets.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        return buildCard(
                          context: context,
                          pet: pets[index],
                          favoritoId: favoritos[index].id, // Passando ID
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildCard({
    required BuildContext context,
    required Pet pet,
    required String favoritoId,
  }) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetIndividualPage(
              data: pet.toMap(),
              favoritoId: favoritoId,
            ),
          ),
        );

        if (result == true) {
          setState(() {}); // Atualiza a página ao remover favorito
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  pet.fotos.isNotEmpty
                      ? pet.fotos.first
                      : 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  removeAno('${pet.nome}, ${pet.idade}'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String removeAno(String input) {
    final regex = RegExp(r'\bano(s)?\b', caseSensitive: false);
    return input.replaceAll(regex, '');
  }
}
