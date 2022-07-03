import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reunioes/models/reuniao_model.dart';
import 'package:uuid/uuid.dart';

class ReuniaoDetailPage extends StatefulWidget {
  ReuniaoDetailPage({
    Key? key,
    this.reuniao
  }) : super(key: key);

  Reuniao? reuniao;

  @override
  State<ReuniaoDetailPage> createState() => _ReuniaoDetailPageState();
}

class _ReuniaoDetailPageState extends State<ReuniaoDetailPage> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _diaSemanaController = TextEditingController();
  final TextEditingController _horarioInicioController = TextEditingController();
  final TextEditingController _horarioTerminoController = TextEditingController();

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
        title: const Text("Reunião Detail Page"),
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
                        controller: _descricaoController,
                        decoration: const InputDecoration(
                          labelText: 'Descricao',
                          hintText: 'Ex: Reunião Geral',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: _diaSemanaController,
                        decoration: const InputDecoration(
                          labelText: 'Dia da Semana',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: _horarioInicioController,
                        decoration: const InputDecoration(
                          labelText: 'Hora Início',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextField(
                        controller: _horarioTerminoController,
                        decoration: const InputDecoration(
                          labelText: 'Hora Término',
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
              onPressed: () {
                (widget.reuniao != null)

                  // Se foi passado o objeto para a página, abre-se um dialog a respeito do update
                  
                  ? showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Atualizar dados da reunião ${widget.reuniao!.descricao}?"),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancelar")
                        ),
                        ElevatedButton(
                          onPressed: () {
                            update(widget.reuniao!.id);
                            Navigator.of(context).pop();
                          },
                          child: const Text("Atualizar")
                        )
                      ],
                    ),
                  )
                  : sendData();
              },
              child: (widget.reuniao != null) ? Text("Salvar Alterações") : Text("Confirmar Cadastro"),
            ),
          ],
        ),
      ),
    );
  }

  void initControllers() {
    /* Se não for enviado um objeto 'Reuniao' significa que é uma nova inserção
     * por isso os controllers são instanciados com uma string vazia
     * 
     * Caso seja enviado um objeto 'Reuniao' cada controller recebe o conteúdo
     * do campo correpondente
     */
    
    if(widget.reuniao == null) {
      _descricaoController.text = '';
      _diaSemanaController.text = '';
      _horarioInicioController.text = '';
      _horarioTerminoController.text = '';
    } else {
      setState(() {
        _descricaoController.text = widget.reuniao!.descricao;
        _diaSemanaController.text = widget.reuniao!.diaSemana;
        _horarioInicioController.text = widget.reuniao!.horarioInicio;
        _horarioTerminoController.text = widget.reuniao!.horarioTermino;
      });
    }
  }

  // Atualização do documento selecionado no registro da tela anterior
  void update(String id) {
    // Atualização de todos os campos
    db.collection('reunioes').doc(id).update({
      'descricao': _descricaoController.text,
      'diaSemana': _diaSemanaController.text,
      'horarioInicio': _horarioInicioController.text,
      'horarioTermino': _horarioTerminoController.text
    });
  }

  // Envio de dados para o banco e tratamento interno dos TextFields
  void sendData() {
    // Geração do ID aleatório
    String id = const Uuid().v1();

    // Envio de um novo registro para o banco na coleção 'reunioes'
    db.collection('reunioes').doc(id).set({
      "id": id,
      "descricao": _descricaoController.text,
      "diaSemana": _diaSemanaController.text,
      "horarioInicio": _horarioInicioController.text,
      "horarioTermino": _horarioTerminoController.text
    });

    // Limpeza do conteúdo de todos os TextFields para uma nova inserção
    _descricaoController.text = '';
    _diaSemanaController.text = '';
    _horarioInicioController.text = '';
    _horarioTerminoController.text = '';

    // confirmação visual de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reunião salva com sucesso"),
      ),
    );
  }
}