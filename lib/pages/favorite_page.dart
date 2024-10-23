import 'package:deu_pet/mocks/mocks.dart';
import 'package:deu_pet/pages/pet_individual_page.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  final Mocks mocks = Mocks();

  FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
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
            child: GridView.builder(
              itemCount: mocks.petsMocks.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return buildCard(
                  context: context,
                  data: mocks.petsMocks[index],
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
    required Map<String, dynamic> data,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PetIndividualPage(
            data: data,
            // name: name,
            // age: age,
            // imagePath: imagePath,
          );
        }));
      },
      child: Container(
        child: Stack(children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                data['image'][0],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                removeAno('${data['name']}, ${data['age']}'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  String removeAno(String input) {
    final regex = RegExp(r'\bano(s)?\b', caseSensitive: false);
    return input.replaceAll(regex, '');
  }
}
