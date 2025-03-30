import 'package:deu_pet/model/pet.dart';
import 'package:deu_pet/model/user.dart';
import 'package:deu_pet/services/auth_service.dart';
import 'package:deu_pet/services/pet_service.dart';
import 'package:flutter/material.dart';
import 'pet_details_page.dart';

class Mocks {
  List<Map<String, dynamic>> petsMocks = [
    {
      'name': 'Rex',
      'species': 'Cachorro',
      'age': 5,
      'sex': 'Macho',
      'size': 'Médio',
      'temperament': 'Brincalhão',
      'health': 'Bom',
      'location': 'São Paulo',
      'specialNeeds': 'Nenhuma',
      'history': 'Rex é um cão muito alegre.',
      'image': ['assets/images/pet-rex-2.jpg', 'assets/images/pet-rex-3.jpg'],
    },
    {
      'name': 'Bob',
      'species': 'Gato',
      'status': 'Aguardando confirmação',
      'age': 2,
      'sex': 'Fêmea',
      'size': 'Pequeno',
      'temperament': 'Calmo',
      'health': 'Excelente',
      'location': 'Rio de Janeiro',
      'specialNeeds': 'Nenhuma',
      'history': 'Resgatado de um abrigo.',
      'image': ['assets/images/pet1.png', 'assets/images/pet-bob-2.png'],
    },
    {
      'name': 'Bella',
      'species': 'Gato',
      'status': 'Adotado',
      'age': 1,
      'sex': 'Fêmea',
      'size': 'Pequeno',
      'temperament': 'Tímido',
      'health': 'Ótima',
      'location': 'Uberlândia',
      'specialNeeds': 'Nenhuma',
      'history': 'Muito fofa e brincalhona.',
      'image': [
        'assets/images/pet-bella.jpg',
        'assets/images/pet-bella-2.jpeg',
        'assets/images/pet-bella-3.jpg'
      ],
    },
    {
      'name': 'Thor',
      'species': 'Cachorro',
      'status': 'Aguardando confirmação',
      'age': 3,
      'sex': 'Macho',
      'size': 'Médio',
      'temperament': 'Brincalhão',
      'health': 'Saudável',
      'location': 'Uberlândia',
      'specialNeeds': 'Nenhuma',
      'history': 'Um amigo fiel e divertido.',
      'image': ['assets/images/pet3.jpg'],
    }
  ];
}

class PetListScreen extends StatefulWidget {
  PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  // final Mocks mocks = Mocks();
  final List<Pet> mocks = [];
  final PetService petService = PetService();

  @override
  void initState() {
    _getPets();
    super.initState();
  }

  _getPets() async {
    final Usuario? user = await AuthService().getUsuarioLogado();
    // mocks = await PetService().buscarPetsPorUsuario(user!.uid);
    final pets = await petService.buscarPetsPorUsuario(user!.uid);

    mocks.addAll(pets);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (mocks.isEmpty) {
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
              'Nenhum animal cadastrado',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Animais Cadastrados',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              // itemCount: mocks.petsMocks.length,
              itemCount: mocks.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return buildCard(
                  context: context,
                  data: mocks[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required BuildContext context,
    required Pet data,
  }) {
    String status = data.status ?? 'Disponível'; // Defina o status padrão

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PetDetailsPage(data: data);
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  //TODO: imagem place holder, subtituir
                  data.foto,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(status), // Cor conforme status
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '${data.nome}, ${data.idade}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aguardando confirmação':
        return Colors.orange;
      case 'Adotado':
        return Colors.green;
      case 'Disponível':
      default:
        return Colors.blue;
    }
  }
}
