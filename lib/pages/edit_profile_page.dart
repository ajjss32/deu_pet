import 'package:flutter/material.dart';
import 'package:deu_pet/model/user.dart';
import 'package:deu_pet/services/user_service.dart';

class EditProfilePage extends StatefulWidget {
  final Usuario usuario;

  EditProfilePage({required this.usuario});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UsuarioService _usuarioService = UsuarioService();

  // Controladores para os campos do formulário
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Preenche os controladores com os dados do usuário
    _nameController.text = widget.usuario.nome;
    _telefoneController.text = widget.usuario.telefone;
    _dataNascimentoController.text = widget.usuario.dataNascimento;
    _descricaoController.text = widget.usuario.descricao;

    // Preenche os campos de endereço
    final partesEndereco = widget.usuario.endereco.split(', ');
    if (partesEndereco.length >= 4) {
      _logradouroController.text = partesEndereco[0];
      _bairroController.text = partesEndereco[1];
      _cidadeController.text = partesEndereco[2];
      _estadoController.text = partesEndereco[3];
    }
  }

  Future<void> _salvarAlteracoes() async {
    try {
      final usuario = widget.usuario;
      usuario.nome = _nameController.text;
      usuario.telefone = _telefoneController.text;
      usuario.dataNascimento = _dataNascimentoController.text;
      usuario.descricao = _descricaoController.text;
      usuario.endereco =
          "${_logradouroController.text}, ${_bairroController.text}, ${_cidadeController.text}, ${_estadoController.text}";

      // Atualiza os dados do usuário no Firestore
      await _usuarioService.atualizarUsuario(usuario);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Perfil atualizado com sucesso!")),
      );

      // Atualiza o estado local para refletir as mudanças
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao atualizar o perfil: $e")),
      );
    }
  }

  Future<void> _buscarCEP() async {
    try {
      final endereco =
          await _usuarioService.buscarEnderecoPorCEP(_cepController.text);
      setState(() {
        _logradouroController.text = endereco['logradouro'] ?? '';
        _bairroController.text = endereco['bairro'] ?? '';
        _cidadeController.text = endereco['localidade'] ?? '';
        _estadoController.text = endereco['uf'] ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _selecionarDataNascimento() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      // Formata a data para o formato desejado (ex: dd/MM/yyyy)
      final formattedDate =
          "${dataSelecionada.day.toString().padLeft(2, '0')}/${dataSelecionada.month.toString().padLeft(2, '0')}/${dataSelecionada.year}";
      setState(() {
        _dataNascimentoController.text = formattedDate;
      });
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text,
      bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFCCCCCE), width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFCCCCCE), width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFCCCCCE), width: 0.5),
          ),
          prefixIcon: Icon(icon),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: enabled,
      ),
    );
  }

  Widget _buildDescricaoField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity, // Largura fixa igual aos outros campos
            height: 100, // Altura fixa para o campo de descrição
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFCCCCCE), width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller,
                maxLines: null, // Permite múltiplas linhas
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove a borda interna
                ),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Perfil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey, // Cor cinza para o título
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_nameController, "Nome", Icons.person),
            _buildTextField(_telefoneController, "Telefone", Icons.phone),
            GestureDetector(
              onTap: _selecionarDataNascimento,
              child: AbsorbPointer(
                child: _buildTextField(_dataNascimentoController,
                    "Data de Nascimento", Icons.calendar_today),
              ),
            ),
            _buildDescricaoField(_descricaoController, "Descrição", Icons.info),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildTextField(
                      _cepController, "CEP", Icons.location_on,
                      keyboardType: TextInputType.number),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: _buscarCEP,
                    child: Text("Buscar"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
            _buildTextField(_logradouroController, "Logradouro", Icons.place,
                enabled: false),
            _buildTextField(_bairroController, "Bairro", Icons.place,
                enabled: false),
            _buildTextField(_cidadeController, "Cidade", Icons.location_city,
                enabled: false),
            _buildTextField(_estadoController, "Estado", Icons.flag,
                enabled: false),
          ],
        ),
      ),
      // Botão de salvar no canto inferior direito
      floatingActionButton: FloatingActionButton(
        onPressed: _salvarAlteracoes,
        backgroundColor: Color(0xFF50BB88), // Cor verde
        child: Icon(Icons.save, color: Colors.white), // Ícone de disquete
      ),
    );
  }
}
