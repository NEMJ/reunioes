import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DropdownListPage extends StatefulWidget {
  DropdownListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DropdownListPage> createState() => _DropdownListPageState();
}

FirebaseFirestore db = FirebaseFirestore.instance;

final _formKey = GlobalKey<FormState>();

String? diaSemana;
final List<String> diasSemana = [];

String participante = '';
List<String> entidadesPart = [];

List<Map<String, dynamic>> et = [];

class _DropdownListPageState extends State<DropdownListPage> {
  @override
  initState(){
    db.collection('participantes').snapshots().listen((query) {
      et = [];
      if(query.docs.isEmpty) {
        setState((){});
      } else {
        query.docs.forEach((doc) {
          if(doc.get('tipoParticipante') == 'Entidade') {
            var nmp = {"id": doc.get('id'), "nome": doc.get('nome')};
            et.add(nmp);
          }
        });
        setState(() => et);
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
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DropdownButtonFormField(
                  items: et
                    .map((op) {
                      return DropdownMenuItem(
                        value: op['id'],
                        child: Text(op['nome']),
                      );
                    })
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
                        content: Text("Participante $participante"),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}