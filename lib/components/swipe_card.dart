import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class SwipeCard extends StatefulWidget {
  final VoidCallback showFavorites;
  final List<Map<String, String>> favoritePets;

  SwipeCard({required this.showFavorites, required this.favoritePets});

  @override
  _SwipeCardState createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard>
    with AutomaticKeepAliveClientMixin {
  final CardSwiperController controller = CardSwiperController();
  final Set<String> _addedPetIds =
      {}; // Para rastrear IDs de pets já adicionados
  int _currentIndex = 0; // Variável para armazenar o índice atual

  final List<Map<String, String>> _pets = [
    {
      'id': '1', // Adicione um ID único para cada pet
      'name': 'Ivan',
      'age': '2 anos',
      'description': 'Rex é um gato amigável e cheio de energia.',
      'image': 'assets/images/pet1.png'
    },
    {
      'id': '2',
      'name': 'Luna',
      'age': '1 ano',
      'description': 'Luna é uma gata carinhosa e brincalhona.',
      'image': 'assets/images/pet2.png'
    },
    {
      'id': '3',
      'name': 'Thor',
      'age': '3 anos',
      'description': 'Thor adora bolinhas de papel e churu.',
      'image': 'assets/images/pet3.png'
    },
    {
      'id': '4',
      'name': 'Ze',
      'age': '1 anos',
      'description': 'Ze adora aventuras ao ar livre e corridas.',
      'image': 'assets/images/pet4.png'
    },
    {
      'id': '5',
      'name': 'Caramelo',
      'age': '4 anos',
      'description': 'Camero adora gravetos e brincar na grama.',
      'image': 'assets/images/pet5.png'
    },
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Para o AutomaticKeepAliveClientMixin funcionar
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: CardSwiper(
              controller: controller,
              cardsCount: _pets.length,
              initialIndex: _currentIndex, // Define o índice inicial
              onSwipe: (previousIndex, currentIndex, direction) {
                setState(() {
                  _currentIndex = currentIndex ?? 0; // Atualiza o índice atual
                });

                if (direction == CardSwiperDirection.right) {
                  final pet = _pets[previousIndex];
                  if (!_addedPetIds.contains(pet['id'])) {
                    // Verifica pelo ID
                    setState(() {
                      widget.favoritePets.add(pet);
                      _addedPetIds.add(pet['id']!); // Adiciona o ID ao conjunto
                    });
                    _showFavoriteDialog(context);
                  } else {
                    // Exibe um alerta caso o pet já esteja na lista
                    _showAlreadyAddedDialog(context);
                  }
                }
                return true;
              },
              numberOfCardsDisplayed: 1,
              backCardOffset: Offset.zero,
              padding: const EdgeInsets.all(0.0),
              cardBuilder: (context, index, _, __) {
                final pet = _pets[index];
                return Card(
                  margin: EdgeInsets.zero,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        pet['image']!,
                        fit: BoxFit.cover,
                      ),
                      Container(
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
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  pet['age']!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
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
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 80,
                        child: _buildIconButton(
                          icon: Icons.cancel,
                          color: Color(0xFFF7566B),
                          onPressed: () =>
                              controller.swipe(CardSwiperDirection.left),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 80,
                        child: _buildIconButton(
                          icon: Icons.favorite,
                          color: Color(0xFF20ECB9),
                          onPressed: () {
                            controller.swipe(CardSwiperDirection.right);
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
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1),
        ),
        child: Center(
          child: Icon(icon, color: color, size: 38),
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
          backgroundColor: Colors.white.withOpacity(0.9),
          content: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Pet adicionado à lista de favoritos!',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF20ECB9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.showFavorites();
                    },
                    child: Text(
                      'Ir para lista de favoritos!',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -10,
                right: -10,
                child: IconButton(
                  icon: Icon(Icons.cancel, color: Color(0xFFF7566B)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAlreadyAddedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white.withOpacity(0.9),
          content: Text(
            'Esse pet já está na lista de favoritos!',
            style: TextStyle(fontSize: 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true; // Garante que o estado seja mantido
}
