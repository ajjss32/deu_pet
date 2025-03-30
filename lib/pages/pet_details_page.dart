import 'package:flutter/material.dart';
import 'package:deu_pet/components/info_widget.dart';
import 'package:deu_pet/components/custom_app_bar.dart';
import 'see_interested_page.dart'; // Importe a página de interessados

class PetDetailsPage extends StatelessWidget {
  final Map<String, dynamic> data;

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
                      dataPet: data,
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
              itemCount: data['image'].length,
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
                      data['image'][index],
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
                data['name'],
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
                InfoWidget(title: 'Nome', value: data['name'], fontSize: 14),
                InfoWidget(
                    title: 'Espécie/Raça',
                    value: data['species'],
                    fontSize: 14),
                InfoWidget(
                    title: 'Idade', value: '${data['age']} anos', fontSize: 14),
                InfoWidget(title: 'Sexo', value: data['sex'], fontSize: 14),
                InfoWidget(title: 'Porte', value: data['size'], fontSize: 14),
                InfoWidget(
                    title: 'Temperamento',
                    value: data['temperament'],
                    fontSize: 14),
                InfoWidget(
                    title: 'Estado de saúde',
                    value: data['health'],
                    fontSize: 14),
                InfoWidget(
                    title: 'Localização',
                    value: data['location'],
                    fontSize: 14),
                InfoWidget(
                    title: 'Necessidades especiais',
                    value: data['specialNeeds'],
                    fontSize: 14),
                InfoWidget(
                    title: 'História', value: data['history'], fontSize: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
