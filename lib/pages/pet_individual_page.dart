import 'package:deu_pet/components/custom_app_bar.dart';
import 'package:deu_pet/components/info_widget.dart';
import 'package:deu_pet/model/pet.dart';
import 'package:deu_pet/services/favorito_service.dart';
import 'package:deu_pet/services/pet_service.dart';
import 'package:flutter/material.dart';

class PetIndividualPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final String? favoritoId; // Adicionado para garantir ID do favorito

  const PetIndividualPage({super.key, required this.data, this.favoritoId});

  @override
  _PetIndividualPageState createState() => _PetIndividualPageState();
}

class _PetIndividualPageState extends State<PetIndividualPage> {
  final FavoritoService favoritoService = FavoritoService();

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

    int favoritosRestantes = (await favoritoService.buscarFavoritosPorPet(
            widget.data['id'], context))
        .length;

    if (favoritosRestantes == 0) {
      Pet petAtualizado = Pet.fromMap(widget.data);
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
                  widget.data['nome'] ?? 'Nome Desconhecido',
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
    List<dynamic> images = widget.data['image'] ?? [];

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
      padding: const EdgeInsets.all(24.0),
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        children: [
          InfoWidget(
              title: 'Espécie/Raça',
              value: (widget.data['especie'] ?? 'Desconhecido') + ' / ' + (widget.data['raca'] ?? 'Desconhecido')),
          InfoWidget(
              title: 'História',
              value: widget.data['historia'] ?? 'Sem informação'),
          InfoWidget(
              title: 'Idade', value: widget.data['idade'] ?? 'Não informado'),
          InfoWidget(
              title: 'Estado de saúde',
              value: widget.data['estadoDeSaude'] ?? 'Não informado'),
          InfoWidget(
              title: 'Sexo', value: widget.data['sexo'] ?? 'Não informado'),
          InfoWidget(
              title: 'Localização',
              value: widget.data['endereco'] ?? 'Não informado'),
          InfoWidget(
              title: 'Porte', value: widget.data['porte'] ?? 'Não informado'),
          InfoWidget(
              title: 'Necessidades especiais',
              value: widget.data['necessidades'] ?? 'Nenhuma'),
        ],
      ),
    );
  }
}
