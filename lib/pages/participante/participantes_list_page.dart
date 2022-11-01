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

  final TextEditingController _searchController = TextEditingController();
  
  // Instancia do Firestore
  FirebaseFirestore db = FirebaseFirestore.instance;
  // Lista com todos os participantes cadastrados
  List<Participante> participantesList = [];
  // Lista de participantes correspondentes ao termo de busca
  List<Participante> participantesListOnSearch = [];

  // Instancia do Firebase Storage
  final FirebaseStorage storage = FirebaseStorage.instance;

  int _filterValue = 1;
  String tipoFiltro = 'nome';

  @override
  void initState() {
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
                margin: const EdgeInsets.only(bottom: 7),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  onChanged: (value) {
                    switch (tipoFiltro) {
                      case 'nome':
                        setState(() {
                          // Insere elementos na lista de filtragem conforme satisfeita a condição de pesquisa
                          participantesListOnSearch = participantesList
                            .where((element) => element.nome.toLowerCase().contains(value.toLowerCase())).toList();
                        });
                        break;
                      case 'tipoParticipante':
                        setState(() {
                          // Lista auxiliar com apenas o tipo de participante selecionado
                          List<Participante> searchParticipante = participantesList
                            .where((element) => element.tipoParticipante.toLowerCase().contains('participante')).toList();

                          participantesListOnSearch = searchParticipante
                            .where((element) => element.nome.toLowerCase().contains(value.toLowerCase())).toList();
                        });
                        break;
                      case 'tipoEntidade':
                        setState(() {
                          List<Participante> searchEntidade = participantesList
                            .where((element) => element.tipoParticipante.toLowerCase().contains('entidade')).toList();

                          participantesListOnSearch = searchEntidade
                            .where((element) => element.nome.toLowerCase().contains(value.toLowerCase())).toList();
                        });
                        break;
                      case 'tipoDirigente':
                        setState(() {
                          List<Participante> searchDirigente = participantesList
                            .where((element) => element.tipoParticipante.toLowerCase().contains('dirigente')).toList();

                          participantesListOnSearch = searchDirigente
                            .where((element) => element.nome.toLowerCase().contains(value.toLowerCase())).toList();
                        });
                        break;
                      case 'profissao':
                        setState(() {
                          participantesListOnSearch = participantesList
                            .where((element) => element.profissao.toLowerCase().contains(value.toLowerCase())).toList();
                        });
                        break;
                      case 'formacaoProfissional':
                        setState(() {
                          participantesListOnSearch = participantesList
                            .where((element) => element.formProf.toLowerCase().contains(value.toLowerCase())).toList();
                        });
                        break;
                      default:
                    }
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.all(15),
                    hintText: 'Pesquisar',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.filter_list_outlined),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => alertDialogOptions(),
                      ),
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
                        leading: _searchController.text.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                participantesListOnSearch[index].refImage,
                              ),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                participantesList[index].refImage
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
                              title: Text("Deseja realmente excluir o participante ${
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

  Widget alertDialogOptions() {
    return AlertDialog(
      title: const Text("Filtrar por", style: TextStyle(fontWeight: FontWeight.bold)),
      content: StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  value: 1,
                  groupValue: _filterValue,
                  title: const Text("Nome"),
                  onChanged: (int? value) {
                    setState(() {
                      _filterValue = value!;
                      tipoFiltro = 'nome';
                      participantesListOnSearch.clear();
                      _searchController.text = '';
                    });
                  },
                ),
                RadioListTile(
                  value: 2,
                  groupValue: _filterValue,
                  title: const Text("Tipo Participante"),
                  onChanged: (int? value) {
                    setState(() {
                      _filterValue = value!;
                      tipoFiltro = 'tipoParticipante';
                      participantesListOnSearch.clear();
                      _searchController.text = '';
                    });
                  },
                ),
                RadioListTile(
                  value: 3,
                  groupValue: _filterValue,
                  title: const Text("Tipo Entidade"),
                  onChanged: (int? value) {
                    setState(() {
                      _filterValue = value!;
                      tipoFiltro = 'tipoEntidade';
                      participantesListOnSearch.clear();
                      _searchController.text = '';
                    });
                  },
                ),
                RadioListTile(
                  value: 4,
                  groupValue: _filterValue,
                  title: const Text("Tipo Dirigente"),
                  onChanged: (int? value) {
                    setState(() {
                      _filterValue = value!;
                      tipoFiltro = 'tipoDirigente';
                      participantesListOnSearch.clear();
                      _searchController.text = '';
                    });
                  },
                ),
                RadioListTile(
                  value: 5,
                  groupValue: _filterValue,
                  title: const Text("Profissão"),
                  onChanged: (int? value) {
                    setState(() {
                      _filterValue = value!;
                      tipoFiltro = 'profissao';
                      participantesListOnSearch.clear();
                      _searchController.text = '';
                    });
                  },
                ),
                RadioListTile(
                  value: 6,
                  groupValue: _filterValue,
                  title: const Text("Formação Profissional"),
                  onChanged: (int? value) {
                    setState(() {
                      _filterValue = value!;
                      tipoFiltro = 'formacaoProfissional';
                      participantesListOnSearch.clear();
                      _searchController.text = '';
                    });
                  },
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}