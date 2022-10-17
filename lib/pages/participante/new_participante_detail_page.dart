import 'package:flutter/material.dart';
import 'package:reunioes/models/participante_model.dart';

class NewParticipanteDetailPage extends StatefulWidget {
  NewParticipanteDetailPage({
    Key? key,
    this.participante,
  }) : super(key: key);

  Participante? participante;

  @override
  State<NewParticipanteDetailPage> createState() => _NewParticipanteDetailPageState();
}

class _NewParticipanteDetailPageState extends State<NewParticipanteDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text( widget.participante != null
          ? widget.participante!.nome 
          : "New Participante"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black,
                          ),
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage("https://cdn.pixabay.com/photo/2017/11/19/07/30/girl-2961959_960_720.jpg"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}