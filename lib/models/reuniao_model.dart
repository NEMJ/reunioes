import 'package:cloud_firestore/cloud_firestore.dart';

class Reuniao {
  Reuniao({
    required this.id,
    required this.descricao,
    required this.diaSemana,
    required this.horarioInicio,
    required this.horarioTermino,
  });

  String id;
  String descricao;
  String diaSemana;
  String horarioInicio;
  String horarioTermino;

  // ##### Convert para objeto Firestore #####
  factory Reuniao.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ){
    final data = snapshot.data()!;
    return Reuniao(
      id: data['id'],
      descricao: data['descricao'],
      diaSemana: data['diaSemana'],
      horarioInicio: data['horarioInicio'],
      horarioTermino: data['horarioTermino'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "descricao": descricao,
      "diaSemana": diaSemana,
      "horarioInicio": horarioInicio,
      "horarioTermino": horarioTermino
    };
  }


  // ##### Convert para JSON #####
  Reuniao.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    descricao = json['descricao'],
    diaSemana = json['diaSemana'],
    horarioInicio = json['horarioInicio'],
    horarioTermino = json['horarioTermino'];
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'diaSemana': diaSemana,
      'horarioInicio': horarioInicio,
      'horarioTermino': horarioTermino
    };
  }
}