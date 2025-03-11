import 'dart:convert';
import 'package:http/http.dart' as http;

class CEPService {
  // Função para buscar o endereço pelo CEP
  static Future<Map<String, dynamic>> buscarCEP(String cep) async {
    // Formata o CEP para remover caracteres não numéricos
    cep = cep.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se o CEP tem 8 dígitos
    if (cep.length != 8) {
      throw Exception("CEP inválido. O CEP deve conter 8 dígitos.");
    }

    // Faz a requisição à API do ViaCEP
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    // Verifica se a requisição foi bem-sucedida
    if (response.statusCode == 200) {
      // Decodifica o JSON retornado
      final Map<String, dynamic> data = json.decode(response.body);

      // Verifica se o CEP foi encontrado
      if (data.containsKey('erro')) {
        throw Exception("CEP não encontrado.");
      }

      // Retorna os dados do endereço
      return data;
    } else {
      throw Exception("Erro ao buscar o CEP. Tente novamente.");
    }
  }
}
