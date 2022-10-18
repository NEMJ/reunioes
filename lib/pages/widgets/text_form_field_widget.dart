import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  TextFormFieldWidget({
    Key? key,
    required this.controller,
    required this.label,
    required this.validator,
  }) : super(key: key);

  TextEditingController controller;
  String label;
  bool validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.deepPurple),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Colors.deepPurple)),
        ),
        validator: validator
         ? (value) {
            if(value == null || value.isEmpty) {
              return 'Informe o $label';
            }
          }
        : null
      ),
    );
  }
}