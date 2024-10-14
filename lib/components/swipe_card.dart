import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class SwipeCard extends StatefulWidget {
  final VoidCallback showFavorites; // Função passada pela HomeScreen

  SwipeCard({required this.showFavorites});

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
          Expanded(
            child: CardSwiper(
              controller: controller,
              cardsCount: _pets.length,
              onSwipe: (previousIndex, currentIndex, direction) {
                if (direction == CardSwiperDirection.left) {
                  _showFavoriteDialog(context);
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
                      // Primeiro, fecha o pop-up
                      Navigator.of(context).pop();

                      // Em seguida, altera para a aba de favoritos
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
}
