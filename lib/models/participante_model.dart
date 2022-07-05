class Participante {
  Participante({
    required this.id,
    required this.nome,
    this.apelido,
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this. uf,
    required this.contato,
    required this. profissao,
    required this. localTrabalho,
    required this.dataNascimento,
  });

  String id;
  String nome;
  String? apelido;
  String rua;
  String bairro;
  String cidade;
  String uf;
  String contato;
  String profissao;
  String localTrabalho;
  String dataNascimento;

  Participante.fromJason(Map<String, dynamic> json) :
    id = json['id'] as String,
    nome = json['nome'] as String,
    rua = json['rua'] as String,
    bairro = json['bairro'] as String,
    cidade = json['cidade'] as String,
    uf = json['uf'] as String,
    contato = json['contato'] as String,
    profissao = json['profissao'] as String,
    localTrabalho = json['localTrabalho'] as String,
    dataNascimento = json['dataNascimento'] as String;

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'nome' : nome,
      'rua' : rua,
      'bairro' : bairro,
      'cidade' : cidade,
      'uf' : uf,
      'contato' : contato,
      'profissao' : profissao,
      'localTrabalho' : localTrabalho,
      'dataNascimento' : dataNascimento
    };
  }
}