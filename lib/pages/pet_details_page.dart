import 'package:deu_pet/model/pet.dart';
import 'package:flutter/material.dart';
import 'package:deu_pet/components/info_widget.dart';
import 'package:deu_pet/components/custom_app_bar.dart';
import 'see_interested_page.dart'; // Importe a página de interessados

class PetDetailsPage extends StatelessWidget {
  final Pet data;

  const PetDetailsPage({Key? key, required this.data}) : super(key: key);

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
                      dataPet: data.toMap(),
                    ), // Sem precisar passar a lista de interessados
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
    return Column(
      children: [
        SizedBox(height: 16), // Menor espaçamento superior
        Expanded(
          flex: 20,
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Menor padding geral
            child: ListView.builder(
              // itemCount: data['image'].length,
              //TODO: nao existe uma lista de imagens no objeto pet
              itemCount: 0,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(4.0), // Menor padding
                  width: 180, // Menor largura para visualização mobile
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      // data['image'][index],
                      data.foto,
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
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.5,
              children: [
                InfoWidget(title: 'Nome', value: data.nome, fontSize: 14),
                InfoWidget(
                    title: 'Espécie/Raça', value: data.especie, fontSize: 14),
                InfoWidget(
                    title: 'Idade', value: '${data.idade} anos', fontSize: 14),
                InfoWidget(title: 'Sexo', value: data.sexo, fontSize: 14),
                InfoWidget(title: 'Porte', value: data.porte, fontSize: 14),
                InfoWidget(
                    title: 'Temperamento',
                    value: data.temperamento,
                    fontSize: 14),
                InfoWidget(
                    title: 'Estado de saúde',
                    value: data.estadoDeSaude,
                    fontSize: 14),
                InfoWidget(
                    title: 'Localização', value: data.endereco, fontSize: 14),
                InfoWidget(
                    title: 'Necessidades especiais',
                    value: data.necessidades,
                    fontSize: 14),
                InfoWidget(
                    title: 'História', value: data.historia, fontSize: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
