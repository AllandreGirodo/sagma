import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:agenda/config/firebase_options.dart';
import 'package:agenda/core/services/firestore_service.dart';
import 'package:agenda/core/models/agendamento_model.dart';

void main() {
  const runFirebaseIntegration = bool.fromEnvironment(
    'RUN_FIREBASE_INTEGRATION',
    defaultValue: false,
  );

  test('Criar e aprovar agendamento (não deleta)', () async {
    if (!runFirebaseIntegration) {
      return;
    }

    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

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

    await service.salvarAgendamento(novo);

    // Buscar o agendamento salvo
    final lista = await service.getAgendamentosDoCliente(clienteId).first;
    final salvo = lista.firstWhere((a) => a.tipo == 'Massagem Teste E2E' && a.status == 'pendente');

    // Aprovar
    await service.atualizarStatusAgendamento(salvo.id!, 'aprovado', clienteId: clienteId);

    final lista2 = await service.getAgendamentosDoCliente(clienteId).first;
    final aprovado = lista2.firstWhere((a) => a.id == salvo.id);

    // Imprime para logs/CI retornarem
    print('AGENDAMENTO_ID:${aprovado.id}');
    print('CLIENTE_ID:${aprovado.idCliente}');
    print('DATA:${aprovado.dataHora.toIso8601String()}');
    print('TIPO:${aprovado.tipo}');
    print('STATUS:${aprovado.status}');

    expect(aprovado.status, 'aprovado');
  }, skip: !runFirebaseIntegration);
}
