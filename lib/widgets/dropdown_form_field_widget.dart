import 'package:flutter/material.dart';

class DropdownFormFieldWidget extends StatefulWidget {
  DropdownFormFieldWidget({
    Key? key,
    required this.label,
    required this.listItems,
    this.value,
    required this.validator,
    required this.onChanged,
    }) : super(key: key);

  List<String> listItems;
  String label;
  String? value;
  bool validator;
  ValueChanged onChanged;

  @override
  State<DropdownFormFieldWidget> createState() => _DropdownFormFieldWidgetState();
}

class _DropdownFormFieldWidgetState extends State<DropdownFormFieldWidget> {

  late String selectedItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedItem = widget.listItems[0];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: DropdownButtonFormField(
        items: widget.listItems
          .map((op) => DropdownMenuItem(
            value: op,
            child: Text(op),
          ),
        ).toList(),
        value: widget.value,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(12, 16.4, 15, 16.4),
          labelText: widget.label,
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
        validator: widget.validator
        ? (value) {
          if(value == null) {
              return 'Selecione uma opção';
            }
            return null;
          }
        : null,
        onChanged: widget.onChanged,
      ),
    );
  }
}