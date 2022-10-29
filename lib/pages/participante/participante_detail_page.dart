import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:reunioes/models/participante_model.dart';
import 'package:reunioes/widgets/text_form_field_widget.dart';
import 'package:reunioes/widgets/user_profile_photo_widget.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reunioes/widgets/checkbox_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

import 'package:reunioes/widgets/dropdown_form_field_widget.dart';

class ParticipanteDetailPage extends StatefulWidget {
  ParticipanteDetailPage({
    Key? key,
    this.participante,
  }) : super(key: key);

  // Caso for um novo cadastro este objeto é nulo para que o formulário esteja com os campos vazios
  Participante? participante;

  @override
  State<ParticipanteDetailPage> createState() => _ParticipanteDetailPageState();
}


// É instanciado um 'controller' para cada campo de texto
final _nomeController = TextEditingController();
final _apelidoController = TextEditingController();
final _ruaController = TextEditingController();
final _bairroController = TextEditingController();
final _cidadeController = TextEditingController();
final _contatoController = TextEditingController();
final _telFixoController = TextEditingController();
final _profissaoController = TextEditingController();
final _formProfController = TextEditingController();
final _localTrabalhoController = TextEditingController();
final _dataNascimentoController = TextEditingController();

final _formKey = GlobalKey<FormState>();

// Instancia do Firebase Storage
final FirebaseStorage storage = FirebaseStorage.instance;

// Instância do banco Cloud Firestore
FirebaseFirestore db = FirebaseFirestore.instance;


// Bloco responsável pela parte de opções para Unidade Federal
String? uf;
final List<String> ufList = ['', 'AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF', 'ES', 'GO',
'MA', 'MG', 'MS', 'MT', 'PA','PB', 'PE', 'PI',  'PR', 'RJ', 'RN', 'RO', 'RR', 'RS',
'SC', 'SE', 'SP', 'TO'];


// Bloco responsável pela definição do tipo de inserção de cadastro
late String tipoParticipante;
final List<String> tiposParticipante = ['Dirigente', 'Entidade', 'Participante'];


// Lista responsável por armazenar as reuniões que cada participante pode fazer parte
List<CheckboxModel> reunioes = [];
List<CheckboxModel> reunioesMarcadas = []; 


