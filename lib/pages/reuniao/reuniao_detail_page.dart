import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reunioes/models/reuniao_model.dart';
import 'package:uuid/uuid.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ReuniaoDetailPage extends StatefulWidget {
  ReuniaoDetailPage({
    Key? key,
    this.reuniao
  }) : super(key: key);

  // Caso for um novo cadastro este objeto é nulo para que o formulário esteja com os campos vazios
  Reuniao? reuniao;

  @override
  State<ReuniaoDetailPage> createState() => _ReuniaoDetailPageState();
}


// É instanciado um 'controller' para cada campo de texto
final _descricaoController = TextEditingController();
final _horarioInicioController = TextEditingController();
final _horarioTerminoController = TextEditingController();

// Instância do banco Cloud Firestore
FirebaseFirestore db = FirebaseFirestore.instance;

// GlobalKey para a validação do formulário de cadastro de reuniões
final _formKey = GlobalKey<FormState>();

String? diaSemana = '';
final List<String> diasSemana = [
  'Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'
];

// Máscara do campo de horario início / término
final horario = MaskTextInputFormatter(
  mask: '##:##',
  filter: {
    '#': RegExp(r'[0-9]'),
  },
  type: MaskAutoCompletionType.eager,
);

String? entidade = '';
List<String> et = [];

class _ReuniaoDetailPageState extends State<ReuniaoDetailPage> {
  @override
  void initState() {
    /* 
     * Cada campo de texto é iniciado de acordo com a situação no 'initControllers()'
     * - Se for inserção de um novo registro, é vazio;
     * - Se for alteração, aparecem as informações da reunião selecionada
    */
    initControllers();
    diaSemana = (widget.reuniao != null) ? widget.reuniao!.diaSemana : null;
    entidade = (widget.reuniao != null) ? widget.reuniao!.entidade : null;

    db.collection('participantes').snapshots().listen((query) {
      et = [];
      if(query.docs.isEmpty) {
        setState((){});
      } else {
        query.docs.forEach((doc) {
          if(doc.get('tipoParticipante') == 'Entidade') {
            et.add(doc.get('nome'));
          }
        });
        setState(() => et);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (widget.reuniao != null)
          ? Text(widget.reuniao!.descricao)
          : const Text("Cadastro de Reuniões"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Cada um dos campos de texto tem esse mesmo padrão
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: _descricaoController,
                        decoration: const InputDecoration(
                          labelText: 'Descricao',
                          hintText: 'Ex: Reunião Geral',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          } else if(value.length > 50) {
                            return 'Máximo 50 caracteres';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: DropdownButtonFormField(
                        items: et
                          .map((op) {
                            return DropdownMenuItem(
                              value: op,
                              child: Text(op),
                            );
                          })
                          .toList(),
                        onChanged: (escolha) => setState(() => entidade = escolha.toString()),
                        value: entidade,
                        decoration: const InputDecoration(
                          labelText: 'Entidade',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if(value == null) {
                            return 'Selecione uma entidade';
                          } else {
                            return null;
                          }
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: DropdownButtonFormField(
                        items: diasSemana
                          .map((op) => DropdownMenuItem(
                              value: op,
                              child: Text(op),
                            ),
                          )
                          .toList(),
                        onChanged: (escolha) => setState(() => diaSemana = escolha.toString()),
                        value: diaSemana,
                        decoration: const InputDecoration(
                          labelText: 'Dia da Semana',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if(value == null) {
                            return 'Selecione um dia da semana';
                          } else {
                            return null;
                          }
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: _horarioInicioController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Hora Início',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [ horario ], // Máscara específica do campo
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'Informe um horário';
                          } else if(value.length < 5) {
                            return 'Hora inválida';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: _horarioTerminoController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Hora Término',
                          labelStyle: TextStyle(fontSize: 17.5),
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [ horario ], // Máscara específica do campo
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'Informe um horário';
                          } else if(value.length < 5) {
                            return 'Hora inválida';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                // Se não for recebido um objeto do tipo 'Reunião' o botão assume o primeiro texto, se não, o segundo
                child: (widget.reuniao != null) 
                  ? const Text("Salvar Alterações")
                  : const Text("Confirmar Cadastro"),
                onPressed: () {
                  // Se foi passado o objeto para a página, abre-se um dialog de confirmação a respeito da atualização
                  (widget.reuniao != null)
                    ? showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Atualizar dados da reunião ${widget.reuniao!.descricao}?"),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Cancelar")
                          ),
                          ElevatedButton(
                            onPressed: () {
                              update(widget.reuniao!.id);
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
      ),
    );
  }

  void initControllers() {
    /* Se a página não receber um objeto 'Reuniao' significa que é uma nova inserção
     * por isso os controllers são instanciados com uma string vazia
     * 
     * Caso seja recebido um objeto 'Reuniao' cada controller recebe o conteúdo
     * do campo correspondente
     */
    
    if(widget.reuniao == null) {
      _descricaoController.text = '';
      _horarioInicioController.text = '';
      _horarioTerminoController.text = '';
    } else {
      setState(() {
        _descricaoController.text = widget.reuniao!.descricao;
        _horarioInicioController.text = widget.reuniao!.horarioInicio;
        _horarioTerminoController.text = widget.reuniao!.horarioTermino;
      });
    }
  }

  // Atualização do documento selecionado no registro da tela anterior
  void update(String id) {
    if(_formKey.currentState!.validate()) {
      // Atualização de todos os campos no registro passado à esta página por parâmetro
      db.collection('reunioes').doc(id).update({
        'descricao': _descricaoController.text,
        'entidade': entidade,
        'diaSemana': diaSemana,
        'horarioInicio': _horarioInicioController.text,
        'horarioTermino': _horarioTerminoController.text
      // Confirmação visual de sucesso
      }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Reunião '${_descricaoController.text}' atualizada com sucesso"),
        ),
      ));
    }
  }

  // Envio de dados para o banco e tratamento interno dos TextFields
  void sendData() {
    if(_formKey.currentState!.validate()) { 
      // Geração do ID aleatório
      String id = const Uuid().v1();

      // Envio de um novo registro para o banco na coleção 'reunioes'
      db.collection('reunioes').doc(id).set({
        "id": id,
        "descricao": _descricaoController.text,
        "entidade": entidade,
        "diaSemana": diaSemana,
        "horarioInicio": _horarioInicioController.text,
        "horarioTermino": _horarioTerminoController.text
      // Confirmação visual de sucesso
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Reunião '${_descricaoController.text}' salva com sucesso"),
        ),
      );

      // Limpeza do conteúdo de todos os TextFields para uma nova inserção após a confirmação
      setState(() {
        diaSemana = null;
        entidade = null;  
      });
      _descricaoController.text = '';
      _horarioInicioController.text = '';
      _horarioTerminoController.text = '';
    }
  }
}
