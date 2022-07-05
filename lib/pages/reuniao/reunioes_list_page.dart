import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reunioes/pages/reuniao/reuniao_detail_page.dart';
import 'package:reunioes/models/reuniao_model.dart';

class ReunioesListPage extends StatefulWidget {
  const ReunioesListPage({ Key? key }) : super(key: key);

  @override
  State<ReunioesListPage> createState() => ReunioesListPageState();
}

class ReunioesListPageState extends State<ReunioesListPage> {

  // Instancia do banco Cloud Firestore
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Reuniao> reunioesList = [];

  @override
  void initState() {
    // Inicialização dos Dados
    initFirestore();

    // Atualização em Tempo Real
    db.collection('reunioes').snapshots().listen((query) {
      reunioesList = [];
      if(query.docs.isEmpty) {
        setState(() {});
      } else {
        query.docs.forEach((doc) {
          var reuniao = Reuniao(
            id: doc.get('id'),
            descricao: doc.get('descricao'),
            diaSemana: doc.get('diaSemana'),
            horarioInicio: doc.get("horarioInicio"),
            horarioTermino: doc.get("horarioTermino"),
          );
          setState(() {
            reunioesList.add(reuniao);
          });
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    setState(() => reunioesList.clear());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cadastro de Reuniões"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: reunioesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: Colors.grey[200],
                        leading: const CircleAvatar(
                          child: Icon(Icons.business_rounded),
                        ),
                        title: Text(reunioesList[index].descricao),
                        onTap: () {
                          detailReuniao(reunioesList[index]);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel),
                          color: Colors.red[400],
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Deseja realmente excluir a reunião ${reunioesList[index].descricao}?"),
                              actions: [
                                ElevatedButton(
                                  child: const Text("Cancelar"),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                ElevatedButton(
                                  child: const Text("Deletar"),
                                  onPressed: () {
                                    delete(reunioesList[index].id);
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ),
              ElevatedButton(
                child: const Text("Cadastrar Nova Reunião"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReuniaoDetailPage(),
                    ),
                  );
                },
              ),
            ]
          ),
        ),
      ),
    );
  }

  void initFirestore() async {
    // Retorna um "mapa snapshot" de toda a coleção especificada
    QuerySnapshot query = await db.collection("reunioes").get();

    reunioesList = [];
    // Para cada documento da coleção é gerado um objeto reunião e adicionado à lista de objtos do mesmo tipo
    query.docs.forEach((doc) {
      Reuniao reuniao = Reuniao(
        id: doc.get("id"),
        descricao: doc.get("descricao"),
        diaSemana: doc.get("diaSemana"),
        horarioInicio: doc.get("horarioInicio"),
        horarioTermino: doc.get("horarioTermino"),
      );
      setState(() {
        reunioesList.add(reuniao);
      });
    });
  }

  void detailReuniao(Reuniao reuniao) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReuniaoDetailPage(reuniao: reuniao),
      ),
    );
  }

  void delete(String id) async {
    db.collection('reunioes').doc(id).delete();
  }
}