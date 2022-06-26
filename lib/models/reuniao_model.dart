class Reuniao {
  Reuniao({
    required this.descricao,
  });

  String descricao;

  Reuniao.fromJson(Map<String, dynamic> json)
    : descricao = json['descricao'];
  
  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
    };
  }
}