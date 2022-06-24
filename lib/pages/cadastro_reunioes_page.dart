import 'package:flutter/material.dart';

class CadastroReunioesPage extends StatefulWidget {
  const CadastroReunioesPage({ Key? key }) : super(key: key);

  @override
  State<CadastroReunioesPage> createState() => _CadastroReunioesPageState();
}

class _CadastroReunioesPageState extends State<CadastroReunioesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de Reuniões"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text("Cadastro de Reuniões"),
              ],
            ),
          ]
        ),
      ),
    );
  }
}