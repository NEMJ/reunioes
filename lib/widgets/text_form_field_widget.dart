import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TextFormFieldWidget extends StatelessWidget {
  TextFormFieldWidget({
    Key? key,
    required this.controller,
    required this.label,
    required this.validator,
    this.mask,
  }) : super(key: key);

  TextEditingController controller;
  String label;
  bool validator;
  MaskTextInputFormatter? mask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: TextFormField(
        controller: controller,
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
            if(value == null || value.isEmpty) {
              return 'Informe o $label';
            }
            return null;
          }
        : null,
        inputFormatters: mask != null
        ?  [ mask! ]
        : null,
      ),
    );
  }
}