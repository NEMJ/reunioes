import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reunioes/pages/widgets/checkbox_widget.dart';

class AlertCheckboxPage extends StatefulWidget {
  const AlertCheckboxPage({ Key? key }) : super(key: key);

  @override
  State<AlertCheckboxPage> createState() => _AlertCheckboxPageState();
}

// List<CheckboxModel> campeoes = [
//   CheckboxModel(texto: 'Xayah', id: ''),
//   CheckboxModel(texto: 'Rakan', id: ''),
//   CheckboxModel(texto: 'Jinx', id: ''),
//   CheckboxModel(texto: 'Blitzcranck', id: ''),
//   CheckboxModel(texto: 'Yasuo', id: ''),
//   CheckboxModel(texto: 'Morgana', id: ''),
//   CheckboxModel(texto: 'Master Yi', id: ''),
//   CheckboxModel(texto: 'Wookong', id: ''),
//   CheckboxModel(texto: 'Ashe', id: ''),
//   CheckboxModel(texto: 'Rise', id: ''),
//   CheckboxModel(texto: 'Riven', id: ''),
//   CheckboxModel(texto: 'Alistar', id: ''),
//   CheckboxModel(texto: 'Yumi', id: ''),
//   CheckboxModel(texto: 'Lux', id: ''),
//   CheckboxModel(texto: 'Seraphine', id: ''),
//   CheckboxModel(texto: 'Soraka', id: ''),
// ];

FirebaseFirestore db = FirebaseFirestore.instance;

List<CheckboxModel> reunioes = [];

class _AlertCheckboxPageState extends State<AlertCheckboxPage> {

  @override
  void initState() {

    db.collection('reunioes').snapshots().listen((query) {
      reunioes = [];
      if(query.docs.isEmpty) {
        setState((){});
      } else {
        query.docs.forEach((doc) {
            reunioes.add(
              CheckboxModel(
                texto: doc.get('descricao'),
                id: doc.get('id'),
              ),
            );
        });
        setState(() => reunioes);
      }
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Checkbox Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: const Text('Selecione uma reunião'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.purple[100],
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Selecione uma reunião'),
                  scrollable: true,
                  content: Column(
                    children: [
                      for(CheckboxModel reuniao in reunioes)
                        CheckboxWidget(item: reuniao)
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text('Confirmar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        listarSelecionados();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<Widget> dialog() {
  //   return 
  // }

  void listarSelecionados() {
    List<CheckboxModel> itensMarcados = List.from(reunioes.where((reuniao) => reuniao.checked));

    itensMarcados.forEach((reuniao) {
      print('Campeão Marcado: ${reuniao.id}');
    });
  }

}