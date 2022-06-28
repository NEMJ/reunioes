import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../data/reunioes_dao.dart';
import '../models/reuniao_model.dart';

class CadastroReunioesPage extends StatefulWidget {
  const CadastroReunioesPage({ Key? key }) : super(key: key);

  get reunioesDao => null;

  @override
  State<CadastroReunioesPage> createState() => _CadastroReunioesPageState();
}

class _CadastroReunioesPageState extends State<CadastroReunioesPage> {
  final TextEditingController descricaoController = TextEditingController();
  final reunioesDao = ReunioesDao();

  final DatabaseReference _reunioesRef = FirebaseDatabase.instance.ref().child('reunioes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de Reuniões"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [],
              ),
            ),
            Flexible(
              child: TextField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Breve Descrição',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _reunioesRef.set({
                  "descrição" : descricaoController.text,
                });
                descricaoController.clear();
              },
              child: const Text('Cadastrar'),
            ),
          ]
        ),
      ),
    );
  }
}