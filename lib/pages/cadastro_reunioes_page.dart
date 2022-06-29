import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/reuniao_model.dart';

class CadastroReunioesPage extends StatefulWidget {
  const CadastroReunioesPage({ Key? key }) : super(key: key);

  @override
  State<CadastroReunioesPage> createState() => _CadastroReunioesPageState();
}

class _CadastroReunioesPageState extends State<CadastroReunioesPage> {
  // Instancia do banco Cloud Firestore
  FirebaseFirestore db = FirebaseFirestore.instance;

  final TextEditingController descricaoController = TextEditingController();

  @override
  void initState() {
    // Atualização Inicial

    // Atualização em Tempo Real
    super.initState();
  }

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
              onPressed: sendData,
              child: const Text('Cadastrar'),
            ),
          ]
        ),
      ),
    );
  }

  void sendData() {
    // Geração do ID
    String id = Uuid().v1();
    db.collection('reunioes').doc(id).set({
      "descricao": descricaoController.text,
    });

    // Feedback visual
    descricaoController.text = "";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Salvo no Firestore"),
      ),
    );
  }
}