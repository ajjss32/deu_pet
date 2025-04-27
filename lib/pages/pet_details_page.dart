import 'package:deu_pet/model/pet.dart';
import 'package:deu_pet/services/pet_service.dart';
import 'package:flutter/material.dart';
import 'package:deu_pet/components/info_widget.dart';
import 'package:deu_pet/components/custom_app_bar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'see_interested_page.dart';

class PetDetailsPage extends StatelessWidget {
  final Pet data;
  final StreamChatClient client;

  const PetDetailsPage({Key? key, required this.data, required this.client})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _buildBody(context), // Passando o contexto para o método
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              backgroundColor: Colors.white,
              onPressed: () {
                // Navega até a página de interessados sem passar dados
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeeInterestedPage(
                        dataPet: data.toMap(), client: client),
                  ),
                );
              },
              label: Text("Ver Interessados",
                  style: TextStyle(color: Colors.blue)),
              icon: Icon(Icons.visibility, color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final PetService petService = PetService();
    ;
    return Column(
      children: [
        SizedBox(height: 16), // Menor espaçamento superior
        Expanded(
          flex: 20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: data.fotos.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(4.0),
                  width: 180,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      data.fotos[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.nome,
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(width: 4),
              Icon(Icons.pets, color: Color(0xFF7C8692), size: 24),
            ],
          ),
        ),

        Expanded(
          flex: 30,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 60.0),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: InfoWidget(
                      title: 'Espécie/Raça',
                      value: data.especie + '/' + data.raca,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: InfoWidget(
                      title: 'Idade',
                      value:
                          '${petService.formatarIdade(data.dataDeNascimento)}',
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: InfoWidget(
                        title: 'Sexo', value: data.sexo, fontSize: 14),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: InfoWidget(
                        title: 'Porte', value: data.porte, fontSize: 14),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: InfoWidget(
                      title: 'Temperamento',
                      value: data.temperamento,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: InfoWidget(
                      title: 'Estado de saúde',
                      value: data.estadoDeSaude,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: InfoWidget(
                      title: 'Localização',
                      value: data.endereco,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: InfoWidget(
                      title: 'Necessidades especiais',
                      value: data.necessidades,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: InfoWidget(
                      title: 'História',
                      value: data.historia,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: InfoWidget(
                      title: 'Status',
                      value: data.status,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
