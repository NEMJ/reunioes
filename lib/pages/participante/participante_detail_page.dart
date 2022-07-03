import 'package:flutter/material.dart';
import 'package:reunioes/widgets/form_item.dart';

class ParticipanteDetailPage extends StatefulWidget {
  const ParticipanteDetailPage({ Key? key }) : super(key: key);

  @override
  State<ParticipanteDetailPage> createState() => _ParticipanteDetailPageState();
}

class _ParticipanteDetailPageState extends State<ParticipanteDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Pessoas Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
              child: ListView(
                children: const [
                  FormItem(labelText: 'Nome'),
                  FormItem(labelText: 'Rua'),
                  FormItem(labelText: 'Bairro'),
                  FormItem(labelText: 'Cidade'),
                  FormItem(labelText: 'UF'),
                  FormItem(labelText: 'Contato'),
                  FormItem(labelText: 'Profissão'),
                  FormItem(labelText: 'Local de Trabalho'),
                  FormItem(labelText: 'Data de Nascimento'),
                  FormItem(labelText: 'Nome'),
                  FormItem(labelText: 'Nome'),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Confirmar cadastro"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}