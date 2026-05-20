import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:agenda/config/firebase_options.dart';
import 'package:agenda/core/services/firestore_service.dart';
import 'package:agenda/core/models/agendamento_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load .env if present but continue if missing
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final service = FirestoreService();
  final clienteId = 'integration_demo_cliente';
  final dataFutura = DateTime.now().add(const Duration(days: 3));

  final novo = Agendamento(
    clienteId: clienteId,
    dataHora: dataFutura,
    tipo: 'Massagem Teste E2E',
    status: 'pendente',
    valorFinal: 120.0,
    avaliacao: 0,
    comentarioAvaliacao: '',
  );

  try {
    print('Runner: salvando agendamento...');
    await service.salvarAgendamento(novo);

    // Aguarda o Firestore propagar e captura o agendamento salvo
    final lista = await service.getAgendamentosDoCliente(clienteId).first;
    final salvo = lista.firstWhere(
      (a) => a.tipo == 'Massagem Teste E2E' && a.status == 'pendente',
      orElse: () => throw StateError('Agendamento salvo nao encontrado'),
    );

    print('Runner: agendamento salvo id=${salvo.id}');

    print('Runner: aprovando agendamento...');
    await service.atualizarStatusAgendamento(salvo.id!, 'aprovado', clienteId: clienteId);

    final lista2 = await service.getAgendamentosDoCliente(clienteId).first;
    final aprovado = lista2.firstWhere((a) => a.id == salvo.id);

    print('AGENDAMENTO_ID:${aprovado.id}');
    print('CLIENTE_ID:${aprovado.idCliente}');
    print('DATA:${aprovado.dataHora.toIso8601String()}');
    print('TIPO:${aprovado.tipo}');
    print('STATUS:${aprovado.status}');

    // If running in a VM (desktop), exit explicitly. On web this will be ignored.
    try {
      exit(0);
    } catch (_) {
      // ignore - web build can't exit
    }
  } catch (e, st) {
    print('Runner: erro -> $e');
    print(st);
    try {
      exit(1);
    } catch (_) {}
  }
}
