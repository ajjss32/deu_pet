import 'package:deu_pet/model/user.dart';
import 'package:deu_pet/services/favorito_service.dart';
import 'package:flutter/material.dart';
import 'deu_pet_page.dart'; // Importa a tela de chat

class SeeInterestedPage extends StatefulWidget {
  final Map<String, dynamic> dataPet;

  const SeeInterestedPage({super.key, required this.dataPet});

  @override
  State<SeeInterestedPage> createState() => _SeeInterestedPageState();
}

class _SeeInterestedPageState extends State<SeeInterestedPage> {
  // Lista de interessados com suas informações
  final List<Usuario> interestedPeople = [];
  final FavoritoService favoritoService = FavoritoService();
  // final List<Map<String, String>> interestedPeople = [
  //   {
  //     'name': 'Maria Oliveira',
  //     'age': '34 anos',
  //     'city': 'Rio de Janeiro',
  //     'contact': 'maria.oliveira@email.com',
  //     'image': 'assets/images/person2.jpg', // Caminho da imagem
  //   },
  //   {
  //     'name': 'João Silva',
  //     'age': '28 anos',
  //     'city': 'São Paulo',
  //     'contact': 'joao.silva@email.com',
  //     'image': 'assets/images/person1.jpg', // Caminho da imagem
  //   },

  //   {
  //     'name': 'Carlos Souza',
  //     'age': '22 anos',
  //     'city': 'Belo Horizonte',
  //     'contact': 'carlos.souza@email.com',
  //     'image': 'assets/images/person3.jpg', // Caminho da imagem
  //   },
  //   // Adicione mais interessados conforme necessário
  // ];

  @override
  void initState() {
    _getInterestedPeople();

    super.initState();
  }

  _getInterestedPeople() async {
    final list = await favoritoService.buscarFavoritosPorPet(
        widget.dataPet['id'], context);
    print(list);
    // setState(() {
    //   interestedPeople.addAll(list);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interessados em adotar"),
      ),
      body: ListView.builder(
        itemCount: interestedPeople.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                leading: Container(
                  width: 60.0, // Largura personalizada
                  height: 120.0, // Altura personalizada
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10.0), // Bordas arredondadas
                    image: DecorationImage(
                      // image: AssetImage(interestedPeople[index]['image']!),
                      image: AssetImage(interestedPeople[index].foto),
                      fit: BoxFit.cover, // Ajusta a imagem para cobrir o espaço
                    ),
                  ),
                ),
                title: Text(
                  interestedPeople[index].nome,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(interestedPeople[index].dataNascimento),
                    Text(interestedPeople[index].endereco),
                    Text(interestedPeople[index].telefone),
                  ],
                ),
                trailing: GestureDetector(
                  onTap: () {
                    // Redireciona para a tela de chat ao clicar no coração
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(), // Tela de chat
                      ),
                    );
                  },
                  child: Icon(
                    Icons.favorite_border,
                    color: const Color.fromARGB(255, 85, 16, 224),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
