import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatService {
  Future<Channel> createChannelOnMatch(
    String user1Id,
    String user2Id,
    String adotante,
    String petName,
    String petImage,
    StreamChatClient client,
  ) async {
    final channel = client.channel(
      'messaging', 
      id: '${user1Id}_${user2Id}',
      extraData: {
        'members': [user1Id, user2Id],
        'pet_image': petImage,
        'name': 'Conexão: ${petName} e ${adotante}'
      },
    );

    await channel.create();
    await channel.watch();

    return channel;
  }

  Future<void> sendMessageOnMatch(Channel channel, String text) async {
    try {
      final message = Message(text: text);
      await channel.sendMessage(message);
    } catch (e) {
      print('Erro ao enviar mensagem: $e');
    }
  }

  Future<void> disconnectStreamChat(StreamChatClient client) async {
    try {
      await client.disconnectUser();
      print('Conexão com o Stream Chat encerrada com sucesso.');
    } catch (e) {
      print('Erro ao encerrar a conexão: $e');
    }
  }

  Future<String> gerarTokenJWT(String secretKey, Map<String, dynamic> payload,
      {Duration? validade}) async {
    validade ??= Duration(days: 30);

    final jwt = JWT(payload);

    final token = await jwt.sign(
      SecretKey(secretKey),
      expiresIn: validade,
    );

    return token;
  }
}
