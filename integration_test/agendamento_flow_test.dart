import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/foundation.dart';
import 'package:agenda/config/firebase_options.dart';
import 'package:agenda/core/services/firestore_service.dart';
import 'package:agenda/core/models/agendamento_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const runFirebaseIntegration = bool.fromEnvironment(
    'RUN_FIREBASE_INTEGRATION',
    defaultValue: false,
  );

  group('Fluxo de Agendamento (E2E)', () {
    late FirestoreService service;
    final String clienteIdTeste = 'test_integration_user';
    String? agendamentoIdCriado;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      if (!kIsWeb) {
        setupFirebaseCoreMocks();
      }
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      service = FirestoreService();
    });

    tearDownAll(() async {
      if (agendamentoIdCriado != null) {
        await service.cancelarAgendamento(agendamentoIdCriado!, 'Limpeza de Teste', 'cancelado');
      }
    });

    testWidgets('Deve criar um agendamento e aprovar com sucesso', (WidgetTester tester) async {
      final dataFutura = DateTime.now().add(const Duration(days: 2));

      final novoAgendamento = Agendamento(
        clienteId: clienteIdTeste,
        dataHora: dataFutura,
        tipo: 'Massagem',
        status: 'pendente',
        valorFinal: 150.0,
        avaliacao: 0,
        comentarioAvaliacao: '',
      );

      await service.salvarAgendamento(novoAgendamento);

      final listaAposCriacao = await service.getAgendamentosDoCliente(clienteIdTeste).first;
      final agendamentoSalvo = listaAposCriacao.firstWhere(
        (a) => a.tipo == 'Massagem' && a.status == 'pendente'
      );

      expect(agendamentoSalvo, isNotNull);
      agendamentoIdCriado = agendamentoSalvo.id;
      expect(agendamentoSalvo.status, 'pendente');

      await service.atualizarStatusAgendamento(agendamentoIdCriado!, 'aprovado', clienteId: clienteIdTeste);

      final listaAposAprovacao = await service.getAgendamentosDoCliente(clienteIdTeste).first;
      final agendamentoAprovado = listaAposAprovacao.firstWhere((a) => a.id == agendamentoIdCriado);

      expect(agendamentoAprovado.status, 'aprovado');
    });
  }, skip: !runFirebaseIntegration ? 'Defina --dart-define=RUN_FIREBASE_INTEGRATION=true para executar o teste E2E com Firebase real.' : false);
}
