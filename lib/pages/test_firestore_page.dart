import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TestFirestorePage extends StatefulWidget {
  const TestFirestorePage({ Key? key }) : super(key: key);

  @override
  State<TestFirestorePage> createState() => _TestFirestorePageState();
}

class _TestFirestorePageState extends State<TestFirestorePage> {
  // Instância do banco Cloud Firestore
  FirebaseFirestore db = FirebaseFirestore.instance;

  TextEditingController _textController = TextEditingController();
  List<String> listReunioes = [];

  @override
  void initState() {
    // Atualização Inicial
    refresh();
    
    // Atualização em Tempo Real

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Cloud Firestore"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: refresh,
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Vamos gravar um nome na nuvem?",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: "Insira um nome",
              ),
            ),
            ElevatedButton(
              onPressed: sendData,
              child: Text("Enviar"),
            ),
            const SizedBox(
              height: 16,
            ),
            (listReunioes.length == 0)
              ? const Text(
                "Nenhuma reunião registrada",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              )
              : Column(
                children: [
                  for(String reuniao in listReunioes) Text(reuniao)
                ],
              )
          ],
        ),
      ),
    );
  }

  void refresh() {
    // Atualização Manual
  }

  void sendData() {
    // Geração do ID
    String id = Uuid().v1();

    // Feedback visual
    _textController.text = "";
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Salvo no Firestore!"),
      ),
    );
  }
}

// 11 min  --   https://www.youtube.com/watch?v=KWWTTY6gSw4&t=1s