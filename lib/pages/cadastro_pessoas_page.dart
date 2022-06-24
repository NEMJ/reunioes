import 'package:flutter/material.dart';
import '../data/pessoas_data.dart';
import '../models/pessoa_model.dart';
import '../widgets/pessoa_list_item.dart';

class CadastroPessoasPage extends StatefulWidget {
  const CadastroPessoasPage({ Key? key }) : super(key: key);

  @override
  State<CadastroPessoasPage> createState() => _CadastroPessoasPageState();
}

class _CadastroPessoasPageState extends State<CadastroPessoasPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cadastro de Pessoas"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Lista de Pessoas",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for(Pessoa pessoa in pessoas)
                      Center(child: PessoaListItem(pessoa: pessoa)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {}, child: Text("Cadastrar Pessoa")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}