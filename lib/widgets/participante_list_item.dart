import 'package:flutter/material.dart';
import '../models/participante_model.dart';

class ParticipanteListItem extends StatelessWidget {
  const ParticipanteListItem({
    Key? key,
    required this.participante,
    }) : super(key: key);

  final Participante participante;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(participante.nome),
          ],
        ),
      ),
    );
  }
}