import 'package:flutter/material.dart';

class DropdownListPage extends StatefulWidget {
  const DropdownListPage({ Key? key }) : super(key: key);

  @override
  State<DropdownListPage> createState() => _DropdownListPageState();
}

class _DropdownListPageState extends State<DropdownListPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // child: DropdownButton(
        //   items: [DropdownMenuItem(child: Text('Teste'),)],
        //   onChanged: (Object? value) {  },
        //   value: '',
        // ),
      ),
    );
  }
}