import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

Future<String?> uploadImageToCloudinary(XFile imageFile) async {
  String cloudName = "dkyz1tnki";
  String uploadPreset = "deu_pet";

  var url =
      Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

  var request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = uploadPreset;
  

  final bytes = await imageFile.readAsBytes();
  request.files.add(
    http.MultipartFile.fromBytes('file', bytes, filename: imageFile.name)
  );
  
  var response = await request.send();
  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    var jsonData = json.decode(responseData);
    return jsonData['secure_url'];
  } else {
    print("Erro ao enviar imagem: ${response.reasonPhrase}");
    return null;
  }
}
