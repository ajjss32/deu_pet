import 'package:deu_pet/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MatchScreen extends StatefulWidget {
  final Channel chat;

  MatchScreen({required this.chat});

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Inicializa o controlador de animação
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..forward(); // Inicia a animação uma vez, sem repetição
    ; // Faz a animação repetir continuamente

    // Animação de escala para o logo
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(20),
          content: Stack(
            children: [
              Container(
                width: 221,
                height: 86,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Mensagem enviada com sucesso!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF787879),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                top: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String? petImageUrl = widget.chat.extraData['pet_image'] as String?;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(89, 101, 247, 1),
              Color.fromRGBO(59, 67, 164, 1),
            ],
          ),
        ),
        child: Column(
          children: [
            // Botão de fechar no AppBar
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Spacer(),
            // Parte central com as imagens e logo animados
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Imagem do usuário com rotação
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value, // Roda 360º
                          child: Container(
                            width: 165,
                            height: 165,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromRGBO(
                                    59, 67, 164, 1), // Cor da borda
                                width: 5.0,
                              ),
                              image: DecorationImage(
                                image: AssetImage('assets/images/person2.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 1),
                    // Imagem do pet com rotação
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value, // Roda inverso
                          child: Container(
                            width: 165,
                            height: 165,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromRGBO(
                                    59, 67, 164, 1), // Cor da borda
                                width: 5.0,
                              ),
                              image: DecorationImage(
                                image: petImageUrl != null &&
                                        petImageUrl.isNotEmpty
                                    ? NetworkImage(
                                        petImageUrl)
                                    : AssetImage(
                                            'assets/images/default_pet.png')
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Logo com escala (pulso)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Image.asset(
                        'assets/images/deu_pet.png', // Caminho do logo Deu Pet
                        width: 200, // Tamanho do logo
                      ),
                    );
                  },
                ),
              ],
            ),
            Spacer(),
            // Campo de texto e botão
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Mande mensagem para o adotante!",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_messageController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'O campo de mensagem não pode estar vazio!'),
                          ),
                        );
                      } else {
                        ChatService().sendMessageOnMatch(
                            widget.chat, _messageController.text);
                        _messageController.clear();
                        _showSuccessDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Enviar",
                      style: TextStyle(color: Color(0xFF5468FF)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
