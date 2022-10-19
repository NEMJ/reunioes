import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  final CheckboxModel item;

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.item.texto),
      value: widget.item.checked,
      onChanged: (value) {
        setState((){
          widget.item.checked = value ?? false;
        });
      },
    );
  }
}

class CheckboxModel {
  CheckboxModel({
    required this.texto,
    required this.id,
    this.checked = false,
  });

  String texto;
  String id;
  bool checked;

  Map<String, dynamic> toMap() {
    return {
      'texto': texto,
      'id': id,
      'checked': checked
    };
  }
}