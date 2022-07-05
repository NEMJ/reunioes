import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reunioes/models/participante_model.dart';
import 'package:uuid/uuid.dart';

class ParticipanteDetailPage extends StatefulWidget {
  ParticipanteDetailPage({
    Key? key,
    this.participante,
  }) : super(key: key);

  Participante? participante;

  @override
  State<ParticipanteDetailPage> createState() => _ParticipanteDetailPageState();
}

class _ParticipanteDetailPageState extends State<ParticipanteDetailPage> {
  final _nomeController = TextEditingController();
  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ufController = TextEditingController();
  final _contatoController = TextEditingController();
  final _profissaoController = TextEditingController();
  final _localTrabalhoController = TextEditingController();
  final _dataNascimentoController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    initControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Pessoas Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: _ruaController,
                        decoration: const InputDecoration(
                          labelText: 'Rua',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: _bairroController,
                        decoration: const InputDecoration(
                          labelText: 'Bairro',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: _cidadeController,
                        decoration: const InputDecoration(
                          labelText: 'Cidade',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: _ufController,
                        decoration: const InputDecoration(
                          labelText: 'UF',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: _contatoController,
                        decoration: const InputDecoration(
                          labelText: 'Contato',
                          hintText: 'Ex: 016 99999-9999',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: _profissaoController,
                        decoration: const InputDecoration(
                          labelText: 'Profissao',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: _localTrabalhoController,
                        decoration: const InputDecoration(
                          labelText: 'Local de Tabalho',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: _dataNascimentoController,
                        decoration: const InputDecoration(
                          labelText: 'Data de nascimento',
                          hintText: '08/12/1987',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              child: (widget.participante != null) 
                ? const Text("Salvar Alterações")
                : const Text("Confirmar Cadastro"),
              onPressed: () {
                // Se foi passado o objeto para a página, abre-se um dialog a respeito do update
                (widget.participante != null)
                  ? showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Atualizar dados da reunião ${widget.participante!.nome}?"),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Cancelar")
                        ),
                        ElevatedButton(
                          onPressed: () {
                            update(widget.participante!.id);
                            Navigator.of(context).pop();
                          },
                          child: const Text("Atualizar")
                        )
                      ],
                    ),
                  )
                  : sendData();
              },
            ),
          ],
        ),
      ),
    );
  }

  void initControllers() {
    /* Se não for enviado um objeto 'participante' significa que é uma nova inserção
     * por isso os controllers são instanciados com uma string vazia
     * 
     * Caso seja enviado um objeto 'participante' cada controller recebe o conteúdo
     * do campo correpondente
     */

    if(widget.participante == null) {
      _nomeController.text = '';
      _ruaController.text = '';
      _bairroController.text = '';
      _cidadeController.text = '';
      _ufController.text = '';
      _contatoController.text = '';
      _profissaoController.text = '';
      _localTrabalhoController.text = '';
      _dataNascimentoController.text = '';
    } else {
      setState(() {
        _nomeController.text = widget.participante!.nome;
        _ruaController.text = widget.participante!.rua;
        _bairroController.text = widget.participante!.bairro;
        _cidadeController.text = widget.participante!.cidade;
        _ufController.text = widget.participante!.uf;
        _contatoController.text = widget.participante!.contato;
        _profissaoController.text = widget.participante!.profissao;
        _localTrabalhoController.text = widget.participante!.localTrabalho;
        _dataNascimentoController.text = widget.participante!.dataNascimento;
      });
    }
  }

  // Atualização do documento selecionado no registro da tela anterior
  void update(String id) {
    // Atualização de todos os campos
    db.collection('participantes').doc(id).update({
      'nome': _nomeController.text,
      'rua': _ruaController.text,
      'bairro': _bairroController.text,
      'cidade': _cidadeController.text,
      'uf': _ufController.text,
      'contato': _contatoController.text,
      'profissao': _profissaoController.text,
      'localTrabalho': _localTrabalhoController.text,
      'dataNascimento': _dataNascimentoController.text,
    });

    // confirmação visual de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Registro do participante ${_nomeController.text} atualizado com sucesso"),
      ),
    );
  }

  void sendData() {
    // Geração do ID aleatório
    String id = const Uuid().v1();

    db.collection('participantes').doc(id).set({
      'id': id,
      'nome': _nomeController.text,
      'rua': _ruaController.text,
      'bairro': _bairroController.text,
      'cidade': _cidadeController.text,
      'uf': _ufController.text,
      'contato': _contatoController.text,
      'profissao': _profissaoController.text,
      'localTrabalho': _localTrabalhoController.text,
      'dataNascimento': _dataNascimentoController.text,
    });

    // confirmação visual de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Participante ${_nomeController.text} cadastrado com sucesso"),
      ),
    );

    // Limpeza do conteúdo de todos os TextFields para uma nova inserção
    _nomeController.text = '';
    _ruaController.text = '';
    _bairroController.text = '';
    _cidadeController.text = '';
    _ufController.text = '';
    _contatoController.text = '';
    _profissaoController.text = '';
    _localTrabalhoController.text = '';
    _dataNascimentoController.text = '';
  }
}
