import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../data/pessoas_data.dart';
import '../models/pessoa_model.dart';
import '../widgets/pessoa_list_item.dart';
import 'cadastro_pessoas_page.dart';

class ListaPessoasPage extends StatefulWidget {
  const ListaPessoasPage({ Key? key }) : super(key: key);

  @override
  State<ListaPessoasPage> createState() => _ListaPessoasPageState();
}

class _ListaPessoasPageState extends State<ListaPessoasPage> {
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
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Lista de Pessoas",
                  style: TextStyle(
                    fontSize: 30,
                  ),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: const CadastroPessoasPage(),
                            type: PageTransitionType.bottomToTop,
                          ),
                        );
                      },
                      child: Text("Cadastrar Nova Pessoa")
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}