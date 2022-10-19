import 'package:flutter/material.dart';

class DropdownFormFieldWidget extends StatelessWidget {
  DropdownFormFieldWidget({
    Key? key,
    required this.listItems,
    required this.label,
    this.value,
    required this.validator,
    required this.optionChanged
    }) : super(key: key);

  List<String> listItems;
  String label;
  String? value;
  bool validator;
  final Function? optionChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: DropdownButtonFormField(
        items: listItems
          .map((op) => DropdownMenuItem(
            value: op,
            child: Text(op),
          ),
        ).toList(),
        value: value,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.deepPurple,),
          ),
        ),
        validator: validator
        ? (value) {
          if(value == null) {
              return 'Selecione uma opção';
            }
            return null;
          }
        : null,
        onChanged: (escolha) => optionChanged,
      ),
    );
  }

  String tipo(String escolha) {
    return escolha;
  }
}