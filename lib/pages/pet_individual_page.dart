import 'package:deu_pet/components/custom_app_bar.dart';
import 'package:deu_pet/components/info_widget.dart';
import 'package:deu_pet/model/pet.dart';
import 'package:deu_pet/services/favorito_service.dart';
import 'package:deu_pet/services/pet_service.dart';
import 'package:flutter/material.dart';

class PetIndividualPage extends StatefulWidget {
  final Pet data;
  final String? favoritoId; // Adicionado para garantir ID do favorito

  const PetIndividualPage({super.key, required this.data, this.favoritoId});

  @override
  _PetIndividualPageState createState() => _PetIndividualPageState();
}

class _PetIndividualPageState extends State<PetIndividualPage> {
  final FavoritoService favoritoService = FavoritoService();
  final PetService petService = PetService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _buildBody(),
      floatingActionButton: widget.favoritoId != null
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () => _removerDoFavorito(context),
              child: Icon(Icons.delete, color: Colors.red),
            )
          : null, // Se não houver ID do favorito, não exibe o botão
    );
  }

  void _removerDoFavorito(BuildContext context) async {
    if (widget.favoritoId == null) {
      return;
    }
    await favoritoService.deletarFavorito(widget.favoritoId!);

    int favoritosRestantes =
        (await favoritoService.buscarFavoritosPorPet(widget.data.id, context))
            .length;

    if (favoritosRestantes == 0) {
      Pet petAtualizado = widget.data;
      petAtualizado.status = 'Disponível';

      await PetService().atualizarPet(petAtualizado, context);
    }

    Navigator.pop(context, true);
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 24),
          _buildImageCarousel(),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.data.nome,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.pets, color: Colors.grey[700]),
              ],
            ),
          ),
          _buildInfoGrid(),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    List<dynamic> images = widget.data.fotos;

    if (images.isEmpty) {
      images = [
        'https://via.placeholder.com/200'
      ]; // Imagem fixa caso não haja imagens disponíveis
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                images[index],
                width: 200,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 60.0),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 20,
              child: InfoWidget(
                title: 'Espécie/Raça',
                value: widget.data.especie + '/' + widget.data.raca,
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 20,
              child: InfoWidget(
                title: 'Idade',
                value: '${petService.formatarIdade(widget.data.dataDeNascimento)}',
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 20,
              child: InfoWidget(title: 'Sexo', value: widget.data.sexo, fontSize: 14),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 20,
              child:
                  InfoWidget(title: 'Porte', value: widget.data.porte, fontSize: 14),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 20,
              child: InfoWidget(
                title: 'Temperamento',
                value: widget.data.temperamento,
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 20,
              child: InfoWidget(
                title: 'Estado de saúde',
                value: widget.data.estadoDeSaude,
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 20,
              child: InfoWidget(
                title: 'Localização',
                value: widget.data.endereco,
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 20,
              child: InfoWidget(
                title: 'Necessidades especiais',
                value: widget.data.necessidades,
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 20,
              child: InfoWidget(
                title: 'História',
                value: widget.data.historia,
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 20,
              child: InfoWidget(
                title: 'Status',
                value: widget.data.status,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
