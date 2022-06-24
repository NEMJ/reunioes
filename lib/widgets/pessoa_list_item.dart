import 'package:flutter/material.dart';
import '../models/pessoa_model.dart';

class PessoaListItem extends StatelessWidget {
  const PessoaListItem({
    Key? key,
    required this.pessoa,
    }) : super(key: key);

  final Pessoa pessoa;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(pessoa.nome),
        ],
      ),
    );
  }
}