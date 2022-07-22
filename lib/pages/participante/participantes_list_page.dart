import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reunioes/pages/participante/participante_detail_page.dart';
import 'package:reunioes/models/participante_model.dart';

class ParticipantesListPage extends StatefulWidget {
  const ParticipantesListPage({ Key? key }) : super(key: key);

  @override
  State<ParticipantesListPage> createState() => _ParticipantesListPageState();
}

class _ParticipantesListPageState extends State<ParticipantesListPage> {
  
  // Instancia do Firestore
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Participante> participantesList = [];

  @override
  void initState() {
    // Inicialização dos Dados
    initFirestore();

    // Atualização em tempo real
    db.collection('participantes').snapshots().listen((query) {
      participantesList = [];
      if(query.docs.isEmpty) {
        setState(() {});
      } else {
        query.docs.forEach((doc) {
          var participante = Participante(
            id: doc.get('id'),
            tipoParticipante: doc.get('tipoParticipante'),
            reunioes: doc.get('reunioes'),
            nome: doc.get('nome'),
            rua: doc.get('rua'),
            bairro: doc.get('bairro'),
            cidade: doc.get('cidade'),
            uf: doc.get('uf'),
            contato: doc.get('contato'),
            telFixo: doc.get('telFixo'),
            profissao: doc.get('profissao'),
            localTrabalho: doc.get('localTrabalho'),
            dataNascimento: doc.get('dataNascimento'),
          );
          setState(() {
            participantesList.add(participante);
          });
        });
      }
    });
    
    super.initState();
  }

  @override
  void dispose() {
    participantesList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lista de Participantes"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: participantesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: Colors.grey[200],
                        leading: const CircleAvatar(
                          child: Icon(Icons.person_rounded),
                        ),
                        title: Text(participantesList[index].nome),
                        onTap: () {
                          detailParticipante(participantesList[index]);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel),
                          color: Colors.red[400],
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Deseja relamente excluir o participante ${participantesList[index].nome}?"),
                              actions: [
                                ElevatedButton(
                                  child: const Text('Cancelar'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                ElevatedButton(
                                  child: const Text('Deletar'),
                                  onPressed: () {
                                    delete(participantesList[index].id);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                child: const Text('Cadastrar Novo Participante'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ParticipanteDetailPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initFirestore() async {
    // Retorna um "mapa snapshot" de toda a coleção especificada
    QuerySnapshot query = await db.collection("participantes").get();
    
    participantesList = [];
    // Para cada documento da coleção é gerado um objeto reunião e adicionado à lista de objtos do mesmo tipo
    query.docs.forEach((doc) {
      Participante participante = Participante(
        id: doc.get("id"),
        tipoParticipante: doc.get("tipoParticipante"),
        reunioes: doc.get('reunioes'),
        nome: doc.get('nome'),
        rua: doc.get('rua'),
        bairro: doc.get('bairro'),
        cidade: doc.get('cidade'),
        uf: doc.get('uf'),
        contato: doc.get('contato'),
        telFixo: doc.get('telFixo'),
        profissao: doc.get('profissao'),
        localTrabalho: doc.get('localTrabalho'),
        dataNascimento: doc.get('dataNascimento'),
      );
      setState(() {
        participantesList.add(participante);
      });
    });
  }

  void detailParticipante(Participante participante) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ParticipanteDetailPage(participante: participante),
      ),
    );
  }

  void delete(String id) async {
    db.collection('participantes').doc(id).delete();
  }
}