import 'package:flutter/material.dart';

class FormItem extends StatelessWidget {
  const FormItem({
    Key? key, 
    required this.labelText,
    }) : super(key: key);

  final labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 17.5),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}