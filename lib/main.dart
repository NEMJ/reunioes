import 'package:flutter/material.dart';
import 'package:reunioes/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização do Firebase para a plataforma em que o projeto está executando
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}



/*
 * ===================================================
 * ==== COISAS PARA PESQUISAR SOBRE ESTE PROJETO. ====
 * ===================================================
 * 
 * Navegação / Rotas entre telas
 * Maneiras de filtrar uma 'ListView'
 * Persistência de Dados, integração e manipulação de dados com FireBase
 * (Criar, Ler, Atualizar, Deletar dados ==> CRUD em FireBase)
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */