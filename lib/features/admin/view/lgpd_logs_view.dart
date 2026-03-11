import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:agenda/core/services/firestore_service.dart';
import 'package:agenda/core/utils/app_strings.dart';

class AdminLgpdLogsView extends StatelessWidget {
  const AdminLgpdLogsView({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.auditoriaLgpd),
        backgroundColor: Colors.purple, // Cor distinta para indicar área sensível
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.getLgpdLogs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(AppStrings.erroGenerico('${snapshot.error}')));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final logs = snapshot.data ?? [];

          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(AppStrings.nenhumRegistroLgpd),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: logs.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final log = logs[index];
              final timestamp = log['data_hora'] as Timestamp?;
              final dataFormatada = timestamp != null 
                  ? DateFormat('dd/MM/yyyy HH:mm:ss').format(timestamp.toDate()) 
                  : AppStrings.dataDesconhecida;

              return ListTile(
                leading: const Icon(Icons.privacy_tip, color: Colors.purple),
                title: Text(log['acao'] ?? AppStrings.acaoDesconhecida, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(AppStrings.resumoLogLgpd(dataFormatada, '${log['usuario_id']}', '${log['motivo']}')),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}