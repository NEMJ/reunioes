import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reunioes/pages/participante/participantes_list_page.dart';
import './reuniao/reunioes_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Pessoas"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: ParticipantesListPage(),
                        type: PageTransitionType.leftToRight,
                        // alignment: Alignment.center,
                        // duration: const Duration(milliseconds: 600),
                        // reverseDuration: const Duration(milliseconds: 600)
                      ),
                    );
                  },
                  child: const Text('Participantes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: const ReunioesListPage(),
                        type: PageTransitionType.rightToLeft,
                      ),
                    );
                  },
                  child: const Text('Reuniões'),
                ),
              ]
            ),
          ]
        ),
      ),
    );
  }
}