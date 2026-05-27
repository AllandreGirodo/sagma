import 'package:flutter_test/flutter_test.dart';
import 'package:agenda/core/models/agendamento_model.dart';

void main() {
  test('Agendamento toMap inclui cliente_uid e fromMap prioriza cliente_uid', () {
    final ag = Agendamento(
      clienteId: 'user123',
      dataHora: DateTime.parse('2026-05-27T10:00:00'),
      tipo: 'teste',
      valorFinal: 10.0,
    );

    final map = ag.toMap();

    expect(map['cliente_uid'], 'user123');
    expect(map['cliente_id'], 'user123');

    final from = Agendamento.fromMap({
      'cliente_uid': 'user456',
      'data_hora': map['data_hora'],
      'tipo_id': 'teste',
    }, id: 'id1');

    expect(from.clienteId, 'user456');
  });
}
