import 'package:flutter/material.dart';

class CadastroReunioesPage extends StatefulWidget {
  const CadastroReunioesPage({ Key? key }) : super(key: key);

  @override
  State<CadastroReunioesPage> createState() => _CadastroReunioesPageState();
}

class _CadastroReunioesPageState extends State<CadastroReunioesPage> {
  final TextEditingController descricaoController = TextEditingController();

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
              onPressed: () {},
              child: const Text('Cadastrar'),
            ),
          ]
        ),
      ),
    );
  }
}