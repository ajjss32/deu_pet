import 'package:deu_pet/model/pet.dart';
import 'package:deu_pet/model/user.dart';
import 'package:deu_pet/services/auth_service.dart';
import 'package:deu_pet/services/chat_service.dart';
import 'package:deu_pet/services/favorito_service.dart';
import 'package:deu_pet/services/match_service.dart';
import 'package:deu_pet/services/pet_service.dart';
import 'package:deu_pet/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'deu_pet_page.dart';
import 'package:deu_pet/model/match.dart';

class SeeInterestedPage extends StatefulWidget {
  final Map<String, dynamic> dataPet;
  final StreamChatClient client;

  const SeeInterestedPage(
      {super.key, required this.dataPet, required this.client});

  @override
  State<SeeInterestedPage> createState() => _SeeInterestedPageState();
}

class _SeeInterestedPageState extends State<SeeInterestedPage> {
  // Lista de interessados com suas informações
  final List<Usuario> interestedPeople = [];
  final FavoritoService favoritoService = FavoritoService();
  final UsuarioService usuarioService = UsuarioService();
  final MatchService matchService = MatchService();
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
    for (var item in list) {
      final user = await usuarioService.buscarUsuarioPorUid(item.usuarioId);
      if (user != null) {
        interestedPeople.add(user);
      }
    }
    setState(() {});
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
                      image: NetworkImage(interestedPeople[index].foto),
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
                  onTap: () async {
                    // Redireciona para a tela de chat ao clicar no coração

                    //criar match
                    Match match = Match(
                      id: Uuid().v1(),
                      petId: widget.dataPet['id'],
                      usuarioId: interestedPeople[index].uid,
                      status: '',
                      data: DateTime.now(),
                    );

                    await matchService.criarMatch(match);

                    Pet pet = Pet.fromMap(widget.dataPet);
                    pet = pet.copyWith(
                      status: 'Aguardando adoção',
                      dataAtualizacao: DateTime.now(),
                    );

                    PetService().atualizarPet(pet, context);

                    final Usuario? user =
                        await AuthService().getUsuarioLogado();

                    Channel novoChat = await ChatService().createChannelOnMatch(
                        interestedPeople[index].uid,
                        user!.uid,
                        interestedPeople[index].nome,
                        widget.dataPet['nome'],
                        widget.dataPet['fotos'][0],
                        widget.client);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MatchScreen(chat: novoChat),
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