// Máscara para o campo de celular
final contatoMask = MaskTextInputFormatter(
  mask: '(##) # ####-####',
  filter: {'#': RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

// Máscara para o campo de celular
final telFixoMask = MaskTextInputFormatter(
  mask: '(##) ####-####',
  filter: {'#': RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

// Máscara para o campo de Data
final dataMask = MaskTextInputFormatter(
  mask: '##/##/####',
  filter: {'#': RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);



class _ParticipanteDetailPageState extends State<ParticipanteDetailPage> {
  // Variáveis necessárias para uploading da imagem
  double total = 0;
  bool uploading = false;
  String title = '';
  String refImage = '';

  // ID de novo usuário
  late String id;

  @override
  void initState() {
    List<String> aux = [];
    if(widget.participante != null) {
      // Caso seja um acesso às infomações de um usuário cadastrado
      // é feita uma separação de todas as reuniões marcadas
      widget.participante!.reunioes.forEach((reuniao) => aux.add(reuniao['id']));
      // é capturado o link para acessar a foto na internet
      refImage = widget.participante!.refImage;
    } else {
      // caso seja um cadastro, é gerado um novo ID
      id = const Uuid().v1();
    }

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

        // É feita uma comparação com as reunioes cadastradas para atualizar a lista para cada participante
        for(var i = 0; i < reunioes.length; i++) {
          if(aux.contains(reunioes[i].id)) {
            reunioes[i].checked = true;
          }
        }
        setState(() => reunioes);
      }
    });

    //Título da página -> Padrão // Dinâmico
    title = (widget.participante != null)
      ? widget.participante!.nome
      : 'Cadastro de participante';

    /* 
     * Cada campo de texto é iniciado de acordo com a situação no 'initControllers()'
     * - Se for inserção de um novo registro, é vazio;
     * - Se for alteração, aparecem as informações da reunião selecionada
    */
    initControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: uploading
          ? Text('${total.round()}% enviado')
          : Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Flexible(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  border: Border.all(width: 4, color: Colors.white),
                                  boxShadow: const [
                                    BoxShadow(
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      color: Colors.deepPurple,
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                  image: refImage.isNotEmpty
                                  ?  DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(refImage),
                                    )
                                  : DecorationImage(
                                      image: Image.asset(
                                        "images/user_account.png",
                                        fit: BoxFit.cover,
                                      ).image,
                                    ),
                                ),
                                // child: Text('100%', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.purple.shade900)),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.white,
                                    ),
                                    color: Colors.deepPurple,
                                  ),
                                  child: IconButton(
                                    padding: const EdgeInsets.only(top: 0),
                                    icon: const Icon(Icons.edit),
                                    color: Colors.white,
                                    onPressed: pickAndUploadImage,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormFieldWidget(
                        label: 'Nome',
                        controller: _nomeController,
                        validator: true,
                      ),
                      TextFormFieldWidget(
                        label: 'Apelido',
                        controller: _apelidoController,
                        validator: false,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormFieldWidget(
                              label: 'Celular',
                              controller: _contatoController,
                              validator: true,
                              mask: contatoMask,
                            ),
                          ),
                          const SizedBox(width: 22),
                          Flexible(
                            child: TextFormFieldWidget(
                              label: 'Telefone',
                              controller: _telFixoController,
                              validator: false,
                              mask: telFixoMask,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormFieldWidget(
                              label: 'Data de Nascimento',
                              controller: _dataNascimentoController,
                              validator: false,
                            ),
                          ),
                          const SizedBox(width: 22),
                          Flexible(
                            child: DropdownFormFieldWidget(
                              label: 'Tipo de Participante',
                              listItems: tiposParticipante,
                              value: (widget.participante != null) ? widget.participante!.tipoParticipante : null,
                              validator: true,
                              onChanged: (escolha) => setState(() => tipoParticipante = escolha as String),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: DropdownFormFieldWidget(
                              label: 'UF',
                              listItems: ufList,
                              value: (widget.participante != null) ? widget.participante!.uf : null,
                              validator: true,
                              onChanged: (escolha) => setState(() => uf = escolha as String),
                            ),
                          ),
                          const SizedBox(width: 22),
                          Flexible(
                            flex: 3,
                            child: TextFormFieldWidget(
                              label: 'Cidade',
                              controller: _cidadeController,
                              validator: false,
                            ),
                          ),
                        ],
                      ),
                      TextFormFieldWidget(
                        label: 'Rua',
                        controller: _ruaController,
                        validator: false,
                      ),
                      TextFormFieldWidget(
                        label: 'Bairro',
                        controller: _bairroController,
                        validator: false,
                      ),
                      TextFormFieldWidget(
                        label: 'Profissão',
                        controller: _profissaoController,
                        validator: false,
                      ),
                      TextFormFieldWidget(
                        label: 'Formação Profissional',
                        controller: _formProfController,
                        validator: false,
                      ),
                      TextFormFieldWidget(
                        label: 'Local de Trabalho',
                        controller: _localTrabalhoController,
                        validator: false,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Alert que lista as reuniões cadastradas para vincular ao participante
                      TextButton(
                        child: const Text('Selecione uma reunião'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepPurple[100],
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
                      // Botão para cadastrar novo participante ou salvar as alterações no participante selecionado
                      ElevatedButton(
                        // Se não for recebido um objeto do tipo 'Reunião' o botão assume o primeiro texto, se não, o segundo
                        child: (widget.participante != null)
                          ? const Text("Salvar Alterações")
                          : const Text("Confirmar Cadastro"),
                        onPressed: () {
                          // Se foi passado o objeto para a página, abre-se um dialog a respeito do update
                          (widget.participante != null)
                            ? showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Atualizar dados da reunião ${widget.participante!.nome}?"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text("Cancelar")
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      update(widget.participante!.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Atualizar")
                                  )
                                ],
                              ),
                            )
                            : sendData();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initControllers() {
    /* Se a página não receber um objeto 'Participante' significa que é uma nova inserção
     * por isso os controllers são instanciados com uma string vazia
     * 
     * Caso seja recebido um objeto 'Participante' cada controller recebe o conteúdo
     * do campo correspondente
     */

    if(widget.participante == null) {
      tipoParticipante = '';
      _nomeController.text = '';
      _apelidoController.text = '';
      _ruaController.text = '';
      _bairroController.text = '';
      _cidadeController.text = '';
      uf = '';
      _contatoController.text = '';
      _telFixoController.text = '';
      _profissaoController.text = '';
      _formProfController.text = '';
      _localTrabalhoController.text = '';
      _dataNascimentoController.text = '';
    } else {
      setState(() {
        tipoParticipante = widget.participante!.tipoParticipante;
        _nomeController.text = widget.participante!.nome;
        _apelidoController.text = widget.participante!.apelido;
        _ruaController.text = widget.participante!.rua;
        _bairroController.text = widget.participante!.bairro;
        _cidadeController.text = widget.participante!.cidade;
        uf = widget.participante!.uf;
        _contatoController.text = widget.participante!.contato;
        _telFixoController.text = widget.participante!.telFixo;
        _profissaoController.text = widget.participante!.profissao;
        _formProfController.text = widget.participante!.formProf;
        _localTrabalhoController.text = widget.participante!.localTrabalho;
        _dataNascimentoController.text = widget.participante!.dataNascimento;
      });
    }
  }

  // Atualização do documento selecionado no registro da tela anterior
  void update(String id) {
    if(_formKey.currentState!.validate()) { 
      // Atualização de todos os campos no registro passado à esta página por parâmetro
      db.collection('participantes').doc(id).update({
        'refImage' : refImage,
        'tipoParticipante': tipoParticipante,
        'reunioes': reunioesMarcadas.map((reuniao) => reuniao.toMap()).toList(),
        'nome': _nomeController.text,
        'apelido': _apelidoController.text,
        'rua': _ruaController.text,
        'bairro': _bairroController.text,
        'cidade': _cidadeController.text,
        'uf': uf,
        'contato': _contatoController.text,
        'telFixo': _telFixoController.text,
        'profissao': _profissaoController.text,
        'formProf': _formProfController.text,
        'localTrabalho': _localTrabalhoController.text,
        'dataNascimento': _dataNascimentoController.text,
      // Confirmação visual de sucesso
      }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registro do participante ${_nomeController.text} atualizado com sucesso"),
        ),
      ));
    }
    reunioesMarcadas.forEach((e) => print(e.texto));
  }

  // Envio de dados para o banco e tratamento interno dos TextFields
  void sendData() {
    if(_formKey.currentState!.validate()) { 

      // Envio de um novo registro para o banco na coleção 'reunioes'
      db.collection('participantes').doc(id).set({
        'id': id,
        'refImage' : refImage,
        'tipoParticipante': tipoParticipante,
        'reunioes': reunioesMarcadas.map((reuniao) => reuniao.toMap()).toList(),
        'nome': _nomeController.text,
        'apelido': _apelidoController.text,
        'rua': _ruaController.text,
        'bairro': _bairroController.text,
        'cidade': _cidadeController.text,
        'uf': uf,
        'contato': _contatoController.text,
        'telFixo': _telFixoController.text,
        'profissao': _profissaoController.text,
        'formProf': _formProfController.text,
        'localTrabalho': _localTrabalhoController.text,
        'dataNascimento': _dataNascimentoController.text,
      // Confirmação visual de sucesso
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Participante ${_nomeController.text} cadastrado com sucesso"),
        ),
      );

      // Limpeza do conteúdo de todos os TextFields para uma nova inserção
      tipoParticipante = '';
      _nomeController.text = '';
      _apelidoController.text = '';
      _ruaController.text = '';
      _bairroController.text = '';
      _cidadeController.text = '';
      setState(() {
        uf = '';
        refImage = '';
      });
      _contatoController.text = '';
      _telFixoController.text = '';
      _profissaoController.text = '';
      _formProfController.text = '';
      _localTrabalhoController.text = '';
      _dataNascimentoController.text = '';
    }
  }


  // A ideia aqui seria adicionar apenas as reunioes marcadas para economizar tempo e recusos
  // Mas até o momento são adicionadas todas as reuniões selecionadas e sem a possibilidade de recuperar esses dados do banco
  List<CheckboxModel> listarSelecionados() {
    // List<CheckboxModel> itensMarcados = List.from(reunioes.where((reuniao) => reuniao.checked));
    reunioesMarcadas = [];
    reunioes.forEach((reuniao) {
      if(reuniao.checked) {
        reunioesMarcadas.add(reuniao);
      }
    });

    return reunioesMarcadas;
  }


  // Função para comprimir a imagem antes de enviar para o banco
  Future<File> compressImage(String filePath) async {
    File compressFile = await FlutterNativeImage.compressImage(filePath, quality: 70, percentage: 40);
    return compressFile;
  }

  // Função para abrir a galeria e, assim que escolhida a image, comprimí-la
  Future<File?> getImageCompress() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    File? compress;

    if(image != null) {
      compress = await compressImage(image.path);
    }

    return compress;
  }

  // Função para nomear o arquivo e enviar para o banco
  Future<UploadTask> upload(String path) async {
    File file = File(path);
    try {
      String ref = 'images/${
          (widget.participante != null)
          ? widget.participante!.id
          : id
        }.jpg';
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch(e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  pickAndUploadImage() async {
    File? file = await getImageCompress();

    if(file != null) {
      UploadTask task = await upload(file.path);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if(snapshot.state == TaskState.running) {
          setState(() {
            uploading = true;
            total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        } else if(snapshot.state == TaskState.success) {
          refImage = await snapshot.ref.getDownloadURL();
          setState(() => uploading = false);
        }
      });
    }
  }
}