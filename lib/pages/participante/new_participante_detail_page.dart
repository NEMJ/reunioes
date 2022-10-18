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
        padding: const EdgeInsets.only(top: 30.0, right: 25, left: 25),
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
                        color: Colors.deepPurple,
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.deepPurple,
                          ),
                        ],
                        shape: BoxShape.circle,
                        // image: DecorationImage(
                        //   image: Image.asset(
                        //     'images/user_account.jpg',
                        //     fit: BoxFit.fill,
                        //   ).image,
                        // ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage("https://cdn.pixabay.com/photo/2017/11/19/07/30/girl-2961959_960_720.jpg"),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3,
                            color: Colors.white,
                          ),
                          color: Colors.deepPurple,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.only(top: 0),
                          icon: Icon(Icons.edit),
                          color: Colors.white,
                          onPressed: () {},
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