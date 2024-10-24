import 'package:deu_pet/components/custom_app_bar.dart';
import 'package:deu_pet/components/info_widget.dart';
import 'package:flutter/material.dart';

class PetIndividualPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const PetIndividualPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // print('floating button')
        },
        child: Icon(Icons.delete),
      ),
    );
  }

  _buildBody() {
    return Column(
      children: [
        SizedBox(height: 24),
        Expanded(
          flex: 12,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 1,
              //   childAspectRatio: 1,
              //   mainAxisSpacing: 8,
              //   crossAxisSpacing: 8,
              // ),
              itemCount: data['image'].length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 200,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
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
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data['name'],
                style: TextStyle(fontSize: 36),
              ),
              SizedBox(width: 8),
              Icon(Icons.offline_bolt)
            ],
          ),
        ),
        Expanded(
          flex: 30,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: GridView(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 0,
              ),
              children: [
                InfoWidget(
                  title: 'Espécie/Raça',
                  value: data['species'],
                ),
                InfoWidget(
                  title: 'História',
                  value: data['history'],
                ),
                InfoWidget(
                  title: 'idade',
                  value: data['age'],
                ),
                InfoWidget(
                  title: 'Estado de saúde',
                  value: data['healthState'],
                ),
                InfoWidget(
                  title: 'Sexo',
                  value: data['sex'],
                ),
                InfoWidget(
                  title: 'Localização',
                  value: data['localization'],
                ),
                InfoWidget(
                  title: 'Porte',
                  value: data['size'],
                ),
                InfoWidget(
                  title: 'Necessidades especiais',
                  value: data['needSpecialCare'],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
