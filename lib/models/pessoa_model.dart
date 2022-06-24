class Pessoa {
  Pessoa({
    required this.codigo,
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

  int codigo;
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
}