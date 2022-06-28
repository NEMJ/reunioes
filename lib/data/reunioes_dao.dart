import 'package:firebase_database/firebase_database.dart';
import '../models/reuniao_model.dart';

class ReunioesDao {
  final DatabaseReference _reunioesRef = FirebaseDatabase.instance.ref('reunioes');

  void saveReuniao(Reuniao reuniao) {
    _reunioesRef.push().set(reuniao.toJson());
  }

  Query getMessageQuery() {
    return _reunioesRef;
  }
}