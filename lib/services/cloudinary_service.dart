import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  final String cloudName = "dkyz1tnki";
  final String uploadPreset = "deu_pet";
  final String apiKey = "768371769864496";
  final String apiSecret = "4_gJKs6_pX-g-w0YIsbMLaMncxE";

  Future<String?> uploadImageToCloudinary(XFile imageFile) async {
    var url =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    var request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset;

    final bytes = await imageFile.readAsBytes();
    request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: imageFile.name));

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

  Future<bool> deleteImageFromCloudinary(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final parts = uri.pathSegments;
      final filename = parts.last;
      final publicId =
          filename.split('.').first; // remove extensão tipo .jpg, .png

      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final signatureString =
          "public_id=$publicId&timestamp=$timestamp$apiSecret";
      final signature = sha1.convert(utf8.encode(signatureString)).toString();

      final url =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/destroy");

      final response = await http.post(
        url,
        body: {
          'public_id': publicId,
          'api_key': apiKey,
          'timestamp': timestamp.toString(),
          'signature': signature,
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return responseData['result'] == 'ok';
      } else {
        print("Erro ao excluir imagem: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("Exception ao excluir imagem: $e");
      return false;
    }
  }
}
