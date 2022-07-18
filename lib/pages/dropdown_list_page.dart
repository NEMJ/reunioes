import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reunioes/models/participante_model.dart';
import 'package:reunioes/models/reuniao_model.dart';
import 'package:uuid/uuid.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DropdownListPage extends StatefulWidget {
  DropdownListPage({
    Key? key,
    this.reuniao,
    this.participante,
  }) : super(key: key);

  // Caso for um novo cadastro este objeto é nulo para que o formulário esteja com os campos vazios
  Reuniao? reuniao;
  Participante? participante;

  @override
  State<DropdownListPage> createState() => _DropdownListPageState();
}

// Instância do banco Cloud Firestore
FirebaseFirestore db = FirebaseFirestore.instance;

// GlobalKey para a validação do formulário de cadastro de reuniões
final _formKey = GlobalKey<FormState>();

String? diaSemana;
final List<String> diasSemana = [];

String participante = '';
List<String> entidadesPart = [];

class _DropdownListPageState extends State<DropdownListPage> {
  @override
  initState(){
    db.collection('participantes').snapshots().listen((query) {
      entidadesPart = [];
      if(query.docs.isEmpty) {
        setState((){});
      } else {
        query.docs.forEach((doc) {
          if(doc.get('tipoParticipante') == 'Entidade') {
            entidadesPart.add(doc.get('nome'));
          }
        });
        setState(() => entidadesPart);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testando Integração Dropdown"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: DropdownButtonFormField(
                        items: entidadesPart
                          .map((op) => DropdownMenuItem(
                              value: op,
                              child: Text(op),
                            ),
                          )
                          .toList(),
                        onChanged: (escolha) => setState(() => participante = escolha.toString()),
                        value: (participante.isNotEmpty) ? participante : null,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de participante',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if(value == null) {
                            return 'Selecione tipo de participante';
                          } else {
                            return null;
                          }
                        }
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('Validar'),
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Registro do participante $participante atualizado com sucesso"),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}