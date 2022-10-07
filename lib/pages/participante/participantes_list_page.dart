import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reunioes/pages/participante/participante_detail_page.dart';
import 'package:reunioes/models/participante_model.dart';

class ParticipantesListPage extends StatefulWidget {
  const ParticipantesListPage({ Key? key }) : super(key: key);

  @override
  State<ParticipantesListPage> createState() => _ParticipantesListPageState();
}

class _ParticipantesListPageState extends State<ParticipantesListPage> {

  TextEditingController _searchController = TextEditingController();
  
  // Instancia do Firestore
  FirebaseFirestore db = FirebaseFirestore.instance;
  // Lista com todos os participantes cadastrados
  List<Participante> participantesList = [];
  // Lista de participantes correspondentes ao termo de busca
  List<Participante> participantesListOnSearch = [];

  // Instancia do Firebase Storage
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    // Download das imagens relacionadas aos participantes cadastrados
    loadImages();

    // Inicialização dos Dados
    initFirestore();

    // Atualização em tempo real
    db.collection('participantes').orderBy("nome").snapshots().listen((query) {
      participantesList = [];
      if(query.docs.isEmpty) {
        setState(() {});
      } else {
        query.docs.forEach((doc) {
          var participante = Participante(
            id: doc.get('id'),
            refImage: doc.get('refImage'),
            tipoParticipante: doc.get('tipoParticipante'),
            reunioes: doc.get('reunioes'),
            nome: doc.get('nome'),
            apelido: doc.get('apelido'),
            rua: doc.get('rua'),
            bairro: doc.get('bairro'),
            cidade: doc.get('cidade'),
            uf: doc.get('uf'),
            contato: doc.get('contato'),
            telFixo: doc.get('telFixo'),
            profissao: doc.get('profissao'),
            formProf: doc.get('formProf'),
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
          centerTitle: true,
          title: const Text("Lista de Participantes"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 7),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      // Insere elementos na lista de filtragem conforme satisfeita a condição de pesquisa
                      participantesListOnSearch = participantesList
                        .where((element) => element.nome.toLowerCase().contains(value.toLowerCase())).toList();
                    });
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    hintText: 'Pesquisar',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        participantesListOnSearch.clear();
                        setState(() {
                          _searchController.text = '';
                        });
                      },
                    ),
                  ),
                ),
              ),
              _searchController.text.isNotEmpty && participantesListOnSearch.isEmpty 
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.search_off, size: 100, color: Colors.purple),
                    Text(
                      'Sem resultados',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
              : Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchController.text.isNotEmpty
                    ? participantesListOnSearch.length
                    : participantesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: Colors.grey[200],
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/fir-storage-c6431.appspot.com/o/images%2Fimg-2022-10-03T20%3A13%3A07.965451.jpg?alt=media&token=763e3a34-1aa3-438d-beb4-43d92fa17ea8',
                            ),
                        ),
                        title: Text(
                          _searchController.text.isNotEmpty
                          ? participantesListOnSearch[index].nome
                          : participantesList[index].nome
                        ),
                        onTap: () {
                          detailParticipante(
                            _searchController.text.isNotEmpty
                            ? participantesListOnSearch[index]
                            : participantesList[index]
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel),
                          color: Colors.red[400],
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Deseja relamente excluir o participante ${
                                _searchController.text.isNotEmpty
                                ? participantesListOnSearch[index].nome
                                : participantesList[index].nome
                              }?"),
                              actions: [
                                ElevatedButton(
                                  child: const Text('Cancelar'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                ElevatedButton(
                                  child: const Text('Deletar'),
                                  onPressed: () {
                                    delete(
                                      _searchController.text.isNotEmpty
                                      ? participantesListOnSearch[index].id
                                      : participantesList[index].id
                                    );
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
    QuerySnapshot query = await db.collection("participantes").orderBy("nome").get();
    
    participantesList = [];
    // Para cada documento da coleção é gerado um objeto reunião e adicionado à lista de objtos do mesmo tipo
    query.docs.forEach((doc) {
      Participante participante = Participante(
        id: doc.get("id"),
        refImage: doc.get("refImage"),
        tipoParticipante: doc.get("tipoParticipante"),
        reunioes: doc.get('reunioes'),
        nome: doc.get('nome'),
        apelido: doc.get('apelido'),
        rua: doc.get('rua'),
        bairro: doc.get('bairro'),
        cidade: doc.get('cidade'),
        uf: doc.get('uf'),
        contato: doc.get('contato'),
        telFixo: doc.get('telFixo'),
        profissao: doc.get('profissao'),
        formProf: doc.get('formProf'),
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


  loadImages() async {
    
  }
}