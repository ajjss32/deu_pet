import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  final String title;
  final String value;
  final double fontSize; // Adiciona o parâmetro fontSize

  const InfoWidget({
    super.key,
    required this.title,
    required this.value,
    this.fontSize = 14, // Define o valor padrão para fontSize
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: fontSize, // Usa o fontSize passado
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey,
              fontSize: fontSize -
                  2, // Ajusta o tamanho do valor para ser um pouco menor que o título
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            endIndent: 15,
          ),
        ],
      ),
    );
  }
}
