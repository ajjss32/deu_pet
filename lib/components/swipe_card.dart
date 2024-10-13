import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class SwipeCard extends StatefulWidget {
  @override
  _SwipeCardState createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  final CardSwiperController controller = CardSwiperController();

  final List<Map<String, String>> _pets = [
    {
      'name': 'Rex',
      'age': '2 anos',
      'description': 'Rex é um gato amigável e cheio de energia.',
      'image': 'assets/images/pet1.png'
    },
    {
      'name': 'Luna',
      'age': '1 ano',
      'description': 'Luna é uma gata carinhosa e brincalhona.',
      'image': 'assets/images/pet2.png'
    },
    {
      'name': 'Thor',
      'age': '3 anos',
      'description': 'Thor adora aventuras ao ar livre e corridas.',
      'image': 'assets/images/pet3.png'
    },
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Flexible(
            child: CardSwiper(
              controller: controller,
              cardsCount: _pets.length,
              onSwipe: (previousIndex, currentIndex, direction) {
                if (direction == CardSwiperDirection.left) {
                  _showFavoriteDialog(context);
                }
                return true;
              },
              numberOfCardsDisplayed: 1, // Exibe apenas 1 card por vez
              backCardOffset:
                  Offset.zero, // Remove o deslocamento da próxima carta
              padding: const EdgeInsets.all(16.0),
              cardBuilder: (context, index, _, __) {
                final pet = _pets[index];
                return Card(
                  child: Stack(
                    children: [
                      // Imagem do pet
                      Image.asset(
                        pet['image']!,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height *
                            0.9, // Ajusta o tamanho da imagem
                        width: double.infinity,
                      ),
                      // Sobreposição escura para dar destaque ao texto
                      Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      // Texto sobre a imagem (nome, idade e descrição)
                      Positioned(
                        bottom: 100,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  pet['name']!,
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  pet['age']!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              pet['description']!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Ícones abaixo do nome e idade
                      Positioned(
                        bottom: 10, // Abaixo do nome e da descrição
                        left: 80,
                        child: _buildIconButton(
                          icon: Icons.cancel,
                          color: Color(0xFFF7566B), // Cor da borda de cancelar
                          onPressed: () =>
                              controller.swipe(CardSwiperDirection.left),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 80,
                        child: _buildIconButton(
                          icon: Icons.favorite,
                          color: Color(0xFF20ECB9), // Cor da borda de favorito
                          onPressed: () {
                            controller.swipe(CardSwiperDirection.right);
                            _showFavoriteDialog(context);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 70, // Tamanho do círculo
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color, // Define a cor da borda com base no ícone
            width: 1, // Reduz o tamanho da borda
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color, // Define a cor do ícone
            size: 38, // Tamanho do ícone
          ),
        ),
      ),
    );
  }

  void _showFavoriteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white.withOpacity(
              0.9), // Tornar o fundo do pop-up um pouco transparente
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Pet adicionado à lista de favoritos!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.cancel, color: Color(0xFFF7566B)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Container(
            height: 60,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Para evitar overflow
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF20ECB9), // Cor do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Redirecionar para a lista de favoritos
                  },
                  child: Text(
                    'Ir para lista de favoritos!',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
