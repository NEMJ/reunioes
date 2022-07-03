import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reunioes/data/participantes_data.dart';
import 'package:reunioes/models/participante_model.dart';
import 'package:reunioes/widgets/participante_list_item.dart';
import 'participante_detail_page.dart';

class ParticipantesListPage extends StatefulWidget {
  const ParticipantesListPage({ Key? key }) : super(key: key);

  @override
  State<ParticipantesListPage> createState() => _ParticipantesListPageState();
}

class _ParticipantesListPageState extends State<ParticipantesListPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cadastro de Participantes"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Lista de Participantes",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for(Participante participante in participantes)
                      Center(child: ParticipanteListItem(participante: participante)),
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
                            child: const ParticipanteDetailPage(),
                            type: PageTransitionType.bottomToTop,
                          ),
                        );
                      },
                      child: const Text("Novo Participante")
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