import 'package:flutter/material.dart';
import 'package:reunioes/models/participante_model.dart';
import 'package:reunioes/pages/widgets/text_form_field_widget.dart';
import 'package:reunioes/pages/widgets/user_profile_photo_widget.dart';

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

  TextEditingController _controller = TextEditingController();

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
              UserProfilePhotoWidget(),
              const SizedBox(height: 30),
              TextFormFieldWidget(label: 'Nome Completo', controller: _controller, validator: true),
            ],
          ),
        ),
      ),
    );
  }
}