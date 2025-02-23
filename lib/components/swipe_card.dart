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
      'name': 'Bob',
      'age': '2 anos',
      'description': 'Bob é um gato amigável e cheio de energia.',
      'image': 'assets/images/pet1.png'
    },
    {
      'name': 'Thor',
      'age': '3 anos',
      'description': 'Thor adora aventuras ao ar livre e corridas.',
      'image': 'assets/images/pet3.jpg'
    },
    {
      'name': 'Luna',
      'age': '1 ano',
      'description': 'Luna é uma cadelinha carinhosa e adora brincar.',
      'image': 'assets/images/pet4.jpg'
    },
    {
      'name': 'Max',
      'age': '4 anos',
      'description': 'Max é um cachorro protetor e muito leal.',
      'image': 'assets/images/pet5.jpg'
    },
    {
      'name': 'Mia',
      'age': '3 anos',
      'description': 'Mia é uma cadelinha elegante que adora relaxar.',
      'image': 'assets/images/pet6.jpg'
    },
    {
      'name': 'Zeca',
      'age': '5 anos',
      'description': 'Zeca é um gato esperto que ama desafios.',
      'image': 'assets/images/pet9.png'
    },
    {
      'name': 'Bella',
      'age': '2 anos',
      'description': 'Bella é uma cachorrinha dócil e muito sociável.',
      'image': 'assets/images/pet10.jpeg'
    },
    {
      'name': 'Nina',
      'age': '9 anos',
      'description': 'Nina é uma gatinha curiosa e cheia de energia.',
      'image': 'assets/images/pet12.jpeg'
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
                // A chamada para _showFavoriteDialog foi removida
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
                            // A chamada para _showFavoriteDialog foi removida
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
}
